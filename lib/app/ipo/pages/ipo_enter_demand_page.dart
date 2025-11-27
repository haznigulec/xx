import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/list/selection_list_item.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_active_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_add_data_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_approve_data_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_detail_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/repository/ipo_repository_impl.dart';
import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_account_list_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/demand_detail_row.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class IpoEnterDemandPage extends StatefulWidget {
  final IpoDetailModel ipoDetail;
  final IpoModel ipo;
  final VoidCallback onSuccess;
  final bool hasSymbolHE;
  const IpoEnterDemandPage({
    super.key,
    required this.ipoDetail,
    required this.ipo,
    required this.onSuccess,
    required this.hasSymbolHE,
  });

  @override
  State<IpoEnterDemandPage> createState() => IpoEnterDemandPageState();
}

class IpoEnterDemandPageState extends State<IpoEnterDemandPage> {
  final TextEditingController _demandedUnitTC = TextEditingController(text: '0');
  final TextEditingController _amountTC = TextEditingController(text: '0');
  final TextEditingController _askingPriceUnitTC = TextEditingController();
  final TextEditingController _askingPriceAmountTC = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedPaymentTypeName = 'ipo_cash';
  int _selectedPaymentTypeId = 0;
  final String _selectedApplicationTypeTitle = L10n.tr('miktarsal');
  final int _selectedApplicationTypeId = 1;
  int _selectedKktcCitizenId = 0;
  bool _isAggrementAccepted = false;
  String _selectedAccount = '';
  late IpoBloc _ipoBloc;
  int _demandedUnit = 0;
  bool _isPaymentTypeBlockage = false;
  String _ipoId = '';
  double _ipoPrice = 0;
  double _amount = 0;
  List<Map<String, dynamic>> _paymentTypeDropdownList = [];
  List<Map<String, dynamic>> _highDemnadPaymentTypeDropdownList = [];
  double? _maxBlockedQuantity;
  double _demandedMinUnit = 1;
  List<DefinitionsList> _definitionsList = [];
  String? _transactionType;
  List<dynamic> _accountList = [];
  List<String> _accountItemList = [];
  bool isKeyboardClosed = true;
  String _startEndPrice = '';
  int _slidingSegmentedIndex = 0;
  String _deputyName = '';
  double _askingUnitPrice = 0;
  double _askingAmountPrice = 0;
  bool _isInsufficient = false;
  late TabBloc _tabBloc;
  double? _totalBuyableUnit;
  final ValueNotifier<int> _buyableUnit = ValueNotifier(0);
  late IpoAddDataModel _blockageData;
  String? _selectedPaymentTypeForBlockage;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _tabBloc = getIt<TabBloc>();

