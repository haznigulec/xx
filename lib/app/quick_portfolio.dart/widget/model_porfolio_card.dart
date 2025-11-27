import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_item_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/quick_portfolio_buttons_widget.dart.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

//model portfolio kart tasarımı
class ModelPortfolioCard extends StatelessWidget {
  final ModelPortfolioModel item;
  final String portfolioKey;
  const ModelPortfolioCard({
    super.key,
    required this.item,
    required this.portfolioKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return _buttonAction();
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.all(
              Grid.s + Grid.xxs,
            ),
            child: CardImage(
              imageUrl: '${getIt<AppInfo>().cdnUrl}Portfolio/${item.iconFile}',
              size: 40,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: Grid.m,
                  ),
                  child: Text(
                    item.title,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: Grid.m,
                  ),
                  child: Text(
                    item.detail,
                    maxLines: 3,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                QuickPortfolioButtonsWidget(
                  symbols: item.items,
                  portfolioKey: portfolioKey,
                  buyButtonOnPressed: () {
                    return _buttonAction();
                  },
                  listSymbolType: SymbolTypes.equity.dbKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _buttonAction() {
    router.push(
      ModelPorfolioRoute(
        portfolioKey: portfolioKey,
        title: item.title,
        description: item.detail,
      ),
    );
  }
}
