import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/position_model.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PositionListTile extends StatelessWidget {
  final PositionModel positionModel;
  final Function() onTap;
  const PositionListTile({
    super.key,
    required this.positionModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SymbolIcon(
              symbolName: [
                SymbolTypes.future,
                SymbolTypes.option,
                SymbolTypes.warrant,
              ].contains(positionModel.symbolType)
                  ? positionModel.underlyingName
                  : positionModel.symbolName,
              symbolType: positionModel.symbolType,
              size: 28,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    positionModel.symbolName,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    positionModel.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (positionModel.symbolType == SymbolTypes.future || positionModel.symbolType == SymbolTypes.option)
              Text(
                '${MoneyUtils().readableMoney(positionModel.qty, pattern: '#,##0.#########')} ${positionModel.viopSide}',
                style: context.pAppStyle.labelMed14textPrimary.copyWith(
                  color:
                      positionModel.viopSide == 'LONG' ? context.pColorScheme.success : context.pColorScheme.critical,
                ),
              )
            else
              Text(
                '${MoneyUtils().readableMoney(positionModel.qty, pattern: '#,##0.#########')} ${L10n.tr('adet')}',
                style: context.pAppStyle.labelMed14textPrimary,
              ),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
