import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolChipsWidget extends StatefulWidget {
  final List<String> symbolList;
  final String? symbolListType;

  const SymbolChipsWidget({
    super.key,
    required this.symbolList,
    this.symbolListType,
  });

  @override
  State<SymbolChipsWidget> createState() => _SymbolChipsWidgetState();
}

class _SymbolChipsWidgetState extends State<SymbolChipsWidget> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  Map<String, MarketListModel?> _symbolTypesList = {};
  @override
  void initState() {
    super.initState();
    _symbolBloc.add(
      GetSpesificListSymbolTypesEvent(
        symbolList: widget.symbolList,
        symbolListType: widget.symbolListType,
        callback: (symbolTypesList) {
          if (!mounted) return;
          setState(() => _symbolTypesList = symbolTypesList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: widget.symbolList.length,
        itemBuilder: (context, index) {
          bool shimmerize = _symbolTypesList.isEmpty || _symbolTypesList[widget.symbolList[index]]?.symbolType == null;
          SymbolTypes symbolTypes = stringToSymbolType(_symbolTypesList[widget.symbolList[index]]?.symbolType ?? '');
          return Padding(
            padding: const EdgeInsets.only(
              right: Grid.xs,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: widget.symbolList[index],
              icon: Shimmerize(
                enabled: shimmerize,
                child: shimmerize
                    ? ClipOval(
                        child: Container(
                          width: 14,
                          height: 14,
                          color: context.pColorScheme.backgroundColor,
                        ),
                      )
                    : SymbolIcon(
                        symbolType: symbolTypes,
                        symbolName: [
                          SymbolTypes.future,
                          SymbolTypes.option,
                          SymbolTypes.warrant,
                          SymbolTypes.fund,
                        ].contains(symbolTypes)
                            ? _symbolTypesList[widget.symbolList[index]]?.underlying ?? ''
                            : widget.symbolList[index],
                      ),
              ),
              iconAlignment: IconAlignment.start,
              buttonType: PCustomOutlinedButtonTypes.smallSecondary,
              onPressed: () {
                if (shimmerize) return;
                Utils().routeToDetail(
                  widget.symbolList[index],
                  symbolTypes,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
