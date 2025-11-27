import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_founder_list_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class FundFoundersDetailPage extends StatefulWidget {
  final GetFinancialFounderListModel institution;

  const FundFoundersDetailPage({
    super.key,
    required this.institution,
  });

  @override
  State<FundFoundersDetailPage> createState() => _FundFoundersDetailPageState();
}

class _FundFoundersDetailPageState extends State<FundFoundersDetailPage> {
  late FundBloc _fundBloc;
  final ScrollController _scrollController = ScrollController();
  bool _isAscendingText = false;
  bool _isAscendingNumbers = false;
  List<FundModel> _fundList = [];
  bool _isLoadingMore = false;

  final List _profitFilter = [
    L10n.tr('performance'),
    L10n.tr('fundPortfolioSize'),
    L10n.tr('numberOfPeople'),
    L10n.tr('risk_level'),
  ];
  final List _periodList = [
    L10n.tr('1D'),
    L10n.tr('1W'),
    L10n.tr('1M'),
    L10n.tr('3M'),
    L10n.tr('6M'),
    L10n.tr('1Y'),
    L10n.tr('3Y'),
    L10n.tr('5Y')
  ];
  String _trailingText = '${L10n.tr('1M')} ${L10n.tr('profit')}';
  String _filterCategory = L10n.tr('performance');
  String _filterPeriod = L10n.tr('1M');

  final int _startIndex = 0;
  int _count = 50;

  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _fetchFunds();

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchFunds() {
    _fundBloc.add(
      GetFilterAndSortEvent(
        widget.institution.code,
        _startIndex,
        _count,
        () {
          setState(() {
            _fundList = _sortFundListNumber(
              _fundBloc.state.filterSortList ?? [],
              _isAscendingNumbers,
            );
            _isLoadingMore = false;
          });
        },
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        (widget.institution.totalFunds ?? 0) > _count &&
        !_isLoadingMore) {
      setState(() {
        _count += 50;
        _isLoadingMore = true;
      });
      _fetchFunds();
    }
  }

  void _openSorting() {
    PBottomSheet.show(
      context,
      title: L10n.tr('sorting'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListView.separated(
        itemCount: _profitFilter.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return BottomsheetSelectTile(
            title: _profitFilter[index],
            isSelected: _profitFilter[index] == _filterCategory,
            onTap: (title, value) async {
              await router.maybePop();
              setState(
                () {
                  _filterCategory = title;
                  if (_filterCategory == L10n.tr('performance')) {
                    _trailingText = '$_filterPeriod ${L10n.tr('profit')}';
                  }
                },
              );
              processCategory(_filterCategory);
            },
          );
        },
        separatorBuilder: (context, index) => const PDivider(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.institution.name ?? '',
      ),
      body: SafeArea(
        child: PBlocBuilder<FundBloc, FundState>(
          bloc: getIt<FundBloc>(),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Grid.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _founderDetailInfo(context,
                      leadingText: L10n.tr('totalFunds'),
                      trailingText: '${widget.institution.totalFunds} ${L10n.tr('adet')}'),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  _founderDetailInfo(context,
                      leadingText: L10n.tr('totalPortfolioSize'),
                      trailingText:
                          '₺${MoneyUtils().compactMoney(widget.institution.totalPortfolioSize!.toDouble())}'.trim()),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  _founderDetailInfo(context,
                      leadingText: L10n.tr('totalPeopleInFunds'),
                      trailingText: '${(widget.institution.totalPeopleInFunds)!.toInt()} ${L10n.tr('people')}'),
                  const SizedBox(
                    height: Grid.l,
                  ),
                  SizedBox(
                    height: Grid.l,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: Grid.s,
                      children: [
                        PCustomOutlinedButtonWithIcon(
                          text: ' ${L10n.tr('sorting')} : $_filterCategory',
                          iconSource: ImagesPath.chevron_down,
                          iconAlignment: IconAlignment.end,
                          foregroundColorApllyBorder: false,
                          foregroundColor: context.pColorScheme.primary,
                          backgroundColor: context.pColorScheme.secondary,
                          onPressed: () => _openSorting(),
                        ),
                        if (_filterCategory == L10n.tr('performance')) ...[
                          PCustomOutlinedButtonWithIcon(
                            text: _filterPeriod,
                            iconSource: ImagesPath.chevron_down,
                            foregroundColorApllyBorder: false,
                            foregroundColor: context.pColorScheme.primary,
                            backgroundColor: context.pColorScheme.secondary,
                            iconAlignment: IconAlignment.end,
                            onPressed: () {
                              processCategory(_filterCategory);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Grid.s + Grid.xs,
                  ),
                  TableTitleWidget(
                    primaryColumnTitle: L10n.tr('fund'),
                    tertiaryColumnTitle: _trailingText,
                    hasSorting: true,
                    hasTertiarySorting: true,
                    onTap: () {
                      setState(() {
                        _isAscendingText = !_isAscendingText;
                        _fundList = _sortFundListText(
                          _fundBloc.state.filterSortList ?? [],
                          _isAscendingText,
                        );
                      });
                    },
                    onTertiaryTextTap: () => _openSorting(),
                    onTertiaryIconTap: () {
                      setState(() {
                        _isAscendingNumbers = !_isAscendingNumbers;
                        _fundList = _sortFundListNumber(
                          _fundBloc.state.filterSortList ?? [],
                          _isAscendingNumbers,
                        );
                      });
                    },
                  ),
                  _fundList.isEmpty && state.type == PageState.loading
                      ? const Expanded(
                          child: Center(
                            child: PLoading(),
                          ),
                        )
                      : FundFounderListWidget(
                          controller: _scrollController,
                          fundProfitsList: _fundList,
                          filterCategory: _filterCategory,
                          filterPeriod: _filterPeriod,
                        ),
                  if (_fundBloc.state.type == PageState.loading && _fundList.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(Grid.m),
                      child: Center(
                        child: PLoading(),
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void processCategory(String category) {
    if (category == L10n.tr('performance')) {
      setState(() {
        _isAscendingNumbers = false;
        _fundList = _sortFundListNumber(
          _fundBloc.state.filterSortList ?? [],
          _isAscendingNumbers,
        );
      });
      PBottomSheet.show(
        enableDrag: false,
        context,
        title: L10n.tr('maturity'),
        titlePadding: const EdgeInsets.only(
          top: Grid.m,
        ),
        child: ListView.separated(
          itemCount: _periodList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => BottomsheetSelectTile(
            title: _periodList[index],
            isSelected: _periodList[index] == _filterPeriod,
            onTap: (title, value) async {
              setState(
                () {
                  _filterPeriod = title;
                  _trailingText = '$_filterPeriod ${L10n.tr('profit')}';
                  _isAscendingNumbers = false;
                  setState(() {
                    _fundList = _sortFundListNumber(
                      _fundBloc.state.filterSortList ?? [],
                      _isAscendingNumbers,
                    );
                  });
                },
              );
              await router.maybePop();
            },
          ),
          separatorBuilder: (context, index) => const PDivider(),
        ),
      );
    } else if (category == L10n.tr('fundPortfolioSize')) {
      setState(
        () {
          _trailingText = L10n.tr('fundPortfolioSize');
          _isAscendingNumbers = false;
          _fundList = _sortFundListNumber(
            _fundBloc.state.filterSortList ?? [],
            _isAscendingNumbers,
          );
        },
      );
    } else if (category == L10n.tr('numberOfPeople')) {
      setState(
        () {
          _trailingText = L10n.tr('numberOfPeople');
          _isAscendingNumbers = false;
          _fundList = _sortFundListNumber(
            _fundBloc.state.filterSortList ?? [],
            _isAscendingNumbers,
          );
        },
      );
    } else if (category == L10n.tr('risk_level')) {
      setState(
        () {
          _trailingText = L10n.tr('risk_level');
          _isAscendingNumbers = true;
          _fundList = _sortFundListNumber(
            _fundBloc.state.filterSortList ?? [],
            _isAscendingNumbers,
          );
        },
      );
    }
  }

  List<FundModel> _sortbyPerformance(List<FundModel> fundList, bool isAscending) {
    if (_filterPeriod == _periodList[0]) {
      fundList.sort(
        (a, b) => isAscending
            ? (a.performance1D ?? 0).compareTo(b.performance1D ?? 0)
            : (b.performance1D ?? 0).compareTo(a.performance1D ?? 0),
      );
    } else if (_filterPeriod == _periodList[1]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance1W).compareTo(b.performance1W) : (b.performance1W).compareTo(a.performance1W),
      );
    } else if (_filterPeriod == _periodList[2]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance1M).compareTo(b.performance1M) : (b.performance1M).compareTo(a.performance1M),
      );
    } else if (_filterPeriod == _periodList[3]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance3M).compareTo(b.performance3M) : (b.performance3M).compareTo(a.performance3M),
      );
    } else if (_filterPeriod == _periodList[4]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance6M).compareTo(b.performance6M) : (b.performance6M).compareTo(a.performance6M),
      );
    } else if (_filterPeriod == _periodList[5]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance1Y).compareTo(b.performance1Y) : (b.performance1Y).compareTo(a.performance1Y),
      );
    } else if (_filterPeriod == _periodList[6]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance3Y).compareTo(b.performance3Y) : (b.performance3Y).compareTo(a.performance3Y),
      );
    } else if (_filterPeriod == _periodList[7]) {
      fundList.sort(
        (a, b) =>
            isAscending ? (a.performance5Y).compareTo(b.performance5Y) : (b.performance5Y).compareTo(a.performance5Y),
      );
    }
    return fundList;
  }

