import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class InnerBankListWidget extends StatelessWidget {
  final List<BankInfoModel> bankList;
  final Function(BankInfoModel) onSelectedBank;
  final ScrollController scrollController;
  final BankInfoModel selectedBank;
  const InnerBankListWidget({
    super.key,
    required this.bankList,
    required this.onSelectedBank,
    required this.scrollController,
    required this.selectedBank,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: scrollController,
      thumbVisibility: true,
      thumbColor: context.pColorScheme.iconPrimary,
      radius: const Radius.circular(2),
      thickness: 2,
      child: ListView.builder(
        controller: scrollController,
        itemCount: bankList.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          bool isSelected = selectedBank == bankList[index];
          return InkWell(
            onTap: () {
              onSelectedBank(bankList[index]);

              router.maybePop();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Grid.m,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Grid.s,
                  ),
                  child: Row(
                    spacing: Grid.s,
                    children: [
                      if (isSelected)
                        Container(
                          width: 5,
                          height: 30.0,
                          padding: const EdgeInsets.only(
                            right: Grid.s,
                          ),
                          decoration: BoxDecoration(
                            color: context.pColorScheme.primary,
                            border: Border.all(
                              width: 3.0,
                              color: context.pColorScheme.primary,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                        ),
                      SymbolIcon(
                        symbolName: bankList[index].symbolIcon ?? '',
                        symbolType: SymbolTypes.bankIcon,
                        size: 15,
                      ),
                      Text(
                        bankList[index].title ?? '',
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary.copyWith(
                          color: isSelected ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                const PDivider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
