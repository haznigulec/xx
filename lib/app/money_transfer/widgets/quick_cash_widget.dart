import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/quick_cash_approve_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/quick_cash_limit_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/title_total_value_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class QuickCashWidget extends StatefulWidget {
  const QuickCashWidget({
    super.key,
    required this.currencyType,
    required this.accountExtId,
    required this.typeName,
    this.initalAmount,
  });

  final CurrencyEnum currencyType;
  final String accountExtId;
  final String typeName;
  final double? initalAmount;

  @override
  State<QuickCashWidget> createState() => _QuickCashWidgetState();
}

class _QuickCashWidgetState extends State<QuickCashWidget> {
  late ContractsBloc _contractsBloc;
  late MoneyTransferBloc _moneyTransferBloc;

  late final TextEditingController _amountController;
  late final ValueNotifier<bool> _buttonEnabled;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _contractsBloc.add(
      GetGtpContractEvent(
        onErrorCallback: () {
          router.maybePop();
        },
      ),
    );
    _amountController = TextEditingController(text: MoneyUtils().readableMoney(widget.initalAmount ?? 0));
    _buttonEnabled = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _buttonEnabled.dispose();
    super.dispose();
  }

  _openContract() {
    router.push(
      T0ContractRoute(
        accountExtId: widget.accountExtId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
      bloc: _moneyTransferBloc,
      builder: (context, moneyState) {
        return PBlocBuilder<ContractsBloc, ContractsState>(
          bloc: _contractsBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.m + Grid.xs,
                ),
                child: const CircularProgressIndicator(),
              );
            }

            if (!state.t0ContractIsAccepted) {
              return Column(
                spacing: Grid.m,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StyledText(
                    text: L10n.tr(
                      'approve_contract_for_quick_cash',
                      namedArgs: {
                        'contractname': '<bold>${L10n.tr('t0_credit_contract')}</bold>',
                      },
                    ),
                    textAlign: TextAlign.center,
                    style: context.pAppStyle.labelReg16textPrimary,
                    tags: {
                      'bold': StyledTextTag(
                        style: context.pAppStyle.labelMed16textPrimary,
                      ),
                    },
                  ),
                  InkWell(
                    onTap: () => _openContract(),
                    child: Text(
                      L10n.tr('show_t0_contract'),
                      textAlign: TextAlign.center,
                      style: context.pAppStyle.labelReg16primary,
                    ),
                  ),
                  const SizedBox(height: Grid.s),
                  OrderApprovementButtons(
                    onPressedApprove: () => _openContract(),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QuickCashLimitWidget(
                  currencyType: widget.currencyType,
                  amountController: _amountController,
                  totalAmount: (moneyState.t1CreditNetLimit ?? 0) + (moneyState.t2CreditNetLimit ?? 0),
                  buttonEnabled: _buttonEnabled,
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                TitleTotalValueWidget(
                  title: L10n.tr('balance_pending_clearing'),
                  currency: widget.currencyType.symbol,
                  totalValue: (moneyState.t1CreditNetLimit ?? 0) + (moneyState.t2CreditNetLimit ?? 0),
                  titleStyle: context.pAppStyle.labelReg12textPrimary,
                  valueStyle: context.pAppStyle.labelMed16textPrimary,
                ),
                const SizedBox(
                  height: Grid.l,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _buttonEnabled,
                  builder: (context, isEnable, Widget? child) => OrderApprovementButtons(
                    onPressedApprove: isEnable
                        ? () async {
                            double t1CreditAmount = 0;
                            double t2CreditAmount = 0;
                            double totalAmount = MoneyUtils().fromReadableMoney(_amountController.text.toString());
                            if (totalAmount > (moneyState.t1CreditNetLimit ?? 0)) {
                              t1CreditAmount = (moneyState.t1CreditNetLimit ?? 0);
                              t2CreditAmount = totalAmount - (moneyState.t1CreditNetLimit ?? 0);
                            } else {
                              t1CreditAmount = totalAmount;
                            }
                            await router.maybePop();
                            return PBottomSheet.show(
                              NavigatorKeys.navigatorKey.currentContext ?? context,
                              title: L10n.tr('quick_cash_aprove'),
                              child: QuickCashApproveWidget(
                                totalAmount: totalAmount,
                                currencyType: widget.currencyType,
                                t1CreditAmount: t1CreditAmount,
                                t2CreditAmount: t2CreditAmount,
                                accountExtId: widget.accountExtId,
                                typeName: widget.typeName,
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