  List<FundModel> _sortFundListNumber(List<FundModel> fundList, bool isAscending) {
    if (_trailingText == '$_filterPeriod ${L10n.tr('profit')}') {
      fundList = _sortbyPerformance(fundList, isAscending);
    } else if (_trailingText == L10n.tr('fundPortfolioSize')) {
      fundList.sort(
        (a, b) => isAscending ? a.portfolioSize.compareTo(b.portfolioSize) : b.portfolioSize.compareTo(a.portfolioSize),
      );
    } else if (_trailingText == L10n.tr('numberOfPeople')) {
      fundList.sort(
        (a, b) =>
            isAscending ? a.numberOfPeople.compareTo(b.numberOfPeople) : b.numberOfPeople.compareTo(a.numberOfPeople),
      );
    } else if (_trailingText == L10n.tr('risk_level')) {
      fundList.sort(
        (a, b) => isAscending
            ? (a.riskLevel ?? 0).compareTo(b.riskLevel ?? 0)
            : (b.riskLevel ?? 0).compareTo(a.riskLevel ?? 0),
      );
    }

    return fundList;
  }

  List<FundModel> _sortFundListText(List<FundModel> fundList, bool isAscending) {
    return fundList..sort((a, b) => isAscending ? a.code.compareTo(b.code) : b.code.compareTo(a.code));
  }
}

Widget _founderDetailInfo(BuildContext context, {required String leadingText, required String trailingText}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          leadingText,
          style: context.pAppStyle.labelReg14textSecondary,
          textAlign: TextAlign.start,
        ),
      ),
      Text(
        trailingText,
        style: context.pAppStyle.labelMed14textPrimary,
        textAlign: TextAlign.end,
      ),
    ],
  );
}
