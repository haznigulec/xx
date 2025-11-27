import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/settings_bottomsheet_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ViopSettingsPage extends StatefulWidget {
  const ViopSettingsPage({super.key});

  @override
  State<ViopSettingsPage> createState() => _ViopSettingsPageState();
}

class _ViopSettingsPageState extends State<ViopSettingsPage> {
  late AppSettingsBloc _appSettingsBloc;
  final List<AccountModel> _accountList = [];
  late AccountModel _account;
  late OptionOrderTypeEnum _orderType;
  late OptionOrderValidityEnum _orderValidity;

  @override
  void initState() {
    super.initState();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _accountList
        .addAll(UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.turkishLira).toList());
    _account = _accountList.firstWhere(
      (element) =>
          element.accountId.split('-').last == _appSettingsBloc.state.orderSettings.viopDefaultAccount,
    );
    _orderType = _appSettingsBloc.state.orderSettings.viopDefaultOrderType;
    _orderValidity = _appSettingsBloc.state.orderSettings.viopDefaultValidity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('viop_transaction_preferences'),
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
                      title: L10n.tr('default_account'),
                      selectedValue: _account,
                      items: _accountList
                          .map(
                            (e) => DropdownModel(
                              name: e.accountId,
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) => setState(() {
                        _account = value;
                      }),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    SettingsBottomsheetTile(
                      title: L10n.tr('default_order_type'),
                      selectedValue: _orderType,
                      items: OptionOrderTypeEnum.values
                          .map(
                            (e) => DropdownModel(
                              name: L10n.tr(e.localizationKey),
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) => setState(() {
                        _orderType = value;
                      }),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    SettingsBottomsheetTile(
                      title: L10n.tr('default_validity'),
                      selectedValue: _orderValidity,
                      items: OptionOrderValidityEnum.values
                          .map(
                            (e) => DropdownModel(
                              name: L10n.tr(e.localizationKey),
                              value: e,
                            ),
                          )
                          .toList(),
                      onSelect: (value) => setState(() {
                        _orderValidity = value;
                      }),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: generalButtonPadding(
                context: context,
                child: PButton(
                  variant: PButtonVariant.brand,
                  fillParentWidth: true,
                  text: L10n.tr('kaydet'),
                  onPressed: () {
                    _appSettingsBloc.add(
                      SetOrderSettingsEvent(
                        viopDefaultAccount: _account.accountId.split('-').last,
                        viopDefaultOrderType: _orderType,
                        viopDefaultValidity: _orderValidity,
                        onSuccess: (message, isSuccsess) async {
                          if (isSuccsess) {
                            await router.maybePop();
                          }
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
