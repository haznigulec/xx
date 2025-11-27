import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/quick_cash_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/title_total_value_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class QuickCashApproveWidget extends StatefulWidget {
  const QuickCashApproveWidget({
    super.key,
    required this.totalAmount,
    required this.currencyType,
    required this.t1CreditAmount,
    required this.t2CreditAmount,
    required this.accountExtId,
    required this.typeName,
  });
  final double totalAmount;
  final CurrencyEnum currencyType;
  final double t1CreditAmount;
  final double t2CreditAmount;
  final String accountExtId;
  final String typeName;

  @override
  State<QuickCashApproveWidget> createState() => _QuickCashApproveWidgetState();
}

class _QuickCashApproveWidgetState extends State<QuickCashApproveWidget> {
  late MoneyTransferBloc _moneyTransferBloc;

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _moneyTransferBloc.add(
      GetT0CreditTransactionExpenseInfoEvent(
        accountExtId: widget.accountExtId,
        t1CreditAmount: widget.t1CreditAmount,
        t2CreditAmount: widget.t2CreditAmount,
        onErrorCallback: () {
          router.maybePop();
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
      bloc: _moneyTransferBloc,
      builder: (context, state) {
        if (state.t0ProcessState == PageState.loading) {
          return Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m + Grid.xs,
            ),
            child: const CircularProgressIndicator(),
          );
        }

        double totalEx = (state.transactionExpense?.t1Expense ?? 0) +
            (state.transactionExpense?.t2Expense ?? 0) +
            (state.transactionExpense?.t1Bsmv ?? 0) +
            (state.transactionExpense?.t2Bsmv ?? 0);
        return Column(
          spacing: Grid.m,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: Grid.s,
            ),
            TitleTotalValueWidget(
              title: L10n.tr('amount_to_be_converted_to_cash'),
              totalValue: widget.totalAmount,
              currency: widget.currencyType.symbol,
              titleStyle: context.pAppStyle.labelReg14textPrimary,
              valueStyle: context.pAppStyle.labelMed18textPrimary,
            ),
            Text(
              '(${L10n.tr(
                'transaction_fee_reflected',
                args: [
                  '${widget.currencyType.symbol}${MoneyUtils().readableMoney(totalEx)}',
                ],
              )})',
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            OrderApprovementButtons(
              onPressedCancel: () async {
                await router.maybePop();
                return PBottomSheet.show(
                  NavigatorKeys.navigatorKey.currentContext ?? context,
                  title: L10n.tr(
                    'cash_now',
                  ),
                  child: QuickCashWidget(
                    accountExtId: widget.accountExtId,
                    currencyType: widget.currencyType,
                    typeName: widget.typeName,
                    initalAmount: widget.totalAmount,
                  ),
                );
              },
              onPressedApprove: () {
                _moneyTransferBloc.add(
                  AddT0CreditTransactionEvent(
                    accountExtId: widget.accountExtId,
                    t1CreditAmount: widget.t1CreditAmount,
                    t2CreditAmount: widget.t2CreditAmount,
                    onSuccesCallback: () async {
                      _moneyTransferBloc
                          .add(GetTradeLimitEvent(accountId: widget.accountExtId, typeName: widget.typeName));
                      _moneyTransferBloc.add(GetConvertT0Event());
                      await router.maybePop();
                      if (context.mounted) {
                        return PBottomSheet.show(
                          context,
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Column(
                              spacing: Grid.m,
                              children: [
                                const SizedBox(
                                  height: Grid.s,
                                ),
                                SvgPicture.asset(
                                  ImagesPath.check_circle,
                                  width: 56,
                                  height: 56,
                                  colorFilter: ColorFilter.mode(
                                    context.pColorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  L10n.tr('pending_trade_balance_converted_cash'),
                                  style: context.pAppStyle.labelReg16textPrimary,
                                ),
                                const SizedBox(
                                  height: Grid.xs,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    onErrorCallback: () async {
                      await router.maybePop();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
