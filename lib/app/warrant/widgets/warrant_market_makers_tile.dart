import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';

class WarrantMarketMakersTile extends StatelessWidget {
  final WarrantDropdownModel marketMaker;

  const WarrantMarketMakersTile({
    super.key,
    required this.marketMaker,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          WarrantRoute(
            underlyingName: marketMaker.key == 'GRM' ? 'EURUSD' : 'XU030',
            selectedMarketMaker: marketMaker.key,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: Grid.s,
        ),
        child: Column(
          children: [
            RectangleSymbolIcon(
              symbolName: marketMaker.key,
              symbolType: SymbolTypes.marketMaker,
              size: 72,
            ),
            const SizedBox(
              height: Grid.xxs,
            ),
            SizedBox(
              width: 72,
              child: Text(
                marketMaker.name,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: context.pAppStyle.interMediumBase.copyWith(
                  color: context.pColorScheme.textSecondary,
                  fontSize: Grid.s + (Grid.xxs / 2) + Grid.xxs,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
