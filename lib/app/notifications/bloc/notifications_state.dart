import 'package:piapiri_v2/app/notifications/model/notification_preferences_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

class NotificationsState extends PState {
  final int? notificationUnReadCount;
  final List<NotificationCategoryModel> notificationCategories;
  final NotificationCategoryModel? selectedCategory;
  final int pageNumber;
  final List<NotificationModel> notifications;
  final List<NotificationModel> newlyFetchedNotifications;
  final List<NotificationPreferencesModel> notificationPreferences;
  final PageState paginationState;

  const NotificationsState({
    super.type = PageState.initial,
    super.error,
    this.notificationUnReadCount,
    this.notifications = const [],
    this.selectedCategory,
    this.pageNumber = 0,
    this.notificationCategories = const [],
    this.newlyFetchedNotifications = const [],
    this.notificationPreferences = const [],
    this.paginationState = PageState.initial,
  });

  @override
  NotificationsState copyWith({
    PageState? type,
    PBlocError? error,
    int? notificationUnReadCount,
    List<NotificationCategoryModel>? notificationCategories,
    NotificationCategoryModel? selectedCategory,
    int? pageNumber,
    List<NotificationModel>? notifications,
    List<NotificationModel>? newlyFetchedNotifications,
    List<NotificationPreferencesModel>? notificationPreferences,
    PageState? paginationState,
  }) {
    return NotificationsState(
      type: type ?? this.type,
      error: error ?? this.error,
      notificationUnReadCount: notificationUnReadCount ?? this.notificationUnReadCount,
      notificationCategories: notificationCategories ?? this.notificationCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pageNumber: pageNumber ?? this.pageNumber,
      notifications: notifications ?? this.notifications,
      newlyFetchedNotifications: newlyFetchedNotifications ?? this.newlyFetchedNotifications,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      paginationState: paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        notificationUnReadCount,
        notificationCategories,
        selectedCategory,
        pageNumber,
        notifications,
        newlyFetchedNotifications,
        notificationPreferences,
        paginationState,
      ];
}
