import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/app/app_settings/widgets/settings_tile.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/settings_bottomsheet_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/statement_preference_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OrderSettingsPage extends StatefulWidget {
  const OrderSettingsPage({super.key});

  @override
  State<OrderSettingsPage> createState() => _OrderSettingsPageState();
}

class _OrderSettingsPageState extends State<OrderSettingsPage> {
  late AuthBloc _authBloc;
  late AppSettingsBloc _appSettingsBloc;
  late bool _earningInterest;
  late bool _transactionApprovalRequest;
  late OrderCompletionEnum _orderCompletion;
  late StatementPreferenceEnum _statementPreference;
  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _appSettingsBloc.add(
      GetCustomerParametersEvent(),
    );
    _earningInterest = _appSettingsBloc.state.orderSettings.earningInterest;
    _transactionApprovalRequest = _appSettingsBloc.state.orderSettings.transactionApprovalRequest;
    _orderCompletion = _appSettingsBloc.state.orderSettings.orderCompletion;
    _statementPreference = _appSettingsBloc.state.orderSettings.statementPreference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('order_and_trade_preferences'),
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_order_settings_alert'),
              loginMessage: L10n.tr('login_order_settings_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      const OrderSettingsRoute(),
                    );
                  },
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: Grid.m),
              child: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
                bloc: _appSettingsBloc,
                builder: (context, state) {
                  _earningInterest = state.orderSettings.earningInterest;
                  _transactionApprovalRequest = state.orderSettings.transactionApprovalRequest;
                  _orderCompletion = state.orderSettings.orderCompletion;
                  _statementPreference = state.orderSettings.statementPreference;
                  return Column(
                    children: [
                      const SizedBox(
                        height: Grid.s + Grid.xxs,
                      ),
                      SettingsTile(
                        title: L10n.tr('bist_equity_trading_preferences'),
                        onTap: () => router.push(
                          const EquitySettingsRoute(),
                        ),
                      ),
                      SettingsTile(
                        title: L10n.tr('us_trading_preferences'),
                        onTap: () => router.push(
                          const UsSettingsRoute(),
                        ),
                      ),
                      SettingsTile(
                        title: L10n.tr('viop_transaction_preferences'),
                        onTap: () => router.push(
                          const ViopSettingsRoute(),
                        ),
                      ),
                      SettingsTile(
                        title: L10n.tr('mutual_fund_transaction_preferences'),
                        onTap: () => router.push(
                          const FundSettingsRoute(),
                        ),
                      ),
                      SettingsTile(
                        title: L10n.tr('depth_preferences'),
                        onTap: () => router.push(
                          const DepthSettingsRoute(),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.xxl + Grid.xxs,
                      ),
                      PSwitchRow(
                        text: L10n.tr('earning_interest'),
                        value: _earningInterest,
                        onChanged: (value) {
                          PBottomSheet.showError(context,
                              content: L10n.tr('interestPreferenceAlert'),
                              showFilledButton: true,
                              showOutlinedButton: true,
                              filledButtonText: L10n.tr('onayla'),
                              outlinedButtonText: L10n.tr('vazgeç'),
                              onOutlinedButtonPressed: () => Navigator.pop(context),
                              onFilledButtonPressed: () {
                                _appSettingsBloc.add(
                                  SetOrderSettingsEvent(
                                    earningInterest: value,
                                  ),
                                );
                                _appSettingsBloc.add(
                                  UpdateCustomerParametersEvent(
                                    interest: value,
                                    receiptType: '',
                                    onFailed: (errorMessage) {
                                      return PBottomSheet.showError(
                                        context,
                                        content: errorMessage,
                                      );
                                    },
                                  ),
                                );
                                Navigator.pop(context);
                              });
                        },
                      ),
                      const SizedBox(
                        height: Grid.m + Grid.xs,
                      ),
                      PSwitchRow(
                        text: L10n.tr('transaction_approval_request'),
                        value: _transactionApprovalRequest,
                        onChanged: (value) => _appSettingsBloc.add(
                          SetOrderSettingsEvent(
                            transactionApprovalRequest: value,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.xxl + Grid.s + Grid.xs,
                      ),
                      SettingsBottomsheetTile(
                        title: L10n.tr('order_completion_notification'),
                        selectedValue: _orderCompletion,
                        items: OrderCompletionEnum.values
                            .map(
                              (e) => DropdownModel(
                                name: L10n.tr(e.localizationKey),
                                value: e,
                              ),
                            )
                            .toList(),
                        onSelect: (value) {
                          _appSettingsBloc.add(
                            SetOrderSettingsEvent(
                              orderCompletion: value,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      SettingsBottomsheetTile(
                        title: L10n.tr('ekstre_tercihi'),
                        selectedValue: _statementPreference,
                        items: StatementPreferenceEnum.values
                            .map(
                              (e) => DropdownModel(
                                name: L10n.tr(e.localizationKey),
                                value: e,
                              ),
                            )
                            .toList(),
                        onSelect: (value) {
                          _appSettingsBloc.add(UpdateCustomerParametersEvent(
                            interest: _earningInterest,
                            receiptType: value.serviceValue,
                            onFailed: (errorMessage) {
                              return PBottomSheet.showError(
                                context,
                                content: errorMessage,
                              );
                            },
                            onSuccess: () {
                              _appSettingsBloc.add(
                                SetOrderSettingsEvent(
                                  statementPreference: value,
                                ),
                              );
                            },
                          ));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
