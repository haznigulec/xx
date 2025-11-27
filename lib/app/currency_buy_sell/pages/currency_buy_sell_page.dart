import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_state.dart';
import 'package:piapiri_v2/app/currency_buy_sell/pages/currency_buy_page.dart';
import 'package:piapiri_v2/app/currency_buy_sell/pages/currency_sell_page.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class CurrencyBuySellPage extends StatefulWidget {
  final CurrencyEnum currencyType;
  final List<AccountModel> accountsByCurrency;
  const CurrencyBuySellPage({
    super.key,
    required this.currencyType,
    required this.accountsByCurrency,
  });

  @override
  State<CurrencyBuySellPage> createState() => _CurrencyBuySellPageState();
}

class _CurrencyBuySellPageState extends State<CurrencyBuySellPage> {
  int _selectedSegmentedIndex = 0;
  late CurrencyBuySellBloc _currencyBuySellBloc;

  @override
  void initState() {
    _currencyBuySellBloc = getIt<CurrencyBuySellBloc>();

    _currencyBuySellBloc.add(
      GetSystemParametersEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: '${L10n.tr(widget.currencyType.name)} ${L10n.tr('buy/sell')}',
      ),
      body: SafeArea(
        /// PBlocBuilder ve isMarketClosed kısımları; Euro, Sterlin özelliği tekrar açıldığı zaman buradan kaldırılacak, CurrencyTypeListWidget ten devam edilecek.
        child: PBlocBuilder<CurrencyBuySellBloc, CurrencyBuySellState>(
            bloc: _currencyBuySellBloc,
            builder: (context, state) {
              DateTime startDate = state.systemParametersModel?.fcStartTime ??
                  DateTime.now().copyWith(
                    hour: 09,
                    minute: 00,
                  );
              DateTime endDate = state.systemParametersModel?.fcEndTime ??
                  DateTime.now().copyWith(
                    hour: 18,
                    minute: 00,
                  );

              DateTime now = getIt<TimeBloc>().state.mxTime != null
                  ? DateTime.fromMicrosecondsSinceEpoch(
                      getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
                    )
                  : DateTime.fromMicrosecondsSinceEpoch(
                      DateTime.now().microsecondsSinceEpoch,
                    );

              bool isMarketClosed = now.hour < startDate.hour || now.hour >= endDate.hour;

              if (DateTimeUtils().isWeekend() || DateTimeUtils().isHoliday()) {
                isMarketClosed = true;
              }

              return isMarketClosed
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: Grid.l,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: Grid.s,
                            children: [
                              Text(
                                L10n.tr('closed'),
                                style: context.pAppStyle.labelMed22textPrimary,
                              ),
                              SvgPicture.asset(
                                ImagesPath.moon,
                                colorFilter: ColorFilter.mode(
                                  context.pColorScheme.critical,
                                  BlendMode.srcIn,
                                ),
                                width: 14,
                                height: 14,
                              )
                            ],
                          ),
                          Text(
                            '${L10n.tr(
                              'currency_transaction_working_hour_info',
                              args: [
                                startDate.formatTimeHourMinute(),
                                endDate.formatTimeHourMinute(),
                              ],
                            )} ${L10n.tr('currency_transcation_specified_time_info')}',
                            textAlign: TextAlign.center,
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          const SizedBox(
                            height: Grid.l,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: Grid.l - Grid.xs,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 35,
                            child: SlidingSegment(
                              backgroundColor: context.pColorScheme.card,
                              segmentList: [
                                PSlidingSegmentModel(
                                  segmentTitle: L10n.tr(
                                    'currency_buy',
                                    args: [
                                      L10n.tr(widget.currencyType.name),
                                    ],
                                  ),
                                  segmentColor: context.pColorScheme.secondary,
                                ),
                                PSlidingSegmentModel(
                                  segmentTitle: L10n.tr(
                                    'currency_sell',
                                    args: [
                                      L10n.tr(widget.currencyType.name),
                                    ],
                                  ),
                                  segmentColor: context.pColorScheme.secondary,
                                ),
                              ],
                              onValueChanged: (index) {
                                setState(() {
                                  _selectedSegmentedIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Expanded(
                            child: _selectedSegmentedIndex == 0
                                ? CurrencyBuyPage(
                                    currencyType: widget.currencyType,
                                    currencyAccountList: widget.accountsByCurrency,
                                  )
                                : CurrencySellPage(
                                    currencyType: widget.currencyType,
                                    accountsByCurrency: widget.accountsByCurrency,
                                  ),
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
