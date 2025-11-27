import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolIconKeepAliveWidget extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolTypes;
  const SymbolIconKeepAliveWidget({
    super.key,
    required this.symbolName,
    required this.symbolTypes,
  });

  @override
  State<SymbolIconKeepAliveWidget> createState() => _SymbolIconKeepAliveWidgetState();
}

class _SymbolIconKeepAliveWidgetState extends State<SymbolIconKeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // sayfa bellekte tutulur

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SymbolIcon(
      symbolName: widget.symbolName,
      symbolType: widget.symbolTypes,
      size: 28,
    );
  }
}
