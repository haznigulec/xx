import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_tile.dart';
import 'package:piapiri_v2/app/alarm/widgets/no_alarms.dart';
import 'package:piapiri_v2/app/data_grid/widgets/symbol_list_column.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NewsAlarms extends StatefulWidget {
  final List<NewsAlarm> newsAlarms;

  const NewsAlarms({
    super.key,
    required this.newsAlarms,
  });

  @override
  State<NewsAlarms> createState() => _NewsAlarmsState();
}

class _NewsAlarmsState extends State<NewsAlarms> {
  final AlarmBloc _alarmBloc = getIt<AlarmBloc>();

  @override
  Widget build(BuildContext context) {
    return widget.newsAlarms.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: NoAlarms(
              message: 'no_active_news_alarm_desc',
              onPressed: () {
                if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
                  PBottomSheet.showError(
                    context,
                    content: L10n.tr('max_alarm_limit_reached'),
                  );
                  return;
                }
                router.push(
                  SymbolSearchRoute(
                    appBarTitle: L10n.tr('alarm_kur'),
                    filterList: SymbolSearchFilterEnum.values
                        .where(
                          (e) =>
                              e != SymbolSearchFilterEnum.foreign &&
                              e != SymbolSearchFilterEnum.fund &&
                              e != SymbolSearchFilterEnum.etf,
                        )
                        .toList(),
                    fromNewsAlarm: true,
                    isCheckbox: true,
                    onTapSymbol: (symbolModelList) {
                      _alarmBloc.add(
                        SetNewsAlarmEvent(
                          symbolName: symbolModelList[0].name,
                        ),
                      );
                    },
                  ),
                );
                getIt<Analytics>().track(
                  AnalyticsEvents.alarmKurClick,
                  taxonomy: [
                    InsiderEventEnum.controlPanel.value,
                    InsiderEventEnum.homePage.value,
                    InsiderEventEnum.alarmPage.value,
                  ],
                );
              },
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: Grid.xxs,
              ),
              widget.newsAlarms.isEmpty
                  ? const SizedBox()
                  : SymbolListColumn(
                      columns: [
                        '${L10n.tr('asset')} (${widget.newsAlarms.length})',
                      ],
                      columnsSpacingIsEqual: false,
                      sortEnabled: false,
                      extraPadding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      showTopDivider: true,
                      onTapSort: () {},
                    ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.newsAlarms.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (BuildContext context, int index) => const PDivider(),
                  itemBuilder: (context, index) {
                    return AlarmTile(
                      alarm: widget.newsAlarms[index],
                      horizontalPadding: Grid.m,
                    );
                  },
                ),
              ),
              generalButtonPadding(
                context: context,
                child: PButton(
                  text: L10n.tr('yeni_alarm_kur'),
                  fillParentWidth: true,
                  onPressed: () {
                    if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('max_alarm_limit_reached'),
                      );
                      return;
                    }
                    router.push(
                      SymbolSearchRoute(
                          appBarTitle: L10n.tr('yeni_alarm_kur'),
                          selectedSymbolList: widget.newsAlarms
                              .map(
                                (e) => SymbolModel(
                                  name: e.symbol,
                                  typeCode: e.symbolType,
                                ),
                              )
                              .toList(),
                          fromNewsAlarm: true,
                          filterList: SymbolSearchFilterEnum.values
                              .where(
                                (e) =>
                                    e != SymbolSearchFilterEnum.foreign &&
                                    e != SymbolSearchFilterEnum.fund &&
                                    e != SymbolSearchFilterEnum.etf,
                              )
                              .toList(),
                          isCheckbox: true,
                          onTapSymbol: (symbolModelList) {
                            _alarmBloc.add(
                              SetNewsAlarmEvent(
                                symbolName: symbolModelList[0].name,
                              ),
                            );
                          },
                          onTapDeleteSymbol: (symbolModelList) {
                            List<NewsAlarm> deleteNewAlarmList =
                                widget.newsAlarms.where((e) => e.symbol == symbolModelList[0].name).toList();

                            _alarmBloc.add(
                              RemoveAlarmEvent(
                                id: deleteNewAlarmList[0].id,
                                callback: () {
                                  _alarmBloc.add(
                                    GetAlarmsEvent(),
                                  );
                                },
                              ),
                            );
                          }),
                    );
                    getIt<Analytics>().track(
                      AnalyticsEvents.alarmKurClick,
                      taxonomy: [
                        InsiderEventEnum.controlPanel.value,
                        InsiderEventEnum.homePage.value,
                        InsiderEventEnum.alarmPage.value,
                        InsiderEventEnum.setNewAlarm.value,
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
