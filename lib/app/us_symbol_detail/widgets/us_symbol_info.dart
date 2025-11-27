import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/price_info_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/us_symbol_about.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsSymbolInfo extends StatefulWidget {
  final UsSymbolSnapshot symbol;
  final TickerOverview tickerOverview;

  const UsSymbolInfo({
    super.key,
    required this.symbol,
    required this.tickerOverview,
  });

  @override
  State<UsSymbolInfo> createState() => _UsSymbolInfoState();
}

class _UsSymbolInfoState extends State<UsSymbolInfo> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SymbolIcon(
                symbolName: widget.symbol.ticker,
                symbolType: SymbolTypes.foreign,
                size: 30,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15,
                      child: Text(
                        widget.symbol.ticker,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.tickerOverview.name?.toUpperCase() ?? '',
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('hakkinda'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: UsSymbolAbout(
                      tickerOverview: widget.tickerOverview,
                    ),
                  );
                },
                child: SvgPicture.asset(
                  ImagesPath.info,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s + Grid.xxs),
          PriceInfoWidget(
            symbolName: widget.symbol.ticker,
          ),
        ],
      ),
    );
  }
}
