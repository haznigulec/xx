import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/app/notifications/model/notification_preferences_model.dart';
import 'package:piapiri_v2/app/notifications/widget/notification_preference_tile.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late NotificationsBloc _notificationsBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _notificationsBloc = getIt<NotificationsBloc>();
    _authBloc = getIt<AuthBloc>();

    if (_authBloc.state.isLoggedIn) {
      _notificationsBloc.add(
        GetNotificationPreferencesByCustomerIdEvent(),
      );
    } else {
      _notificationsBloc.add(
        GetNotificationPreferencesByDeviceIdEvent(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<NotificationsBloc, NotificationsState>(
      bloc: _notificationsBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
              appBar: PInnerAppBar(
                title: L10n.tr('bildirim_ayarlari'),
              ),
              body: const PLoading());
        }

        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('bildirim_ayarlari'),
          ),
          body: state.notificationPreferences.isEmpty
              ? NoDataWidget(
                  message: L10n.tr('no_data'),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: Grid.m,
                      ),
                      ListView.separated(
                        itemCount: state.notificationPreferences.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const PDivider(
                          padding: EdgeInsets.symmetric(
                            vertical: Grid.m,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          NotificationPreferencesModel preference = state.notificationPreferences[index];

                          return NotificationPreferenceTile(
                            preference: preference,
                            preferenceList: state.notificationPreferences,
                            onTap: () => _showNotificationCategoryList(
                              state.notificationPreferences,
                              preference,
                            ),
                          );
                        },
                      ),
                      const PDivider(
                        padding: EdgeInsets.only(
                          top: Grid.m,
                          bottom: Grid.m + Grid.xs,
                        ),
                      ),
                      PInfoWidget(
                        infoText: L10n.tr('bildirim_ayarlari_aciklama'),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: generalButtonPadding(
            context: context,
            child: PButton(
              text: L10n.tr('kaydet'),
              fillParentWidth: true,
              onPressed: () => _doSave(
                state.notificationPreferences,
              ),
            ),
          ),
        );
      },
    );
  }

  _showNotificationCategoryList(
    List<NotificationPreferencesModel> preferenceList,
    NotificationPreferencesModel preference,
  ) {
    PBottomSheet.show(
      context,
      title: L10n.tr('advices'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        itemCount: preference.children.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) {
          Children children = preference.children[index];

          return BottomsheetSelectTile(
            title: children.key == 'just_notification_center' ? L10n.tr('push_notification_off') : children.title,
            isSelected: preference.value == children.value,
            subTitleWidget: children.key == 'just_notification_center'
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.s,
                    ),
                    child: Text(
                      L10n.tr('push_notification_off_desc'),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelReg12textSecondary,
                    ),
                  )
                : null,
            value: children,
            onTap: (_, value) {
              setState(() {
                preference.value = children.value;

                int count = preferenceList.where((element) => element.value == '1').length;

                if (count < 2) {
                  ///  En az 2 tane kateroginin açık olması gerektiğinin kontrolü.
                  preference.value = '1';
                }
              });

              router.maybePop();
            },
          );
        },
      ),
    );
  }

  _doSave(
    List<NotificationPreferencesModel> preferenceList,
  ) async {
    List<Map<String, dynamic>> preferences = [];

    for (var element in preferenceList) {
      preferences.add({
        'key': element.key,
        'value': element.value,
      });
    }

    if (_authBloc.state.isLoggedIn) {
      _notificationsBloc.add(
        /// login olan kullanıcının ayarlarının değiştiği api.
        UpdateNotificationPreferencesByCustomerIdEvent(
          list: preferences,
        ),
      );
    } else {
      _notificationsBloc.add(
        /// login olmayan kullanıcının ayarlarının değiştiği api.
        UpdateNotificationPreferencesByDeviceIdEvent(
          list: preferences,
        ),
      );
    }
    router.maybePop();
  }
}
