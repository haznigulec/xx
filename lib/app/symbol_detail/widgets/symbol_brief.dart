import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/crypto_brief.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/equity_brief.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/parity_brief.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/viop_brief.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/warrant_brief.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolBrief extends StatelessWidget {
  final MarketListModel symbol;
  final MarketListModel? underlyingSymbol;
  final SymbolTypes type;
  const SymbolBrief({
    super.key,
    required this.symbol,
    this.underlyingSymbol,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr('piyasa_ozeti'),
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        if (symbol.updateDate.isNotEmpty &&
            (type == SymbolTypes.equity || type == SymbolTypes.warrant || type == SymbolTypes.future)) ...[
          SizedBox(
            height: 54,
            child: Row(
              children: [
                Expanded(
                  child: SymbolBriefInfo(
                    label: L10n.tr('update_date'),
                    value: symbol.updateDate,
                  ),
                ),
                Expanded(
                  child: SymbolBriefInfo(
                    label: L10n.tr('avarage_price'),
                    value: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(symbol.priceMean)}',
                  ),
                ),
              ],
            ),
          ),
        ],
        _getBrief(),
        const SizedBox(
          height: Grid.l,
        ),
      ],
    );
  }

  Widget _getBrief() {
    if (type == SymbolTypes.future || type == SymbolTypes.option) {
      return ViopBrief(
        symbol: symbol,
        type: type,
      );
    } else if (type == SymbolTypes.warrant || type == SymbolTypes.certificate) {
      return WarrantBrief(
        symbol: symbol,
        type: type,
      );
    } else if (type == SymbolTypes.parity) {
      return ParityBrief(
        symbol: symbol,
      );
    } else if (type == SymbolTypes.crypto) {
      return CryptoBrief(
        symbol: symbol,
      );
    } else if (type == SymbolTypes.commodity) {
      return ParityBrief(
        symbol: symbol,
      );
    } else {
      return EquityBrief(
        symbol: symbol,
        type: type,
      );
    }
  }
}
