import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_calculate_row.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_select_row.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class WarrantCalculatePage extends StatefulWidget {
  final MarketListModel? symbol;
  const WarrantCalculatePage({
    super.key,
    this.symbol,
  });

  @override
  State<WarrantCalculatePage> createState() => _WarrantCalculatePageState();
}

class _WarrantCalculatePageState extends State<WarrantCalculatePage> {
  late SymbolModel? _symbolModel;
  WarrantCalculateModel? _calculate;
  late MatriksBloc _matriksBloc;
  List<Map<String, dynamic>> instrumentList = [];
  TextEditingController underlyingController = TextEditingController();
  TextEditingController volatilityController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  double underlyingValue = 0;
  double volatilityValue = 0;
  double interestRateValue = 0;

  @override
  void initState() {
    _matriksBloc = getIt<MatriksBloc>();
    _symbolModel = widget.symbol != null ? SymbolModel.fromMarketListModel(widget.symbol!) : null;
    if (_symbolModel == null) return;

    /// Verilen varantin hesaplamalarını almak için MatriksWarrantCalculatorEvent eventini tetikler.
    _matriksBloc.add(
      MatriksWarrantCalculatorEvent(
        symbol: _symbolModel!.name,
        callback: (calculate) {
          _calculate = calculate;
          _updateValues(_calculate);
          _selectedDate = _calculate != null ? DateTime.parse(_calculate!.referenceDate!) : DateTime.now();
          setState(() {});
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('warrant_calculator'),
      ),
      body: PBlocBuilder<MatriksBloc, MatriksState>(
        bloc: _matriksBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const PLoading();
          }
          return SafeArea(
            top: false,
            left: false,
            right: false,
            child: Padding(
              padding: const EdgeInsets.all(
                Grid.m,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            splashColor: context.pColorScheme.transparent,
                            highlightColor: context.pColorScheme.transparent,
                            onTap: () {
                              router.push(
                                SymbolSearchRoute(
                                  appBarTitle: _symbolModel?.name,
                                  filterList: const [SymbolSearchFilterEnum.warrant],
                                  showExchangesFilter: false,
                                  onTapSymbol: (symbolModelList) {
                                    getIt<MatriksBloc>().add(
                                      MatriksWarrantCalculatorEvent(
                                          symbol: symbolModelList.first.name,
                                          callback: (calculate) {
                                            setState(() {
                                              _calculate = calculate;
                                              _symbolModel = symbolModelList.first;
                                              _updateValues(_calculate);
                                            });
                                          }),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 43,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                              decoration: BoxDecoration(
                                color: context.pColorScheme.stroke,
                                borderRadius: BorderRadius.circular(Grid.l),
                              ),
                              child: Row(
                                spacing: Grid.xs,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ImagesPath.search,
                                    height: 17,
                                    width: 17,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.textSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _symbolModel?.name ?? L10n.tr('warrant_search'),
                                      style: context.pAppStyle.labelReg16textPrimary,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: context.pColorScheme.transparent,
                                    highlightColor: context.pColorScheme.transparent,
                                    onTap: () {
                                      setState(() {
                                        _symbolModel = null;
                                        _calculate = null;
                                        _updateValues(_calculate);
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      ImagesPath.x,
                                      height: 17,
                                      width: 17,
                                      colorFilter: ColorFilter.mode(
                                        context.pColorScheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Grid.m - Grid.xxs,
                          ),
                          const PDivider(),
                          WarrantCalculateRow(
                            title: L10n.tr('underlying_asset_value'),
                            controller: underlyingController,
                            prefixLabel: '${CurrencyEnum.turkishLira.symbol} ',
                            priceStep: _calculate?.underlyingStep ?? 0.01,
                            onChanged: (value) {
                              setState(() {
                                underlyingValue = value;
                              });
                            },
                          ),
                          WarrantCalculateRow(
                            title: L10n.tr('volatility'),
                            controller: volatilityController,
                            priceStep: _calculate?.volatilityStep ?? 0.01,
                            onChanged: (value) {
                              setState(() {
                                volatilityValue = value;
                              });
                            },
                          ),
                          WarrantCalculateRow(
                            title: L10n.tr('interest_rate'),
                            controller: interestRateController,
                            prefixLabel: '% ',
                            priceStep: _calculate?.interestRateStep ?? 0.01,
                            onChanged: (value) {
                              setState(() {
                                interestRateValue = value;
                              });
                            },
                          ),
                          const SizedBox(height: Grid.s + Grid.xs),
                          DateSelectRow(
                            leading: L10n.tr('reference_date'),
                            trailing: DateTimeUtils.dateFormat(_selectedDate!),
                            selectedDate: _selectedDate,
                            onDateSelected: (DateTime pickedDate) => setState(() => _selectedDate = pickedDate),
                          ),
                          const SizedBox(height: Grid.s + Grid.xs),
                          const PDivider(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  OrderApprovementButtons(
                    cancelButtonText: L10n.tr('reset'),
                    approveButtonText: L10n.tr('calculate'),
                    onPressedCancel: () {
                      setState(() {
                        _updateValues(_calculate);
                        _selectedDate = DateTime.now();
                      });
                    },
                    onPressedApprove: () {
                      if (_symbolModel == null) return;

                      /// Varantin grafik verilerini ceker ve asil hesaplamayi yapar
                      _matriksBloc.add(
                        MatriksWarrantCalculatorDetailsEvent(
                          symbol: _symbolModel!.name,
                          underlyingValue: MoneyUtils().fromReadableMoney(underlyingController.text),
                          volatility: MoneyUtils().fromReadableMoney(volatilityController.text),
                          interestRate: MoneyUtils().fromReadableMoney(interestRateController.text),
                          referenceDate:
                              '${_selectedDate!.year}${_selectedDate!.month.toString().padLeft(2, '0')}${_selectedDate!.day.toString().padLeft(2, '0')}',
                          callback: (WarrantCalculateDetailsModel calculateDetails) => router.push(
                            WarrantCalculateDetailsRoute(
                              calculateDetails: calculateDetails,
                              symbol: _symbolModel!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _updateValues(WarrantCalculateModel? calculate) {
    setState(() {
      underlyingValue = calculate?.underlyingValue ?? 0;
      underlyingController.text = MoneyUtils().readableMoney(underlyingValue);
      volatilityValue = calculate?.volatility ?? 0;
      volatilityController.text = MoneyUtils().readableMoney(volatilityValue);
      interestRateValue = calculate?.interestRate ?? 0;
      interestRateController.text = MoneyUtils().readableMoney(interestRateValue);
    });
  }
}
