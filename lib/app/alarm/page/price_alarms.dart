import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/enum/price_alarm_filter.dart';
import 'package:piapiri_v2/app/alarm/widgets/alarm_tile.dart';
import 'package:piapiri_v2/app/alarm/widgets/no_alarms.dart';
import 'package:piapiri_v2/app/data_grid/widgets/symbol_list_column.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PriceAlarms extends StatefulWidget {
  final List<PriceAlarm> priceAlarms;

  const PriceAlarms({
    super.key,
    required this.priceAlarms,
  });

  @override
  State<PriceAlarms> createState() => _PriceAlarmsState();
}

class _PriceAlarmsState extends State<PriceAlarms> {
  final AlarmBloc _alarmBloc = getIt<AlarmBloc>();
  PriceAlarmFilter _selectedFilter = PriceAlarmFilter.pending;
  List<PriceAlarm> _alarms = [];
  @override
  initState() {
    _alarms.addAll(widget.priceAlarms.where((e) => e.isActive).toList());
    super.initState();
  }

  @override
  didUpdateWidget(covariant PriceAlarms oldWidget) {
    if (oldWidget.priceAlarms != widget.priceAlarms) {
      _alarms = _selectedFilter == PriceAlarmFilter.pending
          ? widget.priceAlarms.where((e) => e.isActive).toList()
          : widget.priceAlarms.where((e) => !e.isActive).toList();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.priceAlarms.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: NoAlarms(
              message: 'no_active_price_alarm_desc',
              onPressed: () => _createAlarm('alarm_kur'),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: Grid.s,
                  bottom: Grid.xs,
                  left: Grid.m,
                ),
                child: PCustomOutlinedButtonWithIcon(
                  text: L10n.tr(_selectedFilter.name),
                  iconSource: ImagesPath.chevron_down,
                  onPressed: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('alarm_price'),
                      child: Column(
                        children: PriceAlarmFilter.values.map((filter) {
                          return FilterCategoryButton(
                            title: L10n.tr(
                              filter.name,
                            ),
                            isSelected: _selectedFilter == filter,
                            hasDivider: filter != PriceAlarmFilter.values.last,
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _alarms = filter == PriceAlarmFilter.pending
                                    ? widget.priceAlarms.where((e) => e.isActive).toList()
                                    : widget.priceAlarms.where((e) => !e.isActive).toList();
                                setState(() {});
                                router.maybePop();
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              widget.priceAlarms.isEmpty
                  ? const SizedBox()
                  : SymbolListColumn(
                      columns: [
                        '${L10n.tr('asset')} (${_selectedFilter == PriceAlarmFilter.pending ? widget.priceAlarms.where((e) => e.isActive).toList().length : widget.priceAlarms.where((e) => !e.isActive).toList().length})',
                        L10n.tr('current_price'),
                        L10n.tr('alarm_price'),
                      ],
                      columnsSpacingIsEqual: true,
                      sortEnabled: false,
                      extraPadding: const EdgeInsets.symmetric(horizontal: Grid.m),
                      showTopDivider: true,
                      onTapSort: () {},
                    ),
              Expanded(
                child: _alarms.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: NoAlarms(
                          message: 'no_active_price_alarm_desc',
                          onPressed: () => _createAlarm('alarm_kur'),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _alarms.length,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) => const PDivider(),
                        itemBuilder: (context, index) {
                          return AlarmTile(
                            alarm: _alarms[index],
                            isPriceAlarm: true,
                            horizontalPadding: Grid.m,
                          );
                        },
                      ),
              ),
              _selectedFilter == PriceAlarmFilter.pending && !widget.priceAlarms.any((e) => e.isActive) ||
                      _selectedFilter == PriceAlarmFilter.completed && widget.priceAlarms.any((e) => e.isActive)
                  ? const SizedBox.shrink()
                  : generalButtonPadding(
                      context: context,
                      child: PButton(
                        text: L10n.tr('yeni_alarm_kur'),
                        fillParentWidth: true,
                        onPressed: () => _createAlarm('yeni_alarm_kur'),
                      ),
                    ),
            ],
          );
  }

  _createAlarm(String appBarTitle) {
    if (_alarmBloc.state.priceAlarms.length + _alarmBloc.state.newsAlarms.length >= 90) {
      PBottomSheet.showError(
        context,
        content: L10n.tr('max_alarm_limit_reached'),
      );
      return;
    }
    router.push(
      SymbolSearchRoute(
        appBarTitle: L10n.tr(appBarTitle),
        filterList: SymbolSearchFilterEnum.values
            .where(
              (e) =>
                  e != SymbolSearchFilterEnum.foreign &&
                  e != SymbolSearchFilterEnum.fund &&
                  e != SymbolSearchFilterEnum.etf,
            )
            .toList(),
        onTapSymbol: (symbolModelList) {
          router.push(
            CreatePriceNewsAlarmRoute(
              symbol: symbolModelList[0],
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
        InsiderEventEnum.priceAlarm.value,
      ],
    );
  }
}
