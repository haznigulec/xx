import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/settings_bottomsheet_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class UsSettingsPage extends StatefulWidget {
  const UsSettingsPage({super.key});

  @override
  State<UsSettingsPage> createState() => _UsSettingsPageState();
}

class _UsSettingsPageState extends State<UsSettingsPage> {
  late AppSettingsBloc _appSettingsBloc;
  late AmericanOrderTypeEnum _orderType;
  @override
  void initState() {
    super.initState();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _orderType = _appSettingsBloc.state.orderSettings.usDefaultOrderType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('us_trading_preferences'),
        ),
        body: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
          bloc: _appSettingsBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: PLoading(),
              );
            }
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: Column(
                  children: [
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    SettingsBottomsheetTile(
                      title: L10n.tr('default_order_type'),
                      selectedValue: _orderType,
                      items: AmericanOrderTypeEnum.values
                          .where((e) => e != AmericanOrderTypeEnum.trailStop)
                          .map(
                            (e) => DropdownModel(
                              name: L10n.tr(e.localizationKey),
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) {
                        setState(() {
                          _orderType = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: generalButtonPadding(
                context: context,
                child: PButton(
                  fillParentWidth: true,
                  text: L10n.tr('kaydet'),
                  variant: PButtonVariant.brand,
                  onPressed: () {
                    _appSettingsBloc.add(
                      SetOrderSettingsEvent(
                        usDefaultOrderType: _orderType,
                        onSuccess: (message, isSuccsess) async {
                          if (isSuccsess) await router.maybePop();

                          PBottomSheet.showError(
                            NavigatorKeys.navigatorKey.currentContext ?? context,
                            content: L10n.tr(
                              isSuccsess ? 'transaction_was_successfully_completed' : message,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
