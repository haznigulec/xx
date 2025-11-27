import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_bloc.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_event.dart';
import 'package:piapiri_v2/app/brokerage_distribution/page/brokerage_chart_page.dart';
import 'package:piapiri_v2/app/brokerage_distribution/widget/brokerage_no_licence.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BrokerageDistributionPage extends StatefulWidget {
  final MarketListModel marketListModel;
  const BrokerageDistributionPage({
    super.key,
    required this.marketListModel,
  });

  @override
  State<BrokerageDistributionPage> createState() => _BrokerageDistributionPageState();
}

class _BrokerageDistributionPageState extends State<BrokerageDistributionPage> {
  final BrokerageBloc _brokerageBloc = getIt<BrokerageBloc>();
  final LicenseBloc _licenseBloc = getIt<LicenseBloc>();
  int _selectedInstitutionCount = 5;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int? _buyerExpandedIndex;
  int? _sellerExpandedIndex;
  bool _hasLicence = false;

  @override
  void initState() {
    SymbolTypes symbolType = stringToSymbolType(widget.marketListModel.type);

    if (symbolType == SymbolTypes.future || symbolType == SymbolTypes.option) {
      _hasLicence = _licenseBloc.state.isViopBrokerageEnabled;
    } else {
      _hasLicence = _licenseBloc.state.isBrokerageEnabled;
    }

    if (_hasLicence) {
      _brokerageBloc.add(
        BrokerageFetchEvent(
          symbol: widget.marketListModel.symbolCode,
          top: _selectedInstitutionCount,
          startDate: _startDate,
          endDate: _endDate,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: !_hasLicence
          ? const BrokerageNoLicence()
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      BottomsheetButton(
                        title: DateTimeUtils.dateFormat(_startDate),
                        onPressed: () async {
                          await showPDatePicker(
                            context: context,
                            initialDate: _startDate,
                            cancelTitle: L10n.tr('iptal'),
                            doneTitle: L10n.tr('tamam'),
                            onChanged: (selectedDate) {
                              if (selectedDate == null) return;
                              setState(() {
                                _startDate = selectedDate;
                                _buyerExpandedIndex = null;
                                _sellerExpandedIndex = null;
                              });
                              _brokerageBloc.add(
                                BrokerageFetchEvent(
                                  symbol: widget.marketListModel.symbolCode,
                                  top: _selectedInstitutionCount,
                                  startDate: _startDate,
                                  endDate: _endDate,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: Grid.s),
                      BottomsheetButton(
                        title: DateTimeUtils.dateFormat(_endDate),
                        onPressed: () async {
                          await showPDatePicker(
                            context: context,
                            initialDate: _endDate,
                            cancelTitle: L10n.tr('iptal'),
                            doneTitle: L10n.tr('tamam'),
                            onChanged: (selectedDate) {
                              if (selectedDate == null) return;
                              setState(() {
                                _endDate = selectedDate;
                                _buyerExpandedIndex = null;
                                _sellerExpandedIndex = null;
                              });
                              _brokerageBloc.add(
                                BrokerageFetchEvent(
                                  symbol: widget.marketListModel.symbolCode,
                                  top: _selectedInstitutionCount,
                                  startDate: _startDate,
                                  endDate: _endDate,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: Grid.s),
                      BottomsheetButton(
                        title: L10n.tr('top_institution', args: ['$_selectedInstitutionCount']),
                        onPressed: () {
                          PBottomSheet.show(
                            context,
                            title: L10n.tr('kurum'),
                            child: ListView.separated(
                              itemCount: _institutionCountList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return BottomsheetSelectTile(
                                  title: L10n.tr('top_institution', args: ['${_institutionCountList[index]}']),
                                  value: _institutionCountList[index],
                                  isSelected: _selectedInstitutionCount == _institutionCountList[index],
                                  onTap: (title, value) {
                                    setState(() {
                                      _selectedInstitutionCount = value;
                                      _buyerExpandedIndex = null;
                                      _sellerExpandedIndex = null;
                                    });
                                    _brokerageBloc.add(
                                      BrokerageFetchEvent(
                                        symbol: widget.marketListModel.symbolCode,
                                        top: _selectedInstitutionCount,
                                        startDate: _startDate,
                                        endDate: _endDate,
                                      ),
                                    );

                                    router.maybePop();
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => const PDivider(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                const PDivider(),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                BrokerageChartPage(
                  institutionCount: _selectedInstitutionCount,
                  isBuyer: true,
                  subExpandedIndex: _buyerExpandedIndex,
                  onTapSubTile: (index) {
                    if (_buyerExpandedIndex == index) {
                      _buyerExpandedIndex = null;
                    } else {
                      _buyerExpandedIndex = index;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: Grid.l),
                BrokerageChartPage(
                  institutionCount: _selectedInstitutionCount,
                  isBuyer: false,
                  subExpandedIndex: _sellerExpandedIndex,
                  onTapSubTile: (index) {
                    if (_sellerExpandedIndex == index) {
                      _sellerExpandedIndex = null;
                    } else {
                      _sellerExpandedIndex = index;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: Grid.m),
              ],
            ),
    );
  }
}

final List<int> _institutionCountList = [5, 10, 15];
