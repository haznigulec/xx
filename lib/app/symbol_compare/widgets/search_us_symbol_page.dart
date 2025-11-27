import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_field.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_tile.dart';
import 'package:piapiri_v2/common/utils/debouncer.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SearchCompareSymbolPage extends StatefulWidget {
  final List<String> filterDbKeys;
  final Function(SymbolModel) onTapSymbol;
  final String? hintText;
  const SearchCompareSymbolPage({
    super.key,
    required this.filterDbKeys,
    required this.onTapSymbol,
    this.hintText
  });

  @override
  State<SearchCompareSymbolPage> createState() => _SearchCompareSymbolPageState();
}

class _SearchCompareSymbolPageState extends State<SearchCompareSymbolPage> {
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  final TextEditingController _controller = TextEditingController();
  final Debouncer _onSearchDebouncer = Debouncer(
    delay: const Duration(
      milliseconds: 500,
    ),
  );

  @override
  initState() {
    super.initState();
    _onSearch();
  }

  @override
  dispose() {
    _onSearchDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SymbolSearchField(
          controller: _controller,
          hintText: widget.hintText,
          onTapSuffix: () {
            _controller.clear();
            _onSearch();
            setState(() {});
          },
          onChanged: (value) {
            _onSearchDebouncer.debounce(() async {
              _onSearch();
            });
            setState(() {});
          },
        ),
        PBlocBuilder<SymbolSearchBloc, SymbolSearchState>(
            bloc: _symbolSearchBloc,
            builder: (context, state) {
              List<SymbolModel> currentList = _controller.text.isEmpty ? [] : state.searchResults;
              return SizedBox(
                height: 500,
                child: currentList.isEmpty
                    ? Center(
                        child: NoDataWidget(
                          message: L10n.tr('no_data'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, index) {
                          return SymbolSearchTile(
                            key: ValueKey(currentList[index].name),
                            symbol: currentList[index],
                            isSelected: false,
                            isCheckbox: false,
                            onTapSymbol: (symbol) {
                              Navigator.of(context).pop();
                              widget.onTapSymbol(symbol);
                            },
                          );
                        },
                      ),
              );
            })
      ],
    );
  }

  _onSearch() {
    _symbolSearchBloc.add(
      SearchSymbolEvent(
        symbolName: _controller.text.toUpperCase(),
        exchangeCode: '0',
        underlying: null,
        maturity: null,
        transactionType: TransactionTypeEnum.all,
        filterDbKeys: widget.filterDbKeys,
        callback: (result) {},
      ),
    );
  }
}
