import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_price.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdviceCard extends StatelessWidget {
  final AdviceModel advice;
  final bool isEmpty;
  final double? elevation;
  final Color? borderColor;
  final Decoration? decoration;
  final double? bottomPadding;
  final bool isForeign;
  const AdviceCard({
    super.key,
    required this.advice,
    this.isEmpty = false,
    this.elevation = 0,
    this.borderColor,
    this.decoration,
    this.bottomPadding,
    this.isForeign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: bottomPadding ?? Grid.s,
      ),
      decoration: decoration ??
          BoxDecoration(
            color: context.pColorScheme.card,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                Grid.m,
              ),
            ),
            border: Border(
              bottom: BorderSide(
                color: borderColor ?? context.pColorScheme.transparent,
                width: 1,
              ),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(
          Grid.m,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 33,
              child: Row(
                children: [
                  SymbolIcon(
                    symbolName: advice.symbolName,
                    symbolType: isForeign ? SymbolTypes.foreign : stringToSymbolType('equity'),
                    size: 30,
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                        child: Text(
                          advice.symbolName,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 14,
                        child: Text(
                          DateTimeUtils.dateAndTimeFromDate(
                            DateTime.parse(
                              advice.created,
                            ),
                          ),
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: Grid.xs,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          advice.adviceSideId == 1
                              ? Text(
                                  L10n.tr('al'),
                                  style: context.pAppStyle.interMediumBase.copyWith(
                                    color: context.pColorScheme.success,
                                    fontSize: Grid.m - Grid.xxs,
                                  ),
                                )
                              : Text(
                                  L10n.tr('sat'),
                                  style: context.pAppStyle.interMediumBase.copyWith(
                                    color: context.pColorScheme.critical,
                                    fontSize: Grid.m - Grid.xxs,
                                  ),
                                ),
                          Text(
                            L10n.tr('research'),
                            style: context.pAppStyle.labelReg12textSecondary,
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        ImagesPath.oneri,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          advice.adviceSideId == 1 ? context.pColorScheme.success : context.pColorScheme.critical,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Text(
              advice.description ?? '',
              style: context.pAppStyle.labelReg12textPrimary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            isEmpty
                ? const SizedBox.shrink()
                : Row(
                    spacing: Grid.xs,
                    children: [
                      AdvicePrice(
                        isVertical: true,
                        title: L10n.tr('opening_price'),
                        textAlign: TextAlign.start,
                        price: advice.openingPrice,
                        isForeign: isForeign,
                      ),
                      Expanded(
                        child: AdvicePrice(
                          isVertical: true,
                          title: L10n.tr('target_price'),
                          price: advice.targetPrice,
                          isForeign: isForeign,
                        ),
                      ),
                      AdvicePrice(
                        isVertical: true,
                        title: L10n.tr('stop_loss'),
                        textAlign: TextAlign.end,
                        price: advice.stopLoss ?? 0,
                        isForeign: isForeign,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
