import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/in_app_webview_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class NotificationDetailPage extends StatefulWidget {
  final NotificationModel selectedNotificationModel;
  final NotificationDetail? selectedNotificationDetail;

  const NotificationDetailPage({
    super.key,
    required this.selectedNotificationModel,
    required this.selectedNotificationDetail,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final NotificationsBloc _notificationBloc = getIt<NotificationsBloc>();
  NotificationDetail? _notificationDetailModel;
  InAppWebViewController? webViewController;
  @override
  void initState() {
    super.initState();
    if (widget.selectedNotificationDetail != null) {
      _notificationDetailModel = widget.selectedNotificationDetail;
    } else {
      _notificationBloc.add(
        NotificationDetailEvent(
          notificationId: widget.selectedNotificationModel.notificationId,
          callback: (notificationDetailModel) {
            setState(() {
              _notificationDetailModel = notificationDetailModel;
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<NotificationsBloc, NotificationsState>(
      bloc: _notificationBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('notification_detail'),
            ),
            body: const PLoading(),
          );
        }

        if (_notificationDetailModel == null) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('notification_detail'),
            ),
            body: NoDataWidget(
              message: L10n.tr('no_data'),
            ),
          );
        }

        bool isEmptySymbolTags =
            _notificationDetailModel!.symbolTags == null || _notificationDetailModel!.symbolTags!.isEmpty;

        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('notification_detail'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: Grid.s,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedNotificationModel.title,
                            textAlign: TextAlign.start,
                            style: context.pAppStyle.labelMed16textPrimary,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Text(
                            '${DateTimeUtils.dateFormat(
                              DateTime.parse(
                                widget.selectedNotificationModel.createdDay,
                              ),
                            )}, ${DateTimeUtils.strTimeFromDate(
                              date: DateTime.parse(
                                widget.selectedNotificationModel.createdTime,
                              ),
                            )}',
                            style: context.pAppStyle.labelMed14textSecondary,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          if (!isEmptySymbolTags) ...[
                            SymbolChipsWidget(
                              symbolList: _notificationDetailModel!.symbolTags!,
                            ),
                            const SizedBox(
                              height: Grid.m,
                            ),
                          ],
                          if (_notificationDetailModel!.externalLink!.isNotEmpty)
                            InkWell(
                              onTap: () => router.push(
                                NotificationDetailWebViewRoute(
                                  url: _notificationDetailModel!.externalLink!,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: Grid.s),
                                child: Text(
                                  L10n.tr('click_for_detail'),
                                ),
                              ),
                            ),
                          if (_notificationDetailModel!.fileUrl!.isNotEmpty)
                            InkWell(
                              onTap: () => router.push(
                                NotificationDetailPdfRoute(
                                  pdfUrl: _notificationDetailModel!.fileUrl!,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: Grid.s),
                                child: Text(
                                  L10n.tr('click_for_file'),
                                ),
                              ),
                            ),
                          if (_notificationDetailModel!.content != null)
                            _contentInAppWebview(_notificationDetailModel!.content!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contentInAppWebview(String content) {
    Random random = Random();
    int randomNumber = random.nextInt(100);

    return Expanded(
      child: InAppWebviewWidget(
        text: content,
        id: randomNumber.toString(),
      ),
    );
  }
}
