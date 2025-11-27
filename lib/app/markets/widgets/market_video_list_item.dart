import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/markets/widgets/market_youtube_player_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';

class MarketVideoListItemWidget extends StatefulWidget {
  const MarketVideoListItemWidget({
    super.key,
    required this.index,
    required this.embedCode,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.symbols,
    required this.marketType,
  });

  final int index;
  final String embedCode;
  final String title;
  final String description;
  final String dateTime;
  final List<String> symbols;
  final MarketTypeEnum marketType;

  @override
  State<MarketVideoListItemWidget> createState() => _MarketVideoListItemWidgetState();
}

class _MarketVideoListItemWidgetState extends State<MarketVideoListItemWidget> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: MarketYoutubePlayerWidget(
            embedCode: widget.embedCode,
            onLodingCompleted: () {
              setState(() => _isLoading = false);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Shimmerize(
            enabled: _isLoading,
            child: Text(
              widget.title,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
        ),
        const SizedBox(
          height: Grid.xs,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Shimmerize(
            enabled: _isLoading,
            child: Text(
              widget.description,
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ),
        ),
        if (!_isLoading && widget.dateTime.isNotEmpty) ...[
          const SizedBox(
            height: Grid.xs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              DateTimeUtils.daySortMonthAndYear(
                widget.dateTime,
              ),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ),
        ],
        if (!_isLoading && widget.symbols.isNotEmpty) ...[
          const SizedBox(
            height: Grid.xs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: SymbolChipsWidget(
              key: ValueKey('SYMBOLCHIPS_${widget.symbols.join(',')}'),
              symbolList: widget.symbols,
            ),
          ),
        ],
      ],
    );
  }
}
