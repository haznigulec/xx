import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_filter_panel.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/category_filter_widget.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/date_range_filter_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/dynamic_indexed_stack.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketReviewFilterWidget extends StatefulWidget {
  final String mainGroup;
  const MarketReviewFilterWidget({
    super.key,
    required this.mainGroup,
  });

  @override
  State<MarketReviewFilterWidget> createState() => _MarketReviewFilterWidgetState();
}

class _MarketReviewFilterWidgetState extends State<MarketReviewFilterWidget> {
  final List<RadioModel> _sourcesList = [];
  int _selectedSourceIndex = 0;
  late ReportsBloc _reportsBloc;
  late bool _showAnalysis;
  late bool _showReports;
  late bool _showPodcasts;
  late bool _showVideoComments;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    _reportsBloc = getIt<ReportsBloc>();

    _showAnalysis = _reportsBloc.state.reportFilter.showAnalysis;
    _showReports = _reportsBloc.state.reportFilter.showReports;
    _showPodcasts = _reportsBloc.state.reportFilter.showPodcasts;
    _showVideoComments = _reportsBloc.state.reportFilter.showVideoComments;
    _startDate = _reportsBloc.state.reportFilter.startDate ??
        DateTime.now().subtract(
          const Duration(
            days: 30,
          ),
        );
    _endDate = _reportsBloc.state.reportFilter.endDate ?? DateTime.now();

    _sourcesList.add(
      RadioModel(
        true,
        L10n.tr('categories'),
      ),
    );

    _sourcesList.add(
      RadioModel(
        false,
        L10n.tr('tarih_araligi'),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Grid.m,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _sourcesWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Grid.s + Grid.xs,
                  ),
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: context.pColorScheme.line,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Grid.s + Grid.xs,
                        left: Grid.s + Grid.xs,
                      ),
                      child: DynamicIndexedStack(
                        index: _selectedSourceIndex,
                        children: [
                          CategoryFilterWidget(
                            showAnalysis: _showAnalysis,
                            showReports: _showReports,
                            showPodcasts: _showPodcasts,
                            showVideoComments: _showVideoComments,
                            onChangedAnalysis: (checked) => setState(() => _showAnalysis = checked),
                            onChangedReports: (checked) => setState(() => _showReports = checked),
                            onChangedPodcasts: (checked) => setState(() => _showPodcasts = checked),
                            onChangedVideoComments: (checked) => setState(() => _showVideoComments = checked),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: Grid.s,
                            ),
                            child: DateRangeFilterWidget(
                              startDate: _startDate,
                              endDate: _endDate,
                              onChangedStartDate: (date) => setState(() => _startDate = date),
                              onChangedEndDate: (date) => setState(() => _endDate = date),
                              hasDivider: false,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              Duration diff = _startDate.difference(_endDate);

              if (diff.inDays < -180) {
                PBottomSheet.showError(
                  context,
                  content: L10n.tr('different_between_two_date_report'),
                );
                return;
              } else if (_endDate.isBefore(_startDate)) {
                PBottomSheet.showError(
                  context,
                  content: L10n.tr('end_date_less_than_start_date'),
                );
                return;
              }

              _reportsBloc.add(
                SetReportFilterEvent(
                  deviceId: getIt<AppInfo>().deviceId,
                  customerId: UserModel.instance.customerId,
                  mainGroup: widget.mainGroup,
                  reportFilter: _reportsBloc.state.reportFilter.copyWith(
                    showAnalysis: _showAnalysis,
                    showPodcasts: _showPodcasts,
                    showReports: _showReports,
                    showVideoComments: _showVideoComments,
                    startDate: _startDate,
                    endDate: _endDate,
                  ),
                ),
              );

              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _sourcesWidget() {
    List<Widget> sourcesListWidget = [
      const SizedBox(
        height: Grid.s,
      )
    ];

    for (var i = 0; i < _sourcesList.length; i++) {
      sourcesListWidget.add(
        InkWell(
          onTap: () {
            setState(() {
              if (_selectedSourceIndex == i) {
                _sourcesList[i].isSelected = true;
              } else {
                _sourcesList[i].isSelected = false;
              }
              _selectedSourceIndex = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.s + Grid.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    border: Border.all(
                      width: 3.0,
                      color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.xs + Grid.xxs,
                    ),
                    child: Text(
                      _sourcesList[i].text,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m,
                        color:
                            _selectedSourceIndex == i ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.s + Grid.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sourcesListWidget,
      ),
    );
  }
}
