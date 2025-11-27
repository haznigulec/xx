import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/widgets/components_tile_widget.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class BottomsheetComponentsWidget extends StatefulWidget {
  final OverallItemModel assets;
  final bool isDefaultParity;
  final double totalUsdOverall;
  final bool isVisible;

  const BottomsheetComponentsWidget({
    super.key,
    required this.assets,
    required this.isDefaultParity,
    required this.totalUsdOverall,
    required this.isVisible,
  });

  @override
  State<BottomsheetComponentsWidget> createState() => _BottomsheetComponentsWidgetState();
}

class _BottomsheetComponentsWidgetState extends State<BottomsheetComponentsWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollbarVisible = false;
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();

  void _checkIfScrollbarNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final needsScrollbar = _scrollController.position.maxScrollExtent > 0;
      if (_isScrollbarVisible != needsScrollbar && mounted) {
        setState(() {
          _isScrollbarVisible = needsScrollbar;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.assets.instrumentCategory == 'viop') {
      _subscribeSymbolsSequentially(
        widget.assets.overallSubItems.map((e) => e.symbol).toList(),
      );
    }

    _scrollController.addListener(_checkIfScrollbarNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfScrollbarNeeded());
  }

  void _subscribeSymbolsSequentially(List<String> symbols, {int index = 0}) {
    if (index >= symbols.length) return; // tüm liste bitti

    final symbol = symbols[index].split(' ')[0];

    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: symbol,
        symbolType: SymbolTypes.future,
        callback: (p0) {
          // Burada işlem başarılı olduğunda sıradaki item için devam et
          _subscribeSymbolsSequentially(
            symbols,
            index: index + 1,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfScrollbarNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thumbColor: context.pColorScheme.iconPrimary,
      thickness: 2.0,
      minThumbLength: 83,
      trackRadius: const Radius.circular(Grid.xxs),
      radius: const Radius.circular(Grid.xxs),
      padding: EdgeInsets.only(left: _isScrollbarVisible ? Grid.m - Grid.xxs : 0.0), // Scrollbar varsa sağ padding
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: widget.assets.overallSubItems.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) => ComponentsTileWidget(
          isVisible: widget.isVisible,
          scrollPadding: _isScrollbarVisible ? Grid.m - Grid.xxs : 0.0,
          instrumentCategory: widget.assets.instrumentCategory,
          overallSubItems: widget.assets.overallSubItems[index],
          isDefaultParity: widget.isDefaultParity,
          totalUsdOverall: widget.totalUsdOverall,
          totalAmount: widget.assets.totalAmount,
          index: index,
          lastIndex: widget.assets.overallSubItems.length - 1,
        ),
      ),
    );
  }
}
