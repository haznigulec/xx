import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MarketReviewsFilterPage extends StatefulWidget {
  const MarketReviewsFilterPage({
    super.key,
  });

  @override
  State<MarketReviewsFilterPage> createState() => _MarketReviewsFilterPageState();
}

class _MarketReviewsFilterPageState extends State<MarketReviewsFilterPage> {
  late DateTime startDate;
  late DateTime endDate;
  late bool showAnalysis;
  late bool showReports;
  late bool showPodcasts;
  late bool showVideoComments;
  late ReportsBloc _bloc;
  Map<String, String> titles = {};

  @override
  void initState() {
    _bloc = getIt<ReportsBloc>();

    // List<SettingsModel> settings = _appInfoBloc.state.isLoggedIn
    //     ? _appInfoBloc.state.customerSettings.analysis
    //         .firstWhere((element) => element.key == 'reports_video_podcast')
    //         .children
    //     : _appInfoBloc.state.deviceSettings.analysis
    //         .firstWhere((element) => element.key == 'reports_video_podcast')
    //         .children;

    // for (SettingsModel element in settings) {
    //   titles[element.key] = element.key;
    // }
    ReportFilterModel reportFilter = _bloc.state.reportFilter;
    showAnalysis = reportFilter.showAnalysis;
    showReports = reportFilter.showReports;
    showPodcasts = reportFilter.showPodcasts;
    showVideoComments = reportFilter.showVideoComments;
    startDate = reportFilter.startDate ??
        DateTime.now().subtract(
          const Duration(
            days: 30,
          ),
        );
    endDate = reportFilter.endDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ReportsBloc, ReportsState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('filtrele'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.s,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  PSwitchRow(
                    text: L10n.tr(
                      titles['reports_video_podcast_analysis'] ?? '',
                    ),
                    value: showAnalysis,
                    onChanged: (value) {
                      setState(() {
                        showAnalysis = value;
                      });
                    },
                  ),
                  PSwitchRow(
                    text: L10n.tr(
                      titles['reports_video_podcast_reports'] ?? '',
                    ),
                    value: showReports,
                    onChanged: (value) {
                      setState(() {
                        showReports = value;
                      });
                    },
                  ),
                  PSwitchRow(
                    text: L10n.tr(titles['reports_video_podcast_podcasts'] ?? ''),
                    value: showPodcasts,
                    onChanged: (value) {
                      setState(() {
                        showPodcasts = value;
                      });
                    },
                  ),
                  PSwitchRow(
                    text: L10n.tr(titles['reports_video_podcasts_video_comments'] ?? ''),
                    value: showVideoComments,
                    onChanged: (value) {
                      setState(() {
                        showVideoComments = value;
                      });
                    },
                  ),
                  const PDivider(),
                  _dateRangeWidget(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: generalButtonPadding(
            context: context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PButton(
                    text: L10n.tr('uygula'),
                    // color: PPColors.orange500,
                    // onPressed: () {
                    //   Duration diff = startDate.difference(endDate);

                    //   if (diff.inDays < -180) {
                    //     return PPDialogs.basicAlertDialog(
                    //       L10n.tr('different_between_two_date_report'),
                    //       AlertIconEnum.warning,
                    //     );
                    //   } else if (endDate.isBefore(startDate)) {
                    //     return PPDialogs.basicAlertDialog(
                    //       L10n.tr('end_date_less_than_start_date'),
                    //       AlertIconEnum.warning,
                    //     );
                    //   }

                    // _bloc.add(
                    //   SetReportFilterEvent(
                    //     reportFilter: state.reportFilter.copyWith(
                    //       showAnalysis: showAnalysis,
                    //       showPodcasts: showPodcasts,
                    //       showReports: showReports,
                    //       showVideoComments: showVideoComments,
                    //       startDate: startDate,
                    //       endDate: endDate,
                    //     ),
                    //     deviceId: getIt<AppInfo>().deviceId,
                    //     customerId: _appInfoBloc.state.customerId,
                    //   ),
                    // );
                    // router.maybePop();
                    // },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dateRangeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Utils.tr('tarih_araligi'),
            'tarih_araligi',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: Grid.s),
          const Row(
            children: [
              // Expanded(
              //   child: DatePickerInput(
              //     title: Utils.tr('baslangic'),
              //     initialDate: startDate,
              //     onChanged: (selectedDate) {
              //       setState(() {
              //         startDate = selectedDate;
              //       });
              //     },
              //   ),
              // ),
              SizedBox(
                width: Grid.s,
              ),
              // Expanded(
              //   child: DatePickerInput(
              //     title: Utils.tr('bitis'),
              //     initialDate: endDate,
              //     onChanged: (selectedDate) {
              //       setState(() {
              //         endDate = selectedDate;
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
