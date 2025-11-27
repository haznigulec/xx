import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class JournalInstrumentList extends StatelessWidget {
  final News news;
  final MarketListModel? symbol;
  final double? maxWidth;

  const JournalInstrumentList({
    super.key,
    required this.news,
    this.symbol,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (news.symbol == null) return const SizedBox.shrink();
    List<dynamic> symbols = news.symbol!.where((element) => element != null).toSet().toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 23,
        maxWidth: maxWidth ?? MediaQuery.sizeOf(context).width * 0.45,
      ),
      child: SymbolChipsWidget(
        symbolList: List<String>.from(symbols),
      ),
    );
  }
}