    getIt<Analytics>().track(
      AnalyticsEvents.halkaArzTalepGirisiPageView,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.ipoTab.value,
      ],
    );

    _askingUnitPrice = widget.ipoDetail.startPrice ?? 0;
    _askingPriceUnitTC.text = MoneyUtils().readableMoney(_askingUnitPrice);

    _askingAmountPrice = widget.ipoDetail.startPrice ?? 0;
    _askingPriceAmountTC.text = MoneyUtils().readableMoney(_askingAmountPrice);

    _accountList = IpoRepositoryImpl().readAccountList().where((e) => e['currencyType'] == 'TRY').toList();

    _accountItemList = [
      ..._accountList.map(
        (e) => e['accountExtId'].toString(),
      ),
    ];
    _selectedAccount = _accountItemList[0];

    if (widget.ipoDetail.startPrice != null) {
      if (widget.ipoDetail.endPrice == null) {
        _startEndPrice = '₺${MoneyUtils().readableMoney(widget.ipoDetail.startPrice!)}';
      } else {
        _startEndPrice =
            '₺${MoneyUtils().readableMoney(widget.ipoDetail.startPrice!)} - ₺${MoneyUtils().readableMoney(widget.ipoDetail.endPrice!)}';
      }
    }

    _ipoBloc.add(
      GetActiveInfoEvent(
        customerId: _selectedAccount.split('-')[0],
        accountId: _selectedAccount.split('-')[1],
        callback: (deputyName, ipoActiveInfoModel) {
          _deputyName = deputyName;

          if (ipoActiveInfoModel.definitionsList != null && ipoActiveInfoModel.definitionsList!.isNotEmpty) {
            // seçilen halka arzın datasını bulmak için
            _definitionsList = ipoActiveInfoModel.definitionsList!
                .where(
                  (element) => element.name!.contains(widget.ipoDetail.symbol ?? ''),
                )
                .toList();

            if (_definitionsList.isEmpty) return;

            for (var item in _definitionsList) {
              _ipoId = item.ipoId ?? '';

              // Halka Arz Fiyatı
              _ipoPrice = item.price ?? 0;

              // Talep Edilen Adet
              // _demandedUnit = (item.minimumNominal ?? 0).toInt();

              if (_selectedApplicationTypeId == 0) {
                _demandedUnitTC.text = '0';
              }

              // Tutar
              // _amount = (item.minimumNominal ?? 0) * _ipoPrice;

              // Ödeme Tipi
              _paymentTypeDropdownList = item.paymentType
                  .map(
                    (paymentType) => {
                      'title': paymentType.title,
                      'value': int.parse(paymentType.key),
                    },
                  )
                  .toList();
              _highDemnadPaymentTypeDropdownList = item.highDemandPaymentTypes
                  .map(
                    (paymentType) => {
                      'title': paymentType.title,
                      'value': int.parse(paymentType.key),
                    },
                  )
                  .toList();
              _maxBlockedQuantity = item.maxBlockedQuantity;

              _demandedMinUnit = item.minimumNominal ?? 0.0;
              _transactionType = item.ipoTransactionType ?? '';
            }
          }

          setState(() {});
        },
      ),
    );

    _ipoBloc.add(
      GetCashBalanceEvent(
        customerId: _selectedAccount.split('-')[0],
        accountId: _selectedAccount.split('-')[1],
        typeName: 'CASH-T2',
      ),
    );
    _ipoBloc.add(
      GetTradeLimitEvent(
        customerId: _selectedAccount.split('-')[0],
        accountId: _selectedAccount.split('-')[1],
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _buyableUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? decodedBytesUint8List = widget.ipo.companyLogo != null ? base64.decode(widget.ipo.companyLogo!) : null;

    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('join_public_offering'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PSymbolTile(
                variant: PSymbolVariant.ipoActive,
                title: widget.ipoDetail.symbol,
                subTitle: widget.ipoDetail.companyName,
                titleWidget: decodedBytesUint8List != null
                    ? ClipOval(
                        child: Image.memory(
                          decodedBytesUint8List,
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Utils.generateCapitalFallback(
                        context,
                        widget.ipo.symbol ?? 'U',
                        size: 38,
                      ),
              ),
              const PDivider(
                padding: EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${L10n.tr('ipo_price')}: ',
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  Text(
                    _startEndPrice,
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ],
              ),
              const SizedBox(
                height: Grid.l,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: SlidingSegment(
                  backgroundColor: context.pColorScheme.card,
                  segmentList: [
                    PSlidingSegmentModel(
                      segmentTitle: L10n.tr('adet'),
                      segmentColor: context.pColorScheme.secondary,
                    ),
                    PSlidingSegmentModel(
                      segmentTitle: L10n.tr('tutar'),
                      segmentColor: context.pColorScheme.secondary,
                    ),
                  ],
                  onValueChanged: (p0) {
                    setState(() {
                      _slidingSegmentedIndex = p0;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              _slidingSegmentedIndex == 0 ? _slidingUnitWidget() : _slidingAmountWidget(),
              const SizedBox(
                height: Grid.l,
              ),
              _accountItemList.length == 1
                  ? Text(
                      _selectedAccount,
                      style: context.pAppStyle.labelMed14textTeritary,
                    )
                  : IpoAccountListWidget(
                      accountItemList: _accountItemList,
                      selectedAccount: _selectedAccount,
                      onAccountSelected: (selectedAccount) {
                        setState(() {
                          _selectedAccount = selectedAccount;
                        });
                      },
                    ),
              const SizedBox(
                height: Grid.s,
              ),
              Container(
                padding: const EdgeInsets.all(
                  Grid.m,
                ),
                decoration: BoxDecoration(
                  color: context.pColorScheme.card,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      Grid.m,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _cashBalanceWidget(),
                    const SizedBox(
                      width: Grid.m,
                    ),
                    Container(
                      width: Grid.xxs / 2,
                      height: Grid.m - Grid.xxs,
                      color: context.pColorScheme.textTeritary,
                    ),
                    const SizedBox(
                      width: Grid.m,
                    ),
                    _tradeLimitWidget(),
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.l,
              ),
              if (widget.ipo.symbol!.toUpperCase().contains('.HE')) ...[
                PInfoWidget(
                  infoText: L10n.tr('ipo_he_description'),
                )
              ] else ...[
                _paymentTypeWidget(),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                _kktcWidget(),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                PCheckboxListItem(
                  title: L10n.tr('ipo_demand_info'),
                  value: _isAggrementAccepted,
                  leadingWidgetSize: const Size(25, 25),
                  leadingWidth: 0,
                  allowOverflow: true,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  onChanged: (bool? isSelected) {
                    setState(() {
                      _isAggrementAccepted = isSelected!;
                    });
                  },
                ),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _buyableUnit,
          builder: (context, value, child) {
            return generalButtonPadding(
              context: context,
              child: PButton(
                text: L10n.tr('join_public_offering'),
                fillParentWidth: true,
                onPressed:

                    ///  _selectedPaymentTypeId == 0 Ödeme Tipi Nakit ise kontrolü eklendi, yetersiz işlem
                    /// limitine nakit değilse takılmaması için.
                    (_selectedPaymentTypeId == 0 && _isInsufficient) || value == 0 ? null : () => _buttonClickEvent(),
              ),
            );
          }),
    );
  }

  Widget _cashBalanceWidget() {
    return PBlocBuilder<IpoBloc, IpoState>(
        bloc: _ipoBloc,
        builder: (context, state) {
          return Shimmerize(
            enabled: state.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${L10n.tr('cash_balance')}:',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.cashBalance ?? 0.0)}',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
          );
        });
  }

  Widget _slidingUnitWidget() {
    return PBlocBuilder<IpoBloc, IpoState>(
        bloc: _ipoBloc,
        builder: (context, state) {
          final int calculation =
              ((state.ipoTradeLimitModel?.tradeLimit ?? 0) / (widget.ipoDetail.startPrice ?? 1)).floor();
          int buyableUnit = calculation < 0 ? 0 : calculation;
          double amount = widget.ipoDetail.endPrice != null
              ? _demandedUnit * _askingUnitPrice
              : _demandedUnit * widget.ipoDetail.startPrice!;
          _isInsufficient = amount > (widget.ipoDetail.startPrice! * buyableUnit);

          _amount = amount;

          _buyableUnit.value = buyableUnit;

          return Column(
            children: [
              if (widget.ipo.endPrice != null) ...[
                PValueTextfieldWidget(
                  controller: _askingPriceUnitTC,
                  title: L10n.tr('demand_price'),
                  prefixText: CurrencyEnum.turkishLira.symbol,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: [
                    AppInputFormatters.decimalFormatter(
                      maxDigitAfterSeparator: 2,
                    ),
                  ],
                  onSubmitted: (value) {
                    setState(() {
                      _askingUnitPrice = MoneyUtils().fromReadableMoney(value);
                      _askingPriceUnitTC.text = MoneyUtils().readableMoney(_askingUnitPrice);

                      FocusScope.of(context).unfocus();
                    });
                  },
                )
              ],
              const SizedBox(
                height: Grid.s,
              ),
              PValueTextfieldWidget(
                key: const ValueKey('unit'),
                controller: _demandedUnitTC,
                title: L10n.tr('adet'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  AppInputFormatters.decimalFormatter(
                    maxDigitAfterSeparator: 0,
                  ),
                ],
                subTitle: InkWell(
                  onTap: () {
                    setState(() {
                      _demandedUnitTC.text = buyableUnit.toString();
                      _demandedUnit = buyableUnit;

                      _totalBuyableUnit = widget.ipoDetail.endPrice != null
                          ? buyableUnit * _askingUnitPrice
                          : buyableUnit * widget.ipoDetail.startPrice!;

                      _amountTC.text = MoneyUtils().readableMoney(_totalBuyableUnit!);
                    });
                  },
                  child: Text(
                    '${L10n.tr('alinabilir_adet')}: $buyableUnit',
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.s + Grid.xxs,
                      color: buyableUnit == 0 ? context.pColorScheme.critical : context.pColorScheme.textSecondary,
                    ),
                  ),
                ),
                prefixText: '',
                onSubmitted: (value) {
                  setState(() {
                    _totalBuyableUnit = null;
                    _demandedUnit = MoneyUtils().fromReadableMoney(value).toInt();
                    _demandedUnitTC.text = value;

                    amount = _demandedUnit * _askingUnitPrice;

                    _amountTC.text = MoneyUtils().readableMoney(amount);
                    if (_maxBlockedQuantity != null &&
                        _demandedUnit > _maxBlockedQuantity! &&
                        _highDemnadPaymentTypeDropdownList.isNotEmpty &&
                        _selectedPaymentTypeId != _highDemnadPaymentTypeDropdownList.first['value']) {
                      _onSelectPaymentType(_highDemnadPaymentTypeDropdownList.first);
                    }
                    _isInsufficient = amount > (widget.ipoDetail.startPrice! * buyableUnit);

                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              const SizedBox(
                height: Grid.s,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    L10n.tr('tutar'),
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Text(
                    '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_totalBuyableUnit != null ? _totalBuyableUnit! : amount)}',
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m + Grid.xxs,
                      color: _isInsufficient ? context.pColorScheme.critical : context.pColorScheme.textPrimary,
                    ),
                  ),
                ],
              ),
              if (_isInsufficient) ...[
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  L10n.tr('insufficient_transaction_limit'),
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.s + Grid.xs,
                    color: context.pColorScheme.critical,
                  ),
                ),
              ],
            ],
          );
        });
  }

  Widget _slidingAmountWidget() {
    return PBlocBuilder<IpoBloc, IpoState>(
        bloc: _ipoBloc,
        builder: (context, state) {
          return Column(
            children: [
              if (widget.ipo.endPrice != null)
                PValueTextfieldWidget(
                  controller: _askingPriceAmountTC,
                  title: L10n.tr('demand_price'),
                  suffixText: CurrencyEnum.turkishLira.symbol,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: [
                    AppInputFormatters.decimalFormatter(
                      maxDigitAfterSeparator: 2,
                    ),
                  ],
                  onSubmitted: (value) {
                    setState(() {
                      _askingAmountPrice = MoneyUtils().fromReadableMoney(value);
                      _askingPriceAmountTC.text = MoneyUtils().readableMoney(_askingAmountPrice);

                      if (widget.ipoDetail.endPrice != null) {
                        _amount = ((_amount / _askingAmountPrice).floor()) * _askingAmountPrice;
                      }

                      _demandedUnit = widget.ipoDetail.endPrice != null
                          ? _askingAmountPrice == 0
                              ? 0
                              : (_amount / _askingAmountPrice).floor().toInt()
                          : (_amount / widget.ipoDetail.startPrice!).floor().toInt();

                      _isInsufficient = _amount > (state.ipoTradeLimitModel!.tradeLimit ?? 0);

                      FocusScope.of(context).unfocus();
                    });
                  },
                ),
              const SizedBox(
                height: Grid.s,
              ),
              PValueTextfieldWidget(
                key: const ValueKey('amount'),
                controller: _amountTC,
                title: L10n.tr('tutar'),
                errorText: _isInsufficient ? L10n.tr('insufficient_transaction_limit') : null,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                inputFormatters: [
                  AppInputFormatters.decimalFormatter(
                    maxDigitAfterSeparator: 2,
                  ),
                ],
                onTapPrice: () {
                  if (MoneyUtils().fromReadableMoney(_amountTC.text) == 0) {
                    _amountTC.text = '';
                  }
                },
                onSubmitted: (value) {
                  setState(() {
                    _totalBuyableUnit = null;
                    _amount = MoneyUtils().fromReadableMoney(value);

                    if (widget.ipoDetail.endPrice != null) {
                      _amount = ((_amount / _askingAmountPrice).floor()) * _askingAmountPrice;
                    }

                    var unitPrice = widget.ipoDetail.endPrice != null
                        ? _askingAmountPrice == 0
                            ? 0
                            : (_askingAmountPrice)
                        : (widget.ipoDetail.startPrice!);

                    _demandedUnit = widget.ipoDetail.endPrice != null
                        ? _askingAmountPrice == 0
                            ? 0
                            : (_amount / _askingAmountPrice).floor().toInt()
                        : (_amount / widget.ipoDetail.startPrice!).floor().toInt();

                    _demandedUnitTC.text = _demandedUnit.toString();

                    _amount = (_demandedUnit * unitPrice).toDouble();
                    _amountTC.text = MoneyUtils().readableMoney(_amount);
                    if (_maxBlockedQuantity != null &&
                        _demandedUnit > _maxBlockedQuantity! &&
                        _highDemnadPaymentTypeDropdownList.isNotEmpty &&
                        _selectedPaymentTypeId != _highDemnadPaymentTypeDropdownList.first['value']) {
                      _onSelectPaymentType(_highDemnadPaymentTypeDropdownList.first);
                    }

                    _isInsufficient = _amount > (state.ipoTradeLimitModel!.tradeLimit ?? 0);

                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              const SizedBox(
                height: Grid.s,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.s,
                    ),
                    child: Text(
                      L10n.tr('estimated_quantity'),
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.s - Grid.xxs,
                    ),
                    child: Text(
                      _totalBuyableUnit != null
                          ? '${(_totalBuyableUnit! / widget.ipoDetail.startPrice!).floor()}'
                          : widget.ipoDetail.endPrice != null
                              ? '${_askingAmountPrice == 0 ? 0 : (_amount / _askingAmountPrice).floor()}'
                              : '${(_amount / widget.ipoDetail.startPrice!).floor()}',
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m + Grid.xxs,
                        color: _isInsufficient ? context.pColorScheme.critical : context.pColorScheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isInsufficient && _slidingSegmentedIndex == 0) ...[
                Text(
                  L10n.tr('insufficient_transaction_limit'),
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.s + Grid.xs,
                    color: context.pColorScheme.critical,
                  ),
                ),
              ],
            ],
          );
        });
  }

  Widget _paymentTypeWidget() {
    return InkWell(
      onTap: () {
        List<Widget> paymentTypeListWidget = [];
        List<Map<String, dynamic>> paymentTypeList = _maxBlockedQuantity != null &&
                MoneyUtils().fromReadableMoney(_demandedUnitTC.text) > _maxBlockedQuantity! &&
                _highDemnadPaymentTypeDropdownList.isNotEmpty
            ? _highDemnadPaymentTypeDropdownList
            : _paymentTypeDropdownList;
        for (var i = 0; i < paymentTypeList.length; i++) {
          paymentTypeListWidget.add(
            FilterCategoryButton(
              hasDivider: i != paymentTypeList.length - 1,
              onTap: () => _onSelectPaymentType(paymentTypeList[i]),
              title: L10n.tr(
                paymentTypeList[i]['title'],
              ),
              isSelected: _selectedPaymentTypeName == paymentTypeList[i]['title'],
            ),
          );
        }

        PBottomSheet.show(
          context,
          title: L10n.tr('payment_type'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paymentTypeListWidget,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.xs,
              ),
              child: Text(
                L10n.tr('payment_type'),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ),
            Row(
              children: [
                Text(
                  L10n.tr(
                    _selectedPaymentTypeName,
                  ),
                  style: context.pAppStyle.labelMed14primary,
                ),
                const SizedBox(
                  width: Grid.xxs,
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_down,
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onSelectPaymentType(Map<String, dynamic> selectedPayment) {
    setState(() {
      _isPaymentTypeBlockage = selectedPayment['title'] != 'ipo_cash';

      if (_isPaymentTypeBlockage) {
        if (_demandedUnitTC.text.isEmpty || _demandedUnitTC.text == '0' || _demandedUnitTC.text == '0,00') {
          // Adet alanı boş ise uyarı mesajı gösteriyoruz.
          PBottomSheet.show(
            context,
            child: Column(
              spacing: Grid.m,
              children: [
                SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  L10n.tr('please_enter_unit'),
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                PButton(
                    text: L10n.tr('tamam'),
                    fillParentWidth: true,
                    onPressed: () async {
                      await router.maybePop();
                      await router.maybePop();
                    })
              ],
            ),
          );
          _isPaymentTypeBlockage = false;
          return;
        }

        // burası ödeme tipi blokaj seçilen yer
        _goBlockagePage(
          selectedPayment['title'],
          selectedPayment['value'],
        );

        _selectedPaymentTypeName = selectedPayment['title'];
        _selectedPaymentTypeId = selectedPayment['value'];
        return;
      }

      _selectedPaymentTypeName = selectedPayment['title'];
      _selectedPaymentTypeId = selectedPayment['value'];
      _selectedPaymentTypeForBlockage = null;
      router.maybePop();
    });
  }

  void _goBlockagePage(
    String paymentTypeName,
    int paymentTypeId,
  ) async {
    if (_selectedPaymentTypeForBlockage != null) {
      // daha önce blokaj seçilmiş ise uyarı mesajı gösteriyoruz.

      return PBottomSheet.show(
        context,
        child: Column(
          spacing: Grid.m,
          children: [
            SvgPicture.asset(
              ImagesPath.alert_circle,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Text(
              L10n.tr(
                'ipo_blockage_reset_warning',
                args: [
                  L10n.tr(paymentTypeName),
                  L10n.tr(_selectedPaymentTypeName),
                ],
              ),
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              height: Grid.xs,
            ),
            OrderApprovementButtons(
              cancelButtonText: L10n.tr('vazgec'),
              onPressedCancel: () {
                router.maybePop();
                return;
              },
              approveButtonText: L10n.tr('reset'),
              onPressedApprove: () {
                router.maybePop();
                _checkBlockageIsExist(paymentTypeId, paymentTypeName);
              },
            ),
          ],
        ),
      );
    }

    _checkBlockageIsExist(paymentTypeId, paymentTypeName);
  }

  void _checkBlockageIsExist(
    int paymentTypeId,
    String paymentTypeName,
  ) {
    _ipoBloc.add(
      GetBlockageEvent(
        customerId: _selectedAccount.split('-')[0],
        accountId: _selectedAccount.split('-')[1],
        ipoId: _ipoId,
        paymentType: paymentTypeId,
        isEmpty: (isEmpty) async {
          if (isEmpty) {
            return PBottomSheet.showError(
              context,
              content: paymentTypeId == 5
                  ? L10n.tr('ipo_blockage_list_empty_alert_for_fund')
                  : paymentTypeId == 4
                      ? L10n.tr('ipo_blockage_list_empty_alert_for_currency')
                      : L10n.tr('ipo_blockage_list_empty_alert_for_bist_equity'), // Hisse Blokajı için
            );
          } else {
            IpoAddDataModel addDataModel = IpoAddDataModel(
                customerId: _selectedAccount.split('-')[0],
                accountId: _selectedAccount.split('-')[1],
                functionName: 0, // 0(Add)
                demandDate: DateTime.now().formatToJson(),
                ipoId: _ipoId,
                unitsDemanded: _demandedUnit,
                paymentType:
                    _selectedPaymentTypeId, // 0(Nakit), 5(Fon Blokajlı), 4(Döviz Blokajlı), 10(Bist Hisse Blokajlı)
                transactionType: _transactionType ?? '',
                investorTypeId: UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
                demandGatheringType: 'M',
                totalAmount: widget.ipoDetail.endPrice != null
                    ? _demandedUnit * _askingUnitPrice
                    : MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(_amount)),
                offerPrice: widget.ipoDetail.endPrice != null ? _askingUnitPrice : _ipoPrice,
                minUnits: _demandedMinUnit.toInt(),
                customFields: IpoConstant().ipoKktcCitizenDropdownList[_selectedKktcCitizenId]['customFields'],
                symbol: widget.ipoDetail.symbol ?? '',
                demandedUnit: _demandedUnit);

            await router.push(
              IpoBlockageListRoute(
                deputyName: _deputyName,
                ipoId: _ipoId,
                paymentTypeName: paymentTypeName,
                paymentTypeId: paymentTypeId,
                ipoPrice: _amount,
                selectedAccount: _selectedAccount,
                addData: addDataModel,
                onChangedAddData: (addData) {
                  setState(() {
                    _selectedPaymentTypeName = paymentTypeName;
                    _selectedPaymentTypeId = paymentTypeId;
                    _selectedPaymentTypeForBlockage = _selectedPaymentTypeName;
                    _blockageData = addData;
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _kktcWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedKktcCitizenId == 0) {
            _selectedKktcCitizenId = 1;
          } else {
            _selectedKktcCitizenId = 0;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.xs,
              ),
              child: Text(
                L10n.tr('kktc_citizen'),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ),
            Row(
              children: [
                Text(
                  IpoConstant().ipoKktcCitizenDropdownList[_selectedKktcCitizenId]['title'],
                  style: context.pAppStyle.labelMed14primary,
                ),
                const SizedBox(
                  width: Grid.xxs,
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_list,
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buttonClickEvent() async {
    if (widget.ipoDetail.endPrice != null) {
      if (_slidingSegmentedIndex == 0) {
        if (_askingUnitPrice < widget.ipoDetail.startPrice! || _askingUnitPrice > widget.ipoDetail.endPrice!) {
          return PBottomSheet.show(
            context,
            child: Column(
              children: [
                SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Text(
                  L10n.tr(
                    'demand_price_warning',
                    args: [
                      (MoneyUtils().readableMoney(
                        widget.ipoDetail.startPrice!,
                      )),
                      (MoneyUtils().readableMoney(
                        widget.ipoDetail.endPrice!,
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
              ],
            ),
          );
        }
      } else if (_slidingSegmentedIndex == 1) {
        if (_askingAmountPrice < widget.ipoDetail.startPrice! || _askingAmountPrice > widget.ipoDetail.endPrice!) {
          return PBottomSheet.show(
            context,
            child: Column(
              children: [
                SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Text(
                  L10n.tr(
                    'demand_amount_warning',
                    args: [
                      (MoneyUtils().readableMoney(
                        widget.ipoDetail.startPrice!,
                      )),
                      (MoneyUtils().readableMoney(
                        widget.ipoDetail.endPrice!,
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
              ],
            ),
          );
        }
      }
    }
    bool isDemandIpo = _demandIpo(
      _isAggrementAccepted,
      MoneyUtils().fromReadableMoney(_demandedUnitTC.text),
      MoneyUtils().fromReadableMoney(_amountTC.text),
      callback: ({price, unit}) {
        if (price != null) {
          _amountTC.text = MoneyUtils().readableMoney(price);
        }
        if (unit != null) {
          _demandedUnitTC.text = unit.toString();
        }
      },
    );
    if (!isDemandIpo) return;

    ///  _selectedPaymentTypeId == 0 Ödeme Tipi Nakit ise kontrolü eklendi, yetersiz işlem
    /// limitine nakit değilse takılmaması için.
    if (_selectedPaymentTypeId == 0 && _isInsufficient) {
      return PBottomSheet.show(
        context,
        child: Column(
          children: [
            SvgPicture.asset(
              ImagesPath.alert_circle,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr(
                'insufficient_transaction_limit',
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
          ],
        ),
      );
    }

    IpoApproveDataModel approveModel = IpoApproveDataModel(
      symbolName: widget.ipoDetail.symbol ?? '',
      price: _ipoPrice != 0
          ? '₺${MoneyUtils().readableMoney(
              _ipoPrice,
            )}'
          : '₺${_slidingSegmentedIndex == 0 ? _askingPriceUnitTC.text : _askingPriceAmountTC.text}',
      demandedLot: _demandedUnit.toString(),
      amount: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
      paymentType: _selectedPaymentTypeName.isNotEmpty
          ? L10n.tr(_selectedPaymentTypeName)
          : _paymentTypeDropdownList[0]['title'],
      applicationType: _selectedApplicationTypeTitle,
      ipoRequestedMinUnit: _demandedMinUnit.toInt().toString(),
      kktcCitizen: IpoConstant().ipoKktcCitizenDropdownList[_selectedKktcCitizenId]['title'],
      account: _selectedAccount,
    );

    IpoAddDataModel addDataModel = IpoAddDataModel(
      customerId: _selectedAccount.split('-')[0],
      accountId: _selectedAccount.split('-')[1],
      functionName: 0, // 0(Add)
      demandDate: DateTime.now().formatToJson(),
      ipoId: _ipoId,
      unitsDemanded: _demandedUnit,
      paymentType: _selectedPaymentTypeId, // 0(Nakit)
      transactionType: _transactionType ?? '',
      investorTypeId: UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
      demandGatheringType: 'M',
      totalAmount: widget.ipoDetail.endPrice != null
          ? _demandedUnit * _askingUnitPrice
          : MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(_amount)),
      offerPrice: widget.ipoDetail.endPrice != null ? _askingUnitPrice : _ipoPrice,
      minUnits: _demandedMinUnit.toInt(),
      customFields: IpoConstant().ipoKktcCitizenDropdownList[_selectedKktcCitizenId]['customFields'],
      symbol: widget.ipoDetail.symbol ?? '',
      demandedUnit: _demandedUnit,
    );

    if (_isPaymentTypeBlockage) {
      _applyBlockage();
    } else {
      getIt<Analytics>().track(
        AnalyticsEvents.halkaArzTalepGirisiVerPageView,
        taxonomy: [
          InsiderEventEnum.controlPanel.value,
          InsiderEventEnum.marketsPage.value,
          InsiderEventEnum.ipoTab.value,
        ],
      );

      String price = MoneyUtils().readableMoney(widget.ipoDetail.startPrice!);

      if (widget.ipoDetail.endPrice != null) {
        if (_slidingSegmentedIndex == 0) {
          price = _askingPriceUnitTC.text;
        } else {
          price = _askingPriceAmountTC.text;
        }
      }

      return PBottomSheet.show(
        context,
        title: L10n.tr('request_approval'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledText(
              text: _slidingSegmentedIndex == 0
                  ? L10n.tr(
                      'ipo_request_approval_2',
                      namedArgs: {
                        'price': '${CurrencyEnum.turkishLira.symbol}$price',
                        'unit': '$_demandedUnit',
                        'symbol': '<bold>${widget.ipo.symbol!}</bold>',
                        'paymentType': L10n.tr(_selectedPaymentTypeName).toLowerCase(),
                        'participation_ipo':
                            '<orange>${L10n.tr('participation_ipo').toUpperCase()}</participation_ipo>',
                      },
                    )
                  : L10n.tr(
                      'ipo_request_approval_amount',
                      namedArgs: {
                        'price':
                            '${CurrencyEnum.turkishLira.symbol}${widget.ipoDetail.endPrice != null ? _slidingSegmentedIndex == 0 ? _askingPriceUnitTC.text : _askingPriceAmountTC.text : _amountTC.text}',
                        'symbol': '<bold>${widget.ipo.symbol!}</bold>',
                        'paymentType': L10n.tr(_selectedPaymentTypeName).toLowerCase(),
                        'participation_ipo':
                            '<orange>${L10n.tr('participation_ipo').toUpperCase()}</participation_ipo>',
                      },
                    ),
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg16textPrimary,
              tags: {
                'bold': StyledTextTag(
                  style: context.pAppStyle.labelReg16textPrimary.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                'orange': StyledTextTag(
                  style: context.pAppStyle.labelMed16primary,
                ),
              },
            ),
            const SizedBox(
              height: Grid.m,
            ),
            InkWell(
              onTap: () {
                PBottomSheet.show(
                  context,
                  title: L10n.tr('demand_detail'),
                  child: Column(
                    children: [
                      DemandDetailRow(
                        title: L10n.tr('symbol'),
                        value: approveModel.symbolName,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('islem_turu'),
                        value: L10n.tr('participation_ipo'),
                        textStyle: context.pAppStyle.labelReg16primary,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('fiyat'),
                        value: approveModel.price,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('adet'),
                        value: approveModel.demandedLot,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('tutar'),
                        value: approveModel.amount,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('payment_type'),
                        value: approveModel.paymentType,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('hesap'),
                        value: approveModel.account,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('order_date'),
                        value: DateTime.now().formatDayMonthYearTimeWithComma(),
                        hasDivider: false,
                      ),
                      _cancelOkButton(
                        onTapOK: () {
                          getIt<Analytics>().track(
                            AnalyticsEvents.halkaArzTalebiSuccess,
                            taxonomy: [
                              InsiderEventEnum.controlPanel.value,
                              InsiderEventEnum.marketsPage.value,
                              InsiderEventEnum.ipoTab.value,
                            ],
                          );

                          String price = '${widget.ipoDetail.startPrice ?? 0}';

                          if (widget.ipoDetail.endPrice != null) {
                            if (_slidingSegmentedIndex == 0) {
                              price = _askingPriceUnitTC.text;
                            } else {
                              price = _askingPriceAmountTC.text;
                            }
                          }

                          if (widget.ipo.symbol!.toUpperCase().contains('.HE')) {
                            _ipoBloc.add(
                              NewOrderHEEvent(
                                orderActionType: 'CREDIT',
                                symbolName: addDataModel.symbol,
                                quantity: addDataModel.demandedUnit.toString(),
                                price: price,
                                orderType: 'LOT',
                                orderValidity: '1',
                                orderCompletionType: '1',
                                account: addDataModel.accountId,
                                callback: () {
                                  router.push(
                                    InfoRoute(
                                      variant: InfoVariant.success,
                                      message: L10n.tr('order_success'),
                                      buttonText: L10n.tr('emirlerime_don'),
                                      onTapButton: () {
                                        router.popUntilRoot();
                                        _tabBloc.add(
                                          const TabChangedEvent(
                                            tabIndex: 1,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                  router.maybePop();
                                },
                              ),
                            );
                            return;
                          }

                          _ipoBloc.add(
                            DemandAddEvent(
                              customerId: addDataModel.customerId,
                              accountId: addDataModel.accountId,
                              functionName: 0, // 0(Add)
                              demandDate: DateTime.now().formatToJson(),
                              ipoId: addDataModel.ipoId,
                              unitsDemanded: addDataModel.unitsDemanded,
                              paymentType: addDataModel.paymentType, // 0(Nakit)
                              transactionType: addDataModel.transactionType,
                              investorTypeId:
                                  UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
                              demandGatheringType: addDataModel.demandGatheringType,
                              totalAmount: addDataModel.totalAmount,
                              itemsToBlock: _isPaymentTypeBlockage ? addDataModel.itemsToBlock! : [],
                              offerPrice: addDataModel.offerPrice,
                              minUnits: addDataModel.minUnits,
                              customFields: addDataModel.customFields,
                              callback: () async {
                                widget.onSuccess();
                                _ipoBloc.add(
                                  GetActiveListEvent(
                                    pageNumber: 0,
                                  ),
                                );

                                router.popUntilRoot();
                                router.push(
                                  InfoRoute(
                                    variant: InfoVariant.success,
                                    message: L10n.tr('request_received_success'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
              child: Text(
                L10n.tr('see_request_detail'),
                style: context.pAppStyle.labelReg16primary,
              ),
            ),
            const SizedBox(
              height: Grid.m + Grid.xs,
            ),
            _cancelOkButton(
              onTapOK: () {
                getIt<Analytics>().track(
                  AnalyticsEvents.halkaArzTalebiSuccess,
                  taxonomy: [
                    InsiderEventEnum.controlPanel.value,
                    InsiderEventEnum.marketsPage.value,
                    InsiderEventEnum.ipoTab.value,
                  ],
                );

                if (widget.ipo.symbol!.toUpperCase().contains('.HE')) {
                  _ipoBloc.add(
                    NewOrderHEEvent(
                      orderActionType: 'CREDIT',
                      symbolName: addDataModel.symbol,
                      quantity: addDataModel.demandedUnit.toString(),
                      price: '${widget.ipoDetail.startPrice ?? 0}',
                      orderType: 'LOT',
                      orderValidity: '1',
                      orderCompletionType: '1',
                      account: addDataModel.accountId,
                      callback: () {
                        router.push(
                          InfoRoute(
                            variant: InfoVariant.success,
                            message: L10n.tr('order_success'),
                            buttonText: L10n.tr('emirlerime_don'),
                            onTapButton: () {
                              router.popUntilRoot();
                              _tabBloc.add(
                                const TabChangedEvent(
                                  tabIndex: 1,
                                ),
                              );
                            },
                          ),
                        );
                        router.maybePop();
                      },
                    ),
                  );
                  return;
                }

                _ipoBloc.add(
                  DemandAddEvent(
                    customerId: addDataModel.customerId,
                    accountId: addDataModel.accountId,
                    functionName: 0, // 0(Add)
                    demandDate: DateTime.now().formatToJson(),
                    ipoId: addDataModel.ipoId,
                    unitsDemanded: addDataModel.unitsDemanded,
                    paymentType: addDataModel.paymentType, // 0(Nakit)
                    transactionType: addDataModel.transactionType,
                    investorTypeId: UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
                    demandGatheringType: addDataModel.demandGatheringType,
                    totalAmount: addDataModel.totalAmount,
                    itemsToBlock: _isPaymentTypeBlockage ? addDataModel.itemsToBlock! : [],
                    offerPrice: addDataModel.offerPrice,
                    minUnits: addDataModel.minUnits,
                    customFields: addDataModel.customFields,
                    callback: () async {
                      widget.onSuccess();
                      _ipoBloc.add(
                        GetActiveListEvent(
                          pageNumber: 0,
                        ),
                      );
                      router.popUntilRoot();
                      router.push(
                        InfoRoute(
                          variant: InfoVariant.success,
                          message: L10n.tr('ipo.demand.order_join_success'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void _applyBlockage() {
    IpoApproveDataModel approveModel = IpoApproveDataModel(
      symbolName: widget.ipoDetail.symbol ?? '',
      price: _ipoPrice != 0
          ? '₺${MoneyUtils().readableMoney(
              _ipoPrice,
            )}'
          : '₺${_slidingSegmentedIndex == 0 ? _askingPriceUnitTC.text : _askingPriceAmountTC.text}',
      demandedLot: _demandedUnit.toString(),
      amount: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
      paymentType: _selectedPaymentTypeName.isNotEmpty
          ? L10n.tr(_selectedPaymentTypeName)
          : _paymentTypeDropdownList[0]['title'],
      applicationType: _selectedApplicationTypeTitle,
      ipoRequestedMinUnit: _demandedMinUnit.toInt().toString(),
      kktcCitizen: IpoConstant().ipoKktcCitizenDropdownList[_selectedKktcCitizenId]['title'],
      account: _selectedAccount,
    );

    PBottomSheet.show(
      context,
      title: L10n.tr('request_approval'),
      child: Column(
        children: [
          StyledText(
            text: L10n.tr(
              'ipo_blockage_request_approval',
              namedArgs: {
                'price': '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
                'unit': '${_blockageData.demandedUnit}',
                'symbol': '<bold>${_blockageData.symbol}</bold>',
                'paymentType': L10n.tr(_selectedPaymentTypeName),
                'participation_ipo': '<orange>${L10n.tr('participation_ipo').toUpperCase()}</participation_ipo>',
              },
            ),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg16textPrimary,
            tags: {
              'bold': StyledTextTag(
                style: context.pAppStyle.labelReg16textPrimary.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              'orange': StyledTextTag(
                style: context.pAppStyle.labelMed16primary,
              ),
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
          InkWell(
            onTap: () {
              PBottomSheet.show(context,
                  title: L10n.tr('demand_detail'),
                  child: Column(
                    children: [
                      DemandDetailRow(
                        title: L10n.tr('symbol'),
                        value: approveModel.symbolName,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('islem_turu'),
                        value: L10n.tr('participation_ipo'),
                        textStyle: context.pAppStyle.labelReg16primary,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('fiyat'),
                        value: approveModel.price,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('adet'),
                        value: approveModel.demandedLot,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('tutar'),
                        value: approveModel.amount,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('payment_type'),
                        value: L10n.tr(approveModel.paymentType),
                      ),
                      DemandDetailRow(
                        title: L10n.tr('hesap'),
                        value: approveModel.account,
                      ),
                      DemandDetailRow(
                        title: L10n.tr('order_date'),
                        value: DateTime.now().formatDayMonthYearTimeWithComma(),
                        hasDivider: false,
                      ),
                      _cancelOkButton(
                        onTapOK: () async {
                          getIt<IpoBloc>().add(
                            DemandAddEvent(
                              customerId: _blockageData.customerId,
                              accountId: _blockageData.accountId,
                              functionName: 0, // 0(Add)
                              demandDate: DateTime.now().formatToJson(),
                              ipoId: _blockageData.ipoId,
                              unitsDemanded: _blockageData.unitsDemanded,
                              paymentType: _blockageData.paymentType, // 0(Nakit)
                              transactionType: _blockageData.transactionType,
                              investorTypeId:
                                  UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
                              demandGatheringType: _blockageData.demandGatheringType,
                              totalAmount: _blockageData.totalAmount,
                              itemsToBlock: _blockageData.itemsToBlock!,
                              offerPrice: _blockageData.offerPrice,
                              minUnits: _blockageData.minUnits,
                              customFields: _blockageData.customFields,
                              callback: () async {
                                getIt<IpoBloc>().add(
                                  GetActiveListEvent(
                                    pageNumber: 0,
                                  ),
                                );
                                router.popUntilRoot();
                                router.push(
                                  InfoRoute(
                                    variant: InfoVariant.success,
                                    message: L10n.tr('ipo.demand.order_join_success'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ));
            },
            child: Text(
              L10n.tr('see_request_detail'),
              style: context.pAppStyle.labelReg16primary,
            ),
          ),
          const SizedBox(
            height: Grid.m + Grid.xs,
          ),
          _cancelOkButton(onTapOK: () async {
            getIt<IpoBloc>().add(
              DemandAddEvent(
                customerId: _blockageData.customerId,
                accountId: _blockageData.accountId,
                functionName: 0, // 0(Add)
                demandDate: DateTime.now().formatToJson(),
                ipoId: _blockageData.ipoId,
                unitsDemanded: _blockageData.unitsDemanded,
                paymentType: _blockageData.paymentType, // 0(Nakit)
                transactionType: _blockageData.transactionType,
                investorTypeId: UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT',
                demandGatheringType: _blockageData.demandGatheringType,
                totalAmount: _blockageData.totalAmount,
                itemsToBlock: _blockageData.itemsToBlock!,
                offerPrice: _blockageData.offerPrice,
                minUnits: _blockageData.minUnits,
                customFields: _blockageData.customFields,
                callback: () async {
                  getIt<IpoBloc>().add(
                    GetActiveListEvent(
                      pageNumber: 0,
                    ),
                  );

                  router.popUntilRoot();

                  router.push(
                    InfoRoute(
                      variant: InfoVariant.success,
                      message: L10n.tr('ipo.demand.order_join_success'),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _cancelOkButton({VoidCallback? onTapOK}) {
    return Row(
      children: [
        Expanded(
          child: POutlinedButton(
            text: L10n.tr('vazgec'),
            onPressed: () => router.maybePop(),
          ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Expanded(
          child: PButton(
            text: L10n.tr('onayla'),
            onPressed: onTapOK,
          ),
        )
      ],
    );
  }

  bool _demandIpo(
    bool isAggrementAccepted,
    double unit,
    double price, {
    Function({
      double? unit,
      double? price,
    })? callback,
  }) {
    if (!isAggrementAccepted && !widget.ipo.symbol!.toUpperCase().contains('.HE')) {
      PBottomSheet.showError(
        context,
        content: L10n.tr('ipo_check_aggrement_alert'),
      );

      return false;
    }

    if (unit <= 0 && _slidingSegmentedIndex == 0) {
      PBottomSheet.show(
        context,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                child: SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Text(
                L10n.tr('please_enter_unit'),
              ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
          ),
        ),
      );

      callback?.call(unit: 0);
      return false;
    }
    if (price <= 0 && _slidingSegmentedIndex == 1) {
      PBottomSheet.show(
        context,
        child: Column(
          children: [
            SvgPicture.asset(
              ImagesPath.alert_circle,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr('lutfen_tutar_giriniz'),
            ),
            const SizedBox(
              height: Grid.m,
            ),
          ],
        ),
      );
      callback?.call(price: 0);
      return false;
    }
    return true;
  }

  Widget _tradeLimitWidget() {
    return PBlocBuilder<IpoBloc, IpoState>(
      bloc: _ipoBloc,
      builder: (context, state) {
        double tradeLimit = 0.0;

        if (state.ipoTradeLimitModel != null) {
          tradeLimit = state.ipoTradeLimitModel?.tradeLimit ?? 0;
        }

        return Shimmerize(
          enabled: state.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${L10n.tr('islem_limiti')}:',
                textAlign: TextAlign.right,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              const SizedBox(
                height: Grid.xxs,
              ),
              Text(
                '₺${MoneyUtils().readableMoney(tradeLimit)}',
                textAlign: TextAlign.right,
                style: context.pAppStyle.labelMed14textPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}
