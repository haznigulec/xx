import 'dart:async';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/app/notifications/model/notification_preferences_model.dart';
import 'package:piapiri_v2/app/notifications/repository/notification_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

class NotificationsBloc extends PBloc<NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  NotificationsBloc({
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(initialState: const NotificationsState()) {
    on<GetNotificationUnReadCountEvent>(_onGetNotificationUnReadCount);
    on<NotificationDetailEvent>(_onGetNotificationDetail);
    on<NotificationGetCategories>(_onGetNotificationCategories);
    on<NotificationGetNotifications>(_onGetNotifications);
    on<NotificationDeleteEvent>(_onDeleteNotification);
    on<NotificationReadEvent>(_onReadNotification);
    on<NotificationSetCountByCategory>(_onSetUnreadCountByCategory);
    on<GetNotificationPreferencesByCustomerIdEvent>(_onGetNotificationPreferencesByCustomerId);
    on<GetNotificationPreferencesByDeviceIdEvent>(_onGetNotificationPreferencesByDeviceId);
    on<UpdateNotificationPreferencesByCustomerIdEvent>(_onUpdateNotificationPreferencesByCustomerId);
    on<UpdateNotificationPreferencesByDeviceIdEvent>(_onUpdateNotificationPreferencesByDeviceId);
  }

  FutureOr<void> _onGetNotificationUnReadCount(
    GetNotificationUnReadCountEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.getNotificationUnReadCount();
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          notificationUnReadCount: response.data['unreadCount'],
        ),
      );
      FlutterAppBadger.updateBadgeCount(
        response.data['unreadCount'],
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetNotificationDetail(
    NotificationDetailEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.getNotificationDetial(
      notificationId: event.notificationId,
    );
    if (response.success) {
      NotificationDetail notificationDetail = NotificationDetail.fromJson(
        response.data['notificationDetail'],
      );

      if (notificationDetail.contentId != null && notificationDetail.contentId != '0') {
        ApiResponse contentResponse = await getIt<PPApi>().matriksService.getNewsDetail(
              contentId: notificationDetail.contentId.toString(),
            );
        if (contentResponse.success) {
          notificationDetail.content =
              contentResponse.data['content'] != null && contentResponse.data['content'].toString().isNotEmpty
                  ? contentResponse.data['content']
                  : null;
        }
      }
      event.callback(notificationDetail);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetNotificationCategories(
    NotificationGetCategories event,
    Emitter<NotificationsState> emit,
  ) async {
    ApiResponse response = await _notificationsRepository.getNotificationCategories();

    if (response.success) {
      List<NotificationCategoryModel> categories = response.data['notificationCategories']
          .map<NotificationCategoryModel>(
            (e) => NotificationCategoryModel.fromJson(e),
          )
          .toList();
      NotificationCategoryModel? selectedCategory =
          categories.where((element) => element.isSelected).firstOrNull ?? state.selectedCategory;
      if (selectedCategory != null) event.callback?.call(selectedCategory);
      emit(
        state.copyWith(
          notificationCategories: categories,
          selectedCategory: selectedCategory,
          notificationUnReadCount: selectedCategory?.count ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetNotifications(
    NotificationGetNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
        paginationState: PageState.fetching,
      ),
    );
    ApiResponse response = await _notificationsRepository.getNotifications(
      event.categoryId,
      event.pageKey,
    );

    if (response.success) {
      List<NotificationModel> notificationList = List.from(state.notifications);

      List<NotificationModel> newNotifications = [];
      final respNotifications = response.data?['notifications'];
      if (respNotifications != null && respNotifications is List) {
        newNotifications.addAll(respNotifications
            .map<NotificationModel>(
              (e) => NotificationModel.fromJson(e),
            )
            .toList());
      }

      if (event.pageKey == 0) {
        notificationList = newNotifications;
      } else {
        notificationList.addAll(newNotifications);
      }
      emit(
        state.copyWith(
          type: PageState.success,
          paginationState: PageState.success,
          notifications: notificationList,
          newlyFetchedNotifications: newNotifications,
          pageNumber: event.pageKey,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          paginationState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onDeleteNotification(
    NotificationDeleteEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    ApiResponse response = await _notificationsRepository.deleteNotification(
      categoryId: event.categoryId,
      notificationId: event.notificationId,
    );

    if (response.success) {
      event.callback?.call();
    }
  }

  FutureOr<void> _onReadNotification(
    NotificationReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    ApiResponse response = await _notificationsRepository.readNotification(
      categoryId: event.categoryId,
      notificationId: event.notificationId,
      isRead: event.isRead,
    );

    if (response.success) {
      event.callback?.call();
    }
  }

  FutureOr<void> _onSetUnreadCountByCategory(
    NotificationSetCountByCategory event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    NotificationCategoryModel selectedCategory =
        state.notificationCategories.firstWhere((element) => element.categoryId == event.categoryId);

    emit(
      state.copyWith(
        type: PageState.success,
        notificationUnReadCount: selectedCategory.count,
      ),
    );
  }

  FutureOr<void> _onGetNotificationPreferencesByCustomerId(
    GetNotificationPreferencesByCustomerIdEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.getNotificationPreferencesByCustomerID();

    if (response.success) {
      List<NotificationPreferencesModel> preferences = response.data['preferences']
          .map<NotificationPreferencesModel>((element) => NotificationPreferencesModel.fromJson(element))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          notificationPreferences: preferences,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetNotificationPreferencesByDeviceId(
    GetNotificationPreferencesByDeviceIdEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.getNotificationPreferencesByDeviceID();

    if (response.success) {
      List<NotificationPreferencesModel> preferences = response.data['preferences']
          .map<NotificationPreferencesModel>((element) => NotificationPreferencesModel.fromJson(element))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          notificationPreferences: preferences,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateNotificationPreferencesByCustomerId(
    UpdateNotificationPreferencesByCustomerIdEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.updateNotificationPreferencesByCustomerId(
      event.list,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateNotificationPreferencesByDeviceId(
    UpdateNotificationPreferencesByDeviceIdEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _notificationsRepository.updateNotificationPreferencesByDeviceId(
      event.list,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05NOTF08',
          ),
        ),
      );
    }
  }
}
