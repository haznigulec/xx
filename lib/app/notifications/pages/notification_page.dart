import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/app/notifications/widget/notification_item.dart';
import 'package:piapiri_v2/app/notifications/widget/unread_count_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  final NotificationModel? remoteNotificationModel;
  final NotificationDetail? remoteNotificationDetail;

  const NotificationPage({
    this.remoteNotificationModel,
    this.remoteNotificationDetail,
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _selectedNotificationCategoryTitle = '';
  int _selectedNotificationCategoryId = 0;
  ScrollController? _scrollController;
  late AuthBloc _authBloc;
  late NotificationsBloc _notificationBloc;
  late PagingController _pagingController;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _notificationBloc = getIt<NotificationsBloc>();
    _scrollController = ScrollController();
    _pagingController = PagingController<int, Widget>(firstPageKey: 0);
    _pagingController.addPageRequestListener((_) => _pageRequestListener(_));
    if (_authBloc.state.isLoggedIn) {
      _notificationBloc.add(
        NotificationGetCategories(
          callback: (NotificationCategoryModel selectedCategory) {
            if (!mounted) return;
            setState(() {
              _selectedNotificationCategoryTitle = selectedCategory.title;
              _selectedNotificationCategoryId = selectedCategory.categoryId;
            });
          },
        ),
      );
    }

    if (_authBloc.state.isLoggedIn &&
        widget.remoteNotificationModel != null &&
        widget.remoteNotificationDetail != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final notificationModel = widget.remoteNotificationModel!;
          final notificationDetail = widget.remoteNotificationDetail!;
          getIt<NotificationHandler>().performNotificationAction(
            action: notificationModel.notificationActionType ?? '',
            params: notificationModel.notificationActionParams ?? '',
            tags: notificationModel.tags.join(','),
            externalLink: notificationModel.externalLink,
            fileUrl: notificationModel.fileUrl,
            notificationModel: notificationModel,
            notificationDetail: notificationDetail,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _pagingController.removePageRequestListener((_) => _pageRequestListener(_));
    _readCount(0);
    super.dispose();
  }

  void _pageRequestListener(int page) {
    _notificationBloc.add(
      NotificationGetNotifications(
        categoryId: _selectedNotificationCategoryId,
        pageKey: page,
      ),
    );
  }

  void _appendNotifications(
    List<NotificationModel> notifications,
    int page,
  ) {
    /// Bildirimleri listelerken pagination mantığı uygulandıgı, bildirimleri 20 şer 20 şer yüklemek için ayarlanan yer.
    final List<Widget> notificationList = _prepareNotifications(notifications);
    final isLastPage = notificationList.length < 20;
    if (isLastPage) {
      _pagingController.appendLastPage(notificationList);
    } else {
      _pagingController.appendPage(notificationList, page + 1);
    }
  }

  List<Widget> _prepareNotifications(List<NotificationModel> notifications) {
    return notifications
        .map<NotificationItem>(
          (e) => NotificationItem(
            notification: e,
            categoryId: _selectedNotificationCategoryId,
            deletedNotification: (notificationId) {
              _notificationBloc.add(
                NotificationDeleteEvent(
                  notificationId: notificationId,
                  callback: () {
                    /// bildirimi silme işinden sonra, sildiğimiz bildirimi listeden kaldırıyoruz
                    notifications.remove(e);
                    _pagingController.itemList = _prepareNotifications(notifications);

                    /// silme işleminden sonra bildirimler tekrar çekiliyor
                    _readCount(_selectedNotificationCategoryId);
                  },
                ),
              );
            },
            makeAsRead: () => _readCount(_selectedNotificationCategoryId),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, appInfoState) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('bildirim_merkezi'),
            actions: [
              if (appInfoState.isLoggedIn)
                GestureDetector(
                  onTap: () {
                    router.push(
                      const NotificationSettingsRoute(),
                    );
                  },
                  child: SvgPicture.asset(
                    ImagesPath.setting,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: !appInfoState.isLoggedIn
                ? SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: CreateAccountWidget(
                      memberMessage: L10n.tr('create_account_notification'),
                      loginMessage: L10n.tr('login_notification_alert'),
                      onLogin: () => router.popAndPush(
                        AuthRoute(
                          afterLoginAction: () async {
                            router.push(
                              NotificationRoute(
                                remoteNotificationModel: widget.remoteNotificationModel,
                                remoteNotificationDetail: widget.remoteNotificationDetail,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PBlocBuilder<NotificationsBloc, NotificationsState>(
                          bloc: _notificationBloc,
                          builder: (context, state) => _categoryWidgets(
                            state.notificationCategories,
                            state,
                          ),
                        ),
                        PBlocConsumer<NotificationsBloc, NotificationsState>(
                          bloc: _notificationBloc,
                          listenWhen: (previous, current) =>
                              previous.paginationState == PageState.fetching &&
                              current.paginationState == PageState.success,
                          listener: (context, state) {
                            _appendNotifications(
                              state.newlyFetchedNotifications,
                              state.pageNumber,
                            );
                          },
                          builder: (context, state) {
                            return Expanded(
                              child: PagedListView(
                                pagingController: _pagingController,
                                builderDelegate: PagedChildBuilderDelegate<Widget>(
                                  itemBuilder: (_, dynamic item, __) {
                                    return item as Widget;
                                  },
                                  noItemsFoundIndicatorBuilder: (context) => NoDataWidget(
                                    iconName: ImagesPath.notificationOff,
                                    message: L10n.tr('no_pending_notification'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _categoryWidgets(
    List<NotificationCategoryModel> categories,
    NotificationsState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PCustomOutlinedButtonWithIcon(
            text: L10n.tr(
                _selectedNotificationCategoryTitle == 'all' ? 'all_notifications' : _selectedNotificationCategoryTitle),
            iconSource: ImagesPath.chevron_down,
            onPressed: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('notifications'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const PDivider(),
                  itemBuilder: (context, index) {
                    final NotificationCategoryModel category = categories[index];

                    return BottomsheetSelectTile(
                      title: L10n.tr(
                        category.key == 'all' ? 'all_notifications' : category.key,
                      ),
                      isSelected: category.categoryId == _selectedNotificationCategoryId,
                      value: category,
                      onTap: (title, value) {
                        router.maybePop();
                        NotificationCategoryModel category = value;
                        _notificationBloc.add(
                          NotificationSetCountByCategory(
                            categoryId: category.categoryId,
                          ),
                        );
                        setState(() {
                          _selectedNotificationCategoryId = category.categoryId;
                          _selectedNotificationCategoryTitle = category.title;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _pagingController.refresh();
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          if (state.notifications.isNotEmpty) ...[
            const SizedBox(
              width: Grid.xs,
            ),
            Row(
              children: [
                PBlocBuilder<NotificationsBloc, NotificationsState>(
                    bloc: _notificationBloc,
                    builder: (context, state) {
                      return UnReadCountWidget(
                        /// Kategorilere göre okunmamış bildirim sayısı
                        unReadCount: state.notificationUnReadCount ?? 0,
                      );
                    }),
                const SizedBox(
                  width: Grid.s + Grid.xs,
                ),
                InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SvgPicture.asset(
                                ImagesPath.notification,
                                width: 40,
                                height: 40,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: context.pColorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Text(
                            L10n.tr(
                              'un_read_notification_message',
                              args: [
                                '${state.notificationUnReadCount ?? 0}',
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          POutlinedButton(
                            text: L10n.tr('clear_all_notifications'),
                            fillParentWidth: true,
                            onPressed: () => _deleteAll(),
                          ),
                          const SizedBox(
                            height: Grid.s + Grid.xs,
                          ),
                          PButton(
                            text: L10n.tr('tumunu_okundu_olarak_isaretle'),
                            fillParentWidth: true,
                            onPressed: () => _markAllAsRead(),
                          ),
                          const SizedBox(
                            height: Grid.xs,
                          ),
                        ],
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    ImagesPath.brush,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  _markAllAsRead() async {
    /// Tümünü okundu olarak işaretlemek için kullanılan event.
    _notificationBloc.add(
      NotificationReadEvent(
        categoryId: _selectedNotificationCategoryId,
        notificationId: const [0],
        callback: () async {
          FlutterAppBadger.removeBadge();

          /// Uygulamanın üzerinde badge numarasını sıfırlar.
          _readCount(_selectedNotificationCategoryId);
          _pagingController.refresh();
        },
        isRead: true,
      ),
    );

    router.maybePop();
  }

  _deleteAll() async {
    _notificationBloc.add(
      NotificationDeleteEvent(
        categoryId: _selectedNotificationCategoryId,
        notificationId: const [0],
        callback: () async {
          FlutterAppBadger.removeBadge();
          _readCount(_selectedNotificationCategoryId);
          _pagingController.itemList?.clear();
          setState(() {});
        },
      ),
    );

    router.maybePop();
  }

  _readCount(int categoryId) {
    if (getIt<AuthBloc>().state.isLoggedIn) {
      _notificationBloc.add(
        NotificationGetCategories(),
      );
    }
  }
}
