import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_bloc.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_event.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_state.dart';
import 'package:piapiri_v2/app/economic_calender/economic_constants.dart';
import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/app/economic_calender/widgets/country_filter_widget.dart';
import 'package:piapiri_v2/app/economic_calender/widgets/date_filter_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/list/economic_calendar_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EconomicCalendarPage extends StatefulWidget {
  const EconomicCalendarPage({
    super.key,
  });

  @override
  State<EconomicCalendarPage> createState() => _EconomicCalendarPageState();
}

class _EconomicCalendarPageState extends State<EconomicCalendarPage> {
  bool isLoaded = false;
  bool isFiltered = false;
  List<dynamic> economicCalendarList = [];
  List<dynamic> filteredAcademicCalendarList = [];
  late EconomicCalenderBloc _economicCalenderBloc;
  late CalendarSortEnum _selectedSort;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _economicCalenderBloc = getIt<EconomicCalenderBloc>();
    _economicCalenderBloc.add(
      GetCalendarItemsEvent(),
    );

    getIt<Analytics>().track(
      AnalyticsEvents.ekonomikTakvimTabClick,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.journalTab.value,
        InsiderEventEnum.economicCalendarTab.value,
      ],
    );
    _selectedSort = _economicCalenderBloc.state.calendarFilter.sort;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<EconomicCalenderBloc, EconomicCalenderState>(
      bloc: _economicCalenderBloc,
      builder: (context, state) {
        if (state.calendarState == PageState.loading) {
          return const Center(
            child: PLoading(),
          );
        }

        DateTime startDate = state.startDate != null
            ? state.startDate!
            : DateTime.now().subtract(
                const Duration(days: 1),
              );
        DateTime endDate = state.endDate != null ? state.endDate! : DateTime.now();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Row(
                spacing: Grid.s,
                children: [
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('sorting'),
                    iconSource: ImagesPath.arrows_down_up,
                    foregroundColorApllyBorder: false,
                    foregroundColor: state.isChangedPriority! ? context.pColorScheme.primary : null,
                    backgroundColor: state.isChangedPriority! ? context.pColorScheme.secondary : null,
                    onPressed: () {
                      _scrollController.animateTo(
                        MediaQuery.sizeOf(context).width,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      PBottomSheet.show(
                        context,
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        title: L10n.tr(
                          'sorting',
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: EconomicConstants().economicSort.length,
                          separatorBuilder: (context, index) => const PDivider(),
                          itemBuilder: (context, index) => BottomsheetSelectTile(
                            title: L10n.tr(EconomicConstants().economicSort[index].name),
                            isSelected: EconomicConstants().economicSort[index].value == _selectedSort,
                            value: EconomicConstants().economicSort[index].value,
                            onTap: (title, value) async {
                              _economicCalenderBloc.add(
                                SetCalendarFilterEvent(
                                  calendarFilter: CalendarFilterModel(
                                    sort: _selectedSort,
                                    country: _economicCalenderBloc.state.selectedCountries ?? [],
                                  ),
                                  isChangedPriority: true,
                                ),
                              );
                              setState(
                                () {
                                  _selectedSort = value;
                                },
                              );
                              await router.maybePop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr(
                      (state.selectedCountries == null || state.selectedCountries!.isEmpty)
                          ? 'all_countries'
                          : state.selectedCountries!.length >= 2
                              ? L10n.tr('multiple_countries')
                              : state.selectedCountries![0].name,
                    ),
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: state.isChangedCountries! ? context.pColorScheme.primary : null,
                    backgroundColor: state.isChangedCountries! ? context.pColorScheme.secondary : null,
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('all_countries'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: const ECCountryFilterWidget(),
                      );
                    },
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('${DateTimeUtils.dateFormat(startDate)} - ${DateTimeUtils.dateFormat(endDate)}'),
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: state.isChangedDates! ? context.pColorScheme.primary : null,
                    backgroundColor: state.isChangedDates! ? context.pColorScheme.secondary : null,
                    onPressed: () {
                      _scrollController.animateTo(
                        MediaQuery.sizeOf(context).width / 2,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeInOut,
                      );
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('tarih_araligi'),
                        child: ECDateFilterWidget(
                          startDate: startDate,
                          endDate: endDate,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            state.filteredCalendarItems.isEmpty
                ? Expanded(
                    child: Center(
                      child: NoDataWidget(
                        message: L10n.tr(
                          'no_economic_calender_found',
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(
                                left: Grid.m,
                                right: Grid.m,
                                bottom: Grid.s + Grid.xs,
                              ),
                              child: EconomicCalendarTile(
                                item: state.filteredCalendarItems[index],
                                index: index,
                                lastIndex: state.filteredCalendarItems.length - 1,
                              ),
                            ),
                            childCount: state.filteredCalendarItems.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: Grid.m,
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
