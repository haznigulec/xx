import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/widgets/add_chain_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class ChainCard extends StatelessWidget {
  final ChainOrderModel chainOrder;
  final int index;
  final double transactionLimit;
  final String accountId;
  const ChainCard({
    super.key,
    required this.chainOrder,
    required this.index,
    required this.transactionLimit,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    bool isBuy = chainOrder.orderAction == OrderActionTypeEnum.buy;

    return InkWell(
      onTap: () async {
        await PBottomSheet.show(
          context,
          titleWidget: _titleWidget(
            context,
            isBuy,
          ),
          child: AddChainWidget(
            index: index,
            forDeleteUpdate: true,
            symbol: chainOrder.marketListModel.symbolCode,
            chainOrder: chainOrder,
            transactionLimit: transactionLimit,
            accountId: accountId,
            type: stringToSymbolType(chainOrder.marketListModel.type),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: Grid.xs,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await PBottomSheet.show(
                    context,
                    titleWidget: _titleWidget(
                      context,
                      isBuy,
                    ),
                    child: AddChainWidget(
                      index: index,
                      // symbol: chainOrder.marketListModel.symbolCode, // mevcut sembolün default olarak gelmesi içindi, şimdilik yorum satırına alındı değişiklik olursa tekrar açılabilir.
                      chainOrder: chainOrder,
                      transactionLimit: transactionLimit,
                      accountId: accountId,
                      type: stringToSymbolType(chainOrder.marketListModel.type),
                    ),
                  );
                },
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
              const SizedBox(
                width: Grid.xs,
              ),
              Text.rich(
                TextSpan(
                  text: '${chainOrder.marketListModel.symbolCode}  ',
                  style: context.pAppStyle.labelReg14textPrimary,
                  children: [
                    TextSpan(
                      text: isBuy ? L10n.tr('al') : L10n.tr('sat'),
                      style: context.pAppStyle.labelMed14textPrimary.copyWith(
                        color: isBuy ? context.pColorScheme.success : context.pColorScheme.critical,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: Grid.l - Grid.xs,
            children: [
              Text(
                '${chainOrder.units} ${L10n.tr('adet')}',
                style: context.pAppStyle.labelMed14textSecondary,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 105,
                  minWidth: 105,
                ),
                child: SizedBox(
                  width: 105,
                  child: Text(
                    '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(chainOrder.price)}',
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _titleWidget(
    BuildContext context,
    bool isBuy,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.l,
      ),
      child: StyledText(
        text: L10n.tr(
          'add_chain_in_buy_sell_page',
          namedArgs: {
            'symbol': '<bold>${chainOrder.marketListModel.symbolCode}</bold>',
            'side': isBuy
                ? '<green>${L10n.tr('alis').toUpperCase()}</green>'
                : '<red>${L10n.tr('satis').toUpperCase()}</red>',
            'unit': '${chainOrder.units}',
            'amount': MoneyUtils().readableMoney(chainOrder.price),
          },
        ),
        textAlign: TextAlign.center,
        style: context.pAppStyle.labelReg14textPrimary,
        tags: {
          'bold': StyledTextTag(
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          'green': StyledTextTag(
              style: context.pAppStyle.labelReg14textPrimary.copyWith(
            color: context.pColorScheme.success,
          )),
          'red': StyledTextTag(
              style: context.pAppStyle.labelReg14textPrimary.copyWith(
            color: context.pColorScheme.critical,
          )),
        },
      ),
    );
  }
}
