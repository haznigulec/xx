import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/review/model/review_filter_model.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/search_icon.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ReviewsFilterPage extends StatefulWidget {
  final Function(ReviewFilterModel) onSetFilter;
  final ReviewFilterModel reviewFilter;

  const ReviewsFilterPage({
    super.key,
    required this.onSetFilter,
    required this.reviewFilter,
  });

  @override
  State<ReviewsFilterPage> createState() => _ReviewsFilterPageState();
}

class _ReviewsFilterPageState extends State<ReviewsFilterPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _symbolName = '';
  List<String> _selectedSources = [];
  String _text = '';
  List<String> _selectedSymbols = [];

  @override
  void initState() {
    _selectedSources = widget.reviewFilter.newsSources;
    _startDate = widget.reviewFilter.startDate ??
        DateTime.now().subtract(
          const Duration(
            days: 1,
          ),
        );
    _endDate = widget.reviewFilter.endDate ?? DateTime.now();
    _symbolName = widget.reviewFilter.symbolName ?? '';
    if (_symbolName.isNotEmpty) {
      _selectedSymbols = _symbolName.split(',');
      _text = _symbolName;
    } else {
      _text = 'symbol_search_hint';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('filtrele'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const PDivider(),
            _dateRangeWidget(),
            const PDivider(),
            Padding(
              padding: const EdgeInsets.all(
                Grid.s,
              ),
              child: searchBox(
                selectedSymbol: (selectedSymbolName) {
                  setState(() {
                    _symbolName = selectedSymbolName.toString();
                  });
                },
                symbolName: _symbolName,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: generalButtonPadding(
        context: context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PButton(
                text: L10n.tr('temizle'),
                variant: PButtonVariant.error,
                onPressed: () {
                  setState(() {
                    _startDate = DateTime.now().subtract(
                      const Duration(
                        days: 1,
                      ),
                    );
                    _endDate = DateTime.now();
                    _symbolName = '';
                    _selectedSources = [];
                    _text = 'symbol_search_hint';
                  });
                  widget.onSetFilter(
                    const ReviewFilterModel(),
                  );
                },
              ),
            ),
            const SizedBox(width: Grid.s),
            Expanded(
              child: PButton(
                text: L10n.tr('uygula'),
                variant: PButtonVariant.success,
                onPressed: () {
                  widget.onSetFilter(
                    ReviewFilterModel(
                      newsSources: _selectedSources,
                      startDate: _startDate,
                      endDate: _endDate,
                      symbolName: _selectedSymbols.join(','),
                    ),
                  );
                  //router.maybePop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBox({
    required Function(List<String>) selectedSymbol,
    String? symbolName,
  }) {
    return GestureDetector(
      onTap: () {
        // router.push(
        //   SymbolSearchSelectRoute(
        //     onTapOk: (symbols) {
        //       setState(() {
        //         _selectedSymbols = List.from(symbols);
        //         symbolName = _selectedSymbols.join(',');
        //         text = symbolName;
        //       });
        //     },
        //     isFilter: true,
        //     selectedSymbols: _selectedSymbols,
        //     shouldShowSum: true,
        //   ),
        // );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        color: context.pColorScheme.transparent,
        padding: const EdgeInsets.only(
          left: Grid.s,
        ),
        child: Row(
          children: [
            const SearchIcon(),
            const SizedBox(
              width: Grid.xs,
            ),
            Expanded(
              child: Text(
                _text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
            ),
            _selectedSymbols.isNotEmpty ? _deleteIconWidget() : const SizedBox.shrink(),
            const SizedBox(
              width: Grid.s,
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteIconWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _text = 'symbol_search_hint';
          _selectedSymbols = [];
        });
      },
      child: Icon(
        Icons.close,
        color: Theme.of(context).focusColor,
        size: 16,
      ),
    );
  }

  Widget _dateRangeWidget() {
    return const SizedBox();
    // return Padding(
    //   padding: const EdgeInsets.symmetric(
    //     vertical: 25,
    //     horizontal: Grid.s,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         L10n.tr('tarih_araligi'),
    //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
    //               fontSize: 18,
    //             ),
    //       ),
    //       const SizedBox(height: Grid.s),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: DatePickerInput(
    //               title: L10n.tr('baslangic'),
    //               initialDate: startDate,
    //               onChanged: (selectedDate) {
    //                 setState(() {
    //                   startDate = selectedDate;
    //                 });
    //               },
    //             ),
    //           ),
    //           const SizedBox(
    //             width: Grid.s,
    //           ),
    //           Expanded(
    //             child: DatePickerInput(
    //               title: L10n.tr('bitis'),
    //               initialDate: endDate,
    //               onChanged: (selectedDate) {
    //                 setState(() {
    //                   endDate = selectedDate;
    //                 });
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
