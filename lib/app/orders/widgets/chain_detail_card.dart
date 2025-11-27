import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_add_chain_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ChainDetailCard extends StatelessWidget {
  final int subChainUnit;
  final String symbolCode;
  final int sideType;
  final double remainingUnit;
  final double realizedUnit;
  final Widget expanded;
  final bool? initExpanded;
  final double rightPadding;
  final TransactionModel selected;
  final bool isMainOrder;
  final Function(bool isExpanded) onTap;

  const ChainDetailCard({
    super.key,
    required this.subChainUnit,
    required this.symbolCode,
    required this.sideType,
    required this.remainingUnit,
    required this.realizedUnit,
    required this.expanded,
    this.initExpanded = false,
    required this.rightPadding,
    required this.selected,
    this.isMainOrder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ExpandableController controller = ExpandableController(
      initialExpanded: initExpanded,
    );

    controller.expanded = true;

    return ExpandableNotifier(
      child: ExpandablePanel(
        controller: controller,
        theme: const ExpandableThemeData(
          hasIcon: false,
          tapBodyToCollapse: false,
          bodyAlignment: ExpandablePanelBodyAlignment.right,
          tapHeaderToExpand: false,
        ),
        expanded: expanded,
        collapsed: const SizedBox.shrink(),
        header: InkWell(
          onTap: () {
            router.push(
              OrderDetailRoute(
                selectedOrder: selected,
                orderStatus: OrderStatusEnum.pending,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              top: Grid.s,
              bottom: Grid.s,
              right: rightPadding,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.pColorScheme.line,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(
              Grid.s,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('zincir_ekle'),
                      child: OrderDetailAddChainWidget(
                        selectedOrder: selected,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.s,
                    ),
                    child: SvgPicture.asset(
                      ImagesPath.plus,
                      width: 15,
                      height: 15,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SymbolIcon(
                  symbolName: symbolCode,
                  symbolType: stringToSymbolType(
                    selected.symbolType!.name,
                  ),
                  size: 28,
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          symbolCode,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: context.pColorScheme.textPrimary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                Grid.m,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        Text(
                          sideType == 1 ? L10n.tr('alis').toUpperCase() : L10n.tr('satis').toUpperCase(),
                          style: context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.m - Grid.xxs,
                            color: sideType == 1 ? context.pColorScheme.success : context.pColorScheme.critical,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Grid.xs,
                    ),
                    Text(
                      L10n.tr(selected.symbolType!.name),
                      style: context.pAppStyle.labelReg12textSecondary,
                    )
                  ],
                ),
                const Spacer(),
                isMainOrder
                    ? SizedBox(
                        height: 40,
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${L10n.tr('gerceklesen_adet')} : ${realizedUnit.toInt()}',
                              textAlign: TextAlign.end,
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                            const SizedBox(
                              height: Grid.xs,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '₺${MoneyUtils().readableMoney(selected.orderPrice ?? selected.price ?? 0)}',
                                  textAlign: TextAlign.end,
                                  style: context.pAppStyle.labelMed12textPrimary,
                                ),
                                const SizedBox(
                                  width: Grid.xs,
                                ),
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: context.pColorScheme.textPrimary,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        Grid.m,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: Grid.xs,
                                ),
                                Text(
                                  '${(selected.remainingUnit ?? selected.orderUnit ?? selected.units ?? 0).toInt()} ${L10n.tr('adet')}',
                                  textAlign: TextAlign.end,
                                  style: context.pAppStyle.labelMed12textPrimary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            '₺${MoneyUtils().readableMoney(selected.orderPrice ?? selected.price ?? 0)}',
                            style: context.pAppStyle.labelMed12textPrimary,
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: context.pColorScheme.textPrimary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  Grid.m,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          Text(
                            '${(selected.orderUnit ?? selected.units ?? 0).toInt()} ${L10n.tr('adet')}',
                            style: context.pAppStyle.labelMed12textPrimary,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
