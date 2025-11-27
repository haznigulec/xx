import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_state.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_field.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_tile.dart';
import 'package:piapiri_v2/common/utils/debouncer.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SearchFundPage extends StatefulWidget {
  final Function(SymbolModel) onTapSymbol;
  const SearchFundPage({
    super.key,
    required this.onTapSymbol,
  });

  @override
  State<SearchFundPage> createState() => _SearchFundPageState();
}

class _SearchFundPageState extends State<SearchFundPage> {
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  final FundBloc _fundBloc = getIt<FundBloc>();
  final TextEditingController _controller = TextEditingController();
  (String, String) _filterInstitution = ('Ünlü Portföy', 'UNP');
  final Debouncer _onSearchDebouncer = Debouncer(
    delay: const Duration(
      milliseconds: 500,
    ),
  );

  @override
  initState() {
    super.initState();
    _fundBloc.add(GetInstitutionsEvent(callback: (_) {}));
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
          hintText: L10n.tr('search_fund'),
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
        PBlocBuilder<FundBloc, FundState>(
            bloc: _fundBloc,
            builder: (context, state) {
              List<(String, String)> institutionList =
                  state.institutionList.where((element) => element.$1 != 'Tümü').toList();
              return Padding(
                padding: const EdgeInsets.only(top: Grid.s),
                child: PCustomOutlinedButtonWithIcon(
                  text: _filterInstitution.$1,
                  iconSource: ImagesPath.chevron_down,
                  foregroundColorApllyBorder: false,
                  foregroundColor: context.pColorScheme.primary,
                  backgroundColor: context.pColorScheme.secondary,
                  onPressed: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('kurucu'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: institutionList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => BottomsheetSelectTile(
                          title: institutionList[index].$1,
                          isSelected: institutionList[index].$2 == _filterInstitution.$2,
                          onTap: (title, value) async {
                            Navigator.of(context).pop();
                            (String, String)? selectedInstitution =
                                institutionList.firstWhereOrNull((e) => e.$1 == title);
                            if (selectedInstitution != null && selectedInstitution.$1 != _filterInstitution.$1) {
                              _filterInstitution = selectedInstitution;
                            }
                            _onSearch();
                            setState(() {});
                          },
                        ),
                        separatorBuilder: (context, index) => const PDivider(),
                      ),
                    );
                  },
                ),
              );
            }),
        PBlocBuilder<SymbolSearchBloc, SymbolSearchState>(
            bloc: _symbolSearchBloc,
            builder: (context, state) {
              List<SymbolModel> currentList = state.searchResults;
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
      SearchFundEvent(
        searchKey: _controller.text,
        foundercode: _filterInstitution.$2,
        callBack: (results) {},
      ),
    );
  }
}
