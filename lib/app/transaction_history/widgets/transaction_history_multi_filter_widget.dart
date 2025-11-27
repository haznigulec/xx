import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_filter_panel.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_account_filter_widget.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_type_filter_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionHistoryMultiFilterWidget extends StatefulWidget {
  final TransactionMainTypeEnum selectedTransactionMainType;
  final Function(TransactionHistoryTypeEnum?, AccountModel?) onSelectedTransactionTypeAndAccount;
  const TransactionHistoryMultiFilterWidget({
    super.key,
    required this.onSelectedTransactionTypeAndAccount,
    required this.selectedTransactionMainType,
  });

  @override
  State<TransactionHistoryMultiFilterWidget> createState() => _TransactionHistoryMultiFilterWidgetState();
}

class _TransactionHistoryMultiFilterWidgetState extends State<TransactionHistoryMultiFilterWidget> {
  final List<RadioModel> _sourcesList = [];
  int _selectedSourceIndex = 0;
  TransactionHistoryTypeEnum? _transactionTypeEnum;
  AccountModel? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _transactionTypeEnum = getIt<TransactionHistoryBloc>().state.transactionHistoryFilter.transactionType;
    _sourcesList.add(
      RadioModel(
        true,
        L10n.tr('direction_of_transaction'),
      ),
    );

    // if (widget.selectedTransactionMainType != TransactionMainTypeEnum.americanStockExchanges) {
    _sourcesList.add(
      RadioModel(
        false,
        L10n.tr('account_selection'),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              spacing: Grid.s,
              children: [
                Expanded(
                  flex: 3,
                  child: _sourcesWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Grid.m - Grid.xs,
                    right: Grid.s,
                  ),
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: context.pColorScheme.line,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: DynamicIndexedStack(
                      index: _selectedSourceIndex,
                      children: [
                        TransactionTypeFilterWidget(
                          transactionTypeEnum: _transactionTypeEnum,
                          onSelectedType: (selectedType) {
                            setState(() {
                              _transactionTypeEnum = selectedType;
                            });
                          },
                        ),
                        TransactionHistoryAccountFilterWildget(
                          selectedAccount: _selectedAccount,
                          onSelectedAccount: (selectedAccount) {
                            setState(() {
                              _selectedAccount = selectedAccount;
                            });
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              widget.onSelectedTransactionTypeAndAccount(
                _transactionTypeEnum,
                _selectedAccount,
              );

              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _sourcesWidget() {
    List<Widget> sourcesListWidget = [
      const SizedBox(
        height: Grid.s,
      )
    ];

    for (var i = 0; i < _sourcesList.length; i++) {
      sourcesListWidget.add(
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: () {
            setState(() {
              if (_selectedSourceIndex == i) {
                _sourcesList[i].isSelected = true;
              } else {
                _sourcesList[i].isSelected = false;
              }
              _selectedSourceIndex = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.s + Grid.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    border: Border.all(
                      width: 3.0,
                      color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.xs + Grid.xxs,
                    ),
                    child: Text(
                      _sourcesList[i].text,
                      style: context.pAppStyle.labelMed16textPrimary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sourcesListWidget,
    );
  }
}
