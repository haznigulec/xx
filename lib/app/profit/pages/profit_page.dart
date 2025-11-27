import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_state.dart';
import 'package:piapiri_v2/app/profit/widgets/completed_profit_loss_list.dart';
import 'package:piapiri_v2/app/profit/widgets/potential_profit_loss_list.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';
import 'package:piapiri_v2/app/profit/widgets/target_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_filter_multi_selection.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ProfitPage extends StatefulWidget {
  const ProfitPage({super.key});

  @override
  State<ProfitPage> createState() => _ProfitPageState();
}

class _ProfitPageState extends State<ProfitPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late ProfitBloc _profitBloc;
  DateFilterMultiEnum _selectedDate = DateFilterMultiEnum.sumaryToday;

  @override
  void initState() {
    super.initState();
    _profitBloc = getIt<ProfitBloc>();

    _startDate = _profitBloc.state.profitStartDate ??
        DateTime.now().subtract(
          const Duration(days: 1),
        );

    _endDate = _profitBloc.state.profitEndDate ?? DateTime.now();

    _profitBloc.add(
      GetProfitEvent(
        profitStartDate: _startDate,
        profitEndDate: _endDate,
      ),
    );

    _profitBloc.add(
      GetCustomerTargetEvent(),
    );

    _profitBloc.add(
      GetOverallSummaryEvent(
        accountId: '',
        allAccounts: true,
        includeCashFlow: true,
        includeCreditDetail: true,
        calculateTradeLimit: true,
        isConsolidated: true,
        getInstant: true,
      ),
    );

    getIt<Analytics>().track(
      AnalyticsEvents.getiriTabClick,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.portfolioPage.value,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('profit_tracking'),
      ),
      body: PBlocBuilder<ProfitBloc, ProfitState>(
        bloc: _profitBloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(
              left: Grid.m,
              right: Grid.m,
              top: Grid.l - Grid.xs,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.tr('domestic_profit_loss'),
                    style: context.pAppStyle.labelMed18primary,
                  ),
                  const SizedBox(
                    height: Grid.l - Grid.xs,
                  ),
                  DateFilterMultiSelection(
                    selectedDate: _selectedDate,
                    onChangedStartEndDate: (startDate, endDate) {
                      setState(() {
                        _startDate = startDate;
                        _endDate = endDate;

                        if (_startDate.isAfter(_endDate)) {
                          _endDate = _startDate.add(const Duration(days: 1));
                        }
                        if (endDate.isBefore(startDate)) {
                          startDate = endDate.subtract(const Duration(days: 1));
                        }

                        _profitBloc.add(
                          GetProfitEvent(
                            profitStartDate: _startDate,
                            profitEndDate: _endDate,
                          ),
                        );
                      });
                    },
                    onSelectedDateFilter: (selectedDateFilter) {
                      setState(() {
                        _selectedDate = selectedDateFilter;
                      });
                    },
                  ),
                  const SizedBox(
                    height: Grid.s + Grid.xs,
                  ),
                  const PDivider(),
                  Shimmerize(
                    enabled: state.isLoading || state.potentialProfitLossModel == null || state.taxDetailModel == null,
                    child: ProfitLossRow(
                      title: L10n.tr('completed_profit_loss'),
                      value: state.taxDetailModel?.totalPrice ?? 0.0,
                      hasIcon: state.taxDetailModel?.totalPrice != 0,
                      onTap: () {
                        if (state.taxDetailModel?.totalPrice == 0) {
                          return;
                        }
                        if (state.taxDetailModel!.taxDetails == null) {
                          return;
                        }

                        double value = state.taxDetailModel!.totalPrice ?? 0.0;

                        PBottomSheet.show(
                          context,
                          titlePadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          titleWidgetPadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          titleWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: Grid.xs,
                            children: [
                              Text(
                                '${L10n.tr('completed_profit_loss')}:',
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              Text(
                                '${value == 0 ? '' : value > 0 ? '+' : '-'}₺${MoneyUtils().readableMoney(value < 0 ? double.parse(
                                    value.toString().replaceAll('-', ''),
                                  ) : value)}',
                                style: context.pAppStyle.interMediumBase.copyWith(
                                  fontSize: Grid.m - Grid.xxs,
                                  color: value == 0
                                      ? context.pColorScheme.iconPrimary
                                      : value > 0
                                          ? context.pColorScheme.success
                                          : context.pColorScheme.critical,
                                ),
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                            ),
                            child: CompletedProfitLossList(
                              taxDetails: state.taxDetailModel!.taxDetails!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const PDivider(),
                  Shimmerize(
                    enabled: state.isLoading || state.potentialProfitLossModel == null || state.taxDetailModel == null,
                    child: ProfitLossRow(
                      title: L10n.tr('potential_profit_loss'),
                      value: state.potentialProfitLossModel?.totalPotentialProfitLoss ?? 0.0,
                      hasIcon: state.potentialProfitLossModel?.totalPotentialProfitLoss != 0,
                      onTap: () {
                        if (state.potentialProfitLossModel?.totalPotentialProfitLoss == 0) {
                          return;
                        }

                        double value = (state.taxDetailModel!.totalPrice! +
                            state.potentialProfitLossModel!.totalPotentialProfitLoss!);

                        PBottomSheet.show(
                          context,
                          titlePadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          titleWidgetPadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          titleWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: Grid.xs,
                            children: [
                              Text(
                                '${L10n.tr('potential_profit_loss')}:',
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              Text(
                                '${value == 0 ? '' : value > 0 ? '+' : '-'}₺${MoneyUtils().readableMoney(value < 0 ? double.parse(
                                    value.toString().replaceAll('-', ''),
                                  ) : value)}',
                                style: context.pAppStyle.interMediumBase.copyWith(
                                  fontSize: Grid.m - Grid.xxs,
                                  color: value == 0
                                      ? context.pColorScheme.iconPrimary
                                      : value > 0
                                          ? context.pColorScheme.success
                                          : context.pColorScheme.critical,
                                ),
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                            ),
                            child: PotentialProfitLossList(
                              overallItemGroups: state.potentialProfitLossModel!.overallItemGroups,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const PDivider(),
                  Shimmerize(
                    enabled: state.isLoading || state.potentialProfitLossModel == null && state.taxDetailModel == null,
                    child: ProfitLossRow(
                      title: L10n.tr('total_profit_loss'),
                      value: ((state.taxDetailModel?.totalPrice ?? 0) +
                          (state.potentialProfitLossModel?.totalPotentialProfitLoss ?? 0)),
                      hasIcon: false,
                    ),
                  ),
                  const PDivider(),
                  const TargetWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
