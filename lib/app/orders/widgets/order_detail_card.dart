import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_add_chain_widget.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_list_tile.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderDetailCard extends StatefulWidget {
  final TransactionModel selectedOrder;
  final bool isInUpdate;
  final Function(double)? selectedPrice;
  final OrderStatusEnum orderStatus;
  const OrderDetailCard({
    super.key,
    required this.selectedOrder,
    required this.isInUpdate,
    this.selectedPrice,
    required this.orderStatus,
  });

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  late OrdersBloc _ordersBloc;
  late FundBloc _fundBloc;

  final ValueNotifier<(String, String)> _nameNotifier = ValueNotifier<(String, String)>(
    ('', ''),
  );
  final ValueNotifier<DateTime?> _periodEndDateNotifier = ValueNotifier<DateTime?>(null);
  String _symbolName = '';

  @override
  initState() {
    _ordersBloc = getIt<OrdersBloc>();
    _fundBloc = getIt<FundBloc>();

    _handleSymbolName();

    if (widget.orderStatus == OrderStatusEnum.pending && widget.selectedOrder.transactionExtId?.isNotEmpty == true) {
      _ordersBloc.add(
        GetPeriodicOrdersEvent(
          accountId: widget.selectedOrder.accountExtId ?? '',
          transactionExidId: widget.selectedOrder.transactionExtId!,
          successCallback: (periodEndDate) {
            _periodEndDateNotifier.value = periodEndDate;
          },
        ),
      );
    }

    if (widget.selectedOrder.symbolType?.name == SymbolTypeEnum.mfList.name) {
      _fundBloc.add(
        GetDetailEvent(
          fundCode: widget.selectedOrder.symbol ?? '',
          callBack: (detail) {
            _nameNotifier.value = (
              detail.subType,
              detail.founder,
            );
          },
        ),
      );
    }

    super.initState();
  }

  void _handleSymbolName() async {
    _symbolName = widget.selectedOrder.symbol ?? widget.selectedOrder.asset ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  dispose() {
    _nameNotifier.dispose();
    _periodEndDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTakeProfitStopLoss = widget.selectedOrder.slPrice != null &&
        widget.selectedOrder.slPrice != 0 &&
        widget.selectedOrder.tpPrice != null &&
        widget.selectedOrder.tpPrice != 0;

    bool isConditionOrder = widget.selectedOrder.conditionSymbol != null;

    bool isViopOrder = widget.selectedOrder.symbolType?.name == SymbolTypeEnum.viopList.name;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: context.pColorScheme.transparent,
      margin: const EdgeInsets.symmetric(
        horizontal: Grid.m,
        vertical: Grid.l - Grid.xs,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rowWidget(
              context,
              L10n.tr('durum'),
              widget.selectedOrder.orderStatus == 'null'
                  ? '-'
                  : L10n.tr(widget.selectedOrder.orderStatus ?? widget.selectedOrder.status ?? ''),
              valueColor: context.pColorScheme.primary,
            ),
            _rowWidget(
              context,
              L10n.tr('symbol'),
              _symbolName,
              widget: InkWell(
                onTap: () {
                  if (widget.selectedOrder.symbolType?.name == SymbolTypeEnum.mfList.name) {
                    router.push(
                      FundDetailRoute(
                        fundCode: widget.selectedOrder.symbol ?? '',
                      ),
                    );

                    return;
                  }

                  MarketListModel selectedItem = MarketListModel(
                    symbolCode: _symbolName,
                    updateDate: '',
                  );

                  router.push(
                    SymbolDetailRoute(
                      symbol: selectedItem,
                      ignoreDispose: true,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      ImagesPath.arrow_up_right,
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    Text(
                      _symbolName,
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            ///Islem Turu
            if (widget.selectedOrder.symbol != null && widget.selectedOrder.equityGroupCode == 'HE') ...[
              _rowWidget(
                context,
                L10n.tr('islem_turu'),
                L10n.tr('participation_ipo'),
                valueColor: context.pColorScheme.primary,
              ),
              _rowWidget(
                context,
                L10n.tr('ipo_price'),
                '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.selectedOrder.orderPrice ?? 0)}',
              ),
            ] else ...[
              _rowWidget(
                context,
                L10n.tr('islem_turu'),
                widget.selectedOrder.sideType == 1
                    ? widget.selectedOrder.conditionSymbol == null
                        ? L10n.tr('alis')
                        : L10n.tr('condition_buying').toUpperCase()
                    : widget.selectedOrder.conditionSymbol == null
                        ? L10n.tr('satis')
                        : L10n.tr('condition_selling').toUpperCase(),
                valueColor:
                    (widget.selectedOrder.sideType == 1) ? context.pColorScheme.success : context.pColorScheme.critical,
              ),
            ],
            if (widget.selectedOrder.symbolType?.name == SymbolTypeEnum.mfList.name) ...[
              PBlocBuilder<FundBloc, FundState>(
                bloc: _fundBloc,
                builder: (context, state) {
                  return _rowWidget(
                    context,
                    L10n.tr('fund_name'),
                    '',
                    widget: ValueListenableBuilder<(String, String)>(
                      valueListenable: _nameNotifier,
                      builder: (context, value, child) => RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          style: context.pAppStyle.labelReg14textPrimary,
                          children: [
                            TextSpan(
                              text: _capitalizeEachWord(
                                value.$1,
                              ),
                            ),
                            TextSpan(
                              text: ' • ',
                              style: context.pAppStyle.labelReg12textPrimary,
                            ),
                            TextSpan(
                              text: _capitalizeEachWord(
                                value.$2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                '${(widget.selectedOrder.orderUnit ?? 0).toInt()}',
              ),
              _rowWidget(
                context,
                L10n.tr('fiyat'),
                '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                  widget.selectedOrder.orderPrice ?? widget.selectedOrder.price ?? 0,
                  pattern: '#,##0.######',
                )}',
              ),
              _rowWidget(
                context,
                L10n.tr('tutar'),
                '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                  (widget.selectedOrder.orderUnit ?? 0) * (widget.selectedOrder.orderPrice ?? 0),
                  pattern: '#,##0.######',
                )}',
              ),
              _rowWidget(
                context,
                L10n.tr('fund_valor_date'),
                widget.selectedOrder.valueDate?.isNotEmpty == true
                    ? DateTimeUtils.dateFormat(DateTime.parse(widget.selectedOrder.valueDate!).toLocal())
                    : '-',
              ),
            ],
            if (widget.selectedOrder.symbolType != SymbolTypeEnum.mfList &&
                widget.selectedOrder.symbolType != SymbolTypeEnum.fincList)
              if (widget.selectedOrder.equityGroupCode != 'HE')
                _rowWidget(
                  context,
                  L10n.tr('emir_tipi'),
                  L10n.tr(OrderTypeEnum.values
                          .firstWhereOrNull(
                            (element) => element.value == widget.selectedOrder.transactionType,
                          )
                          ?.name ??
                      '-'),
                ),
            if (widget.selectedOrder.symbolType == SymbolTypeEnum.fincList) ...[
              _rowWidget(
                context,
                L10n.tr('clean_price'),
                '${MoneyUtils().readableMoney(widget.selectedOrder.price ?? 0)} USD',
              ),
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                MoneyUtils().readableMoney(widget.selectedOrder.units ?? 0),
              ),
              _rowWidget(
                context,
                L10n.tr('tutar'),
                '${MoneyUtils().readableMoney(widget.selectedOrder.amount ?? 0)} USD',
              ),
            ],
            if (widget.selectedOrder.transactionType == OrderTypeEnum.market.value) ...[
              if (widget.orderStatus != OrderStatusEnum.filled)
                _rowWidget(
                  context,
                  L10n.tr('fiyat'),
                  L10n.tr('serbest'),
                ),
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                '${widget.selectedOrder.orderUnit?.toInt() ?? 0}',
              ),
              if (widget.orderStatus == OrderStatusEnum.filled) ...[
                _rowWidget(
                  context,
                  L10n.tr('gerceklesen_adet'),
                  '${widget.selectedOrder.realizedUnit?.toInt() ?? 0}',
                ),
                _rowWidget(
                  context,
                  L10n.tr('realization_price'),
                  (widget.selectedOrder.transactionPrice == null || widget.selectedOrder.transactionPrice == 0) &&
                          (widget.selectedOrder.price == null || widget.selectedOrder.price == 0)
                      ? '-'
                      : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                          widget.selectedOrder.transactionPrice ?? widget.selectedOrder.price ?? 0,
                          pattern: widget.selectedOrder.decimalCount == 0
                              ? '#,##0'
                              : '#,##0.${'0' * (widget.selectedOrder.decimalCount ?? 2)}',
                        )}',
                ),
                _rowWidget(
                  context,
                  L10n.tr('tutar'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    (widget.selectedOrder.transactionPrice ?? 0) * (widget.selectedOrder.realizedUnit ?? 0),
                  )}',
                ),
              ],
            ] else if (widget.selectedOrder.transactionType == OrderTypeEnum.limit.value) ...[
              if (widget.selectedOrder.equityGroupCode != 'HE')
                _rowWidget(
                  context,
                  L10n.tr('limit_price'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.selectedOrder.orderPrice ?? 0)}',
                ),
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                '${widget.selectedOrder.orderUnit?.toInt() ?? 0}',
              ),
              if (widget.orderStatus == OrderStatusEnum.filled)
                _rowWidget(
                  context,
                  L10n.tr('gerceklesen_adet'),
                  isConditionOrder
                      ? '${widget.selectedOrder.orderUnit?.toInt() ?? 0}'
                      : '${widget.selectedOrder.realizedUnit?.toInt() ?? 0}',
                ),
              if (widget.selectedOrder.equityGroupCode != 'HE' && widget.selectedOrder.orderStatus == 'PARTIALLYFILLED')
                _rowWidget(
                  context,
                  L10n.tr('gerceklesen_adet'),
                  '${widget.selectedOrder.realizedUnit?.round() ?? widget.selectedOrder.units?.round() ?? 0}',
                ),
              if (widget.orderStatus != OrderStatusEnum.canceled)
                _rowWidget(
                  context,
                  widget.orderStatus == OrderStatusEnum.pending ? L10n.tr('tutar') : L10n.tr('realization_price'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    widget.selectedOrder.equityGroupCode == 'HE'
                        ? ((widget.selectedOrder.orderPrice ?? widget.selectedOrder.price ?? 0) *
                            (widget.selectedOrder.orderUnit ?? 1))
                        : isConditionOrder || widget.selectedOrder.tpPrice != null || isViopOrder
                            ? widget.selectedOrder.amount != null && widget.selectedOrder.amount != 0
                                ? widget.selectedOrder.amount!
                                : (widget.selectedOrder.orderPrice ?? 0) * (widget.selectedOrder.orderUnit ?? 0)
                            : widget.selectedOrder.transactionPrice ?? 0,
                    pattern: widget.selectedOrder.decimalCount == 0
                        ? '#,##0'
                        : '#,##0.${'0' * (widget.selectedOrder.decimalCount ?? 2)}',
                  )}',
                ),
              if (widget.orderStatus == OrderStatusEnum.filled || widget.selectedOrder.orderStatus == 'PARTIALLYFILLED')
                _rowWidget(
                  context,
                  L10n.tr('tutar'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    isConditionOrder
                        ? (widget.selectedOrder.orderPrice ?? 0) * (widget.selectedOrder.orderUnit ?? 0)
                        : (widget.selectedOrder.transactionPrice ?? 0) * (widget.selectedOrder.realizedUnit ?? 0),
                  )}',
                ),
            ] else if (widget.selectedOrder.transactionType == OrderTypeEnum.marketToLimit.value) ...[
              _rowWidget(
                context,
                L10n.tr('fiyat'),
                L10n.tr('serbest'),
              ),
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                '${widget.selectedOrder.orderUnit?.toInt() ?? 0}',
              ),
              if (widget.orderStatus == OrderStatusEnum.filled) ...[
                _rowWidget(
                  context,
                  L10n.tr('gerceklesen_adet'),
                  '${widget.selectedOrder.realizedUnit?.toInt() ?? 0}',
                ),
                _rowWidget(
                  context,
                  L10n.tr('realization_price'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    widget.selectedOrder.transactionPrice ?? 0,
                  )}',
                ),
                _rowWidget(
                  context,
                  L10n.tr('tutar'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    (widget.selectedOrder.transactionPrice ?? 0) * (widget.selectedOrder.realizedUnit ?? 0),
                  )}',
                ),
              ],
            ] else if (widget.selectedOrder.transactionType == OrderTypeEnum.reserve.value) ...[
              _rowWidget(
                context,
                L10n.tr('quantity_of_entries'),
                '${widget.selectedOrder.orderUnit?.toInt() ?? 0}',
              ),
              if (widget.orderStatus == OrderStatusEnum.filled) ...[
                _rowWidget(
                  context,
                  L10n.tr('gerceklesen_adet'),
                  '${widget.selectedOrder.realizedUnit?.toInt() ?? 0}',
                ),
                _rowWidget(
                  context,
                  L10n.tr('tutar'),
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                    (widget.selectedOrder.transactionPrice ?? 0) * (widget.selectedOrder.realizedUnit ?? 0),
                  )}',
                ),
              ],
            ],
            if (isTakeProfitStopLoss) ...[
              _rowWidget(
                context,
                L10n.tr('kar_al'),
                MoneyUtils().readableMoney(
                  widget.selectedOrder.tpPrice ?? 0,
                ),
              ),
              _rowWidget(
                context,
                L10n.tr('zarar_durdur'),
                MoneyUtils().readableMoney(
                  widget.selectedOrder.slPrice ?? 0,
                ),
              ),
              ValueListenableBuilder<DateTime?>(
                valueListenable: _periodEndDateNotifier,
                builder: (BuildContext context, DateTime? periodEndDate, Widget? child) => _rowWidget(
                  context,
                  L10n.tr('gecerlilik_tarihi'),
                  periodEndDate == null ? '' : DateTimeUtils.dateFormat(periodEndDate),
                ),
              ),
            ],
            if (widget.selectedOrder.equityGroupCode != 'HE')
              _rowWidget(
                context,
                L10n.tr('validity_period'),
                L10n.tr(
                  OrderValidityEnum.values
                          .firstWhereOrNull(
                            (element) =>
                                element.value == double.parse(widget.selectedOrder.validity ?? '0').toStringAsFixed(0),
                          )
                          ?.name ??
                      '-',
                ),
              ),
            if (widget.selectedOrder.viopSession != null)
              _rowWidget(
                context,
                L10n.tr('viop_session'),
                L10n.tr(widget.selectedOrder.viopSession?.localizationKey ?? ''),
              ),

            if (widget.selectedOrder.endingMarketSessionDate != null)
              _rowWidget(
                context,
                L10n.tr('validity_date'),
                DateTimeUtils.dateFormat(
                    DateTime.parse(widget.selectedOrder.endingMarketSessionDate!.split('T').first)),
              ),
            if (isConditionOrder && widget.selectedOrder.conditionSymbol!.isNotEmpty) ...[
              _rowWidget(
                context,
                L10n.tr('sart_sembol'),
                widget.selectedOrder.conditionSymbol ?? '',
              ),
              _rowWidget(
                context,
                L10n.tr('sart_tipi_fiyat'),
                widget.selectedOrder.conditionType == '2' ? L10n.tr('greater_or_equal') : L10n.tr('less_or_equal'),
              ),
              _rowWidget(
                context,
                L10n.tr('Condition_Price'),
                '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                  widget.selectedOrder.conditionPrice!,
                )}',
              ),
            ],
            _rowWidget(
              context,
              L10n.tr('hesap'),
              '${widget.selectedOrder.customerExtId}-${widget.selectedOrder.accountExtId}',
            ),
            _rowWidget(
              context,
              widget.orderStatus == OrderStatusEnum.pending
                  ? L10n.tr('order_date')
                  : widget.orderStatus == OrderStatusEnum.filled
                      ? L10n.tr('date_of_realization')
                      : L10n.tr('cancel_date'),
              DateTime.parse(widget.selectedOrder.orderTime ??
                      widget.selectedOrder.created ??
                      widget.selectedOrder.orderDate ??
                      '')
                  .toLocal()
                  .formatDayMonthYearTimeWithComma(),
            ),
            _rowWidget(
              context,
              L10n.tr('reference_no'),
              widget.selectedOrder.transactionExtId ?? widget.selectedOrder.transactionId ?? '-',
            ),
            if (widget.orderStatus == OrderStatusEnum.pending)
              widget.selectedOrder.parentTransactionId != null ||
                      widget.selectedOrder.chainNo != 0 && widget.selectedOrder.chainNo != null
                  ? _seeChainDetailButton(context)
                  : widget.selectedOrder.symbolType == SymbolTypeEnum.mfList ||
                          widget.selectedOrder.symbol != null && widget.selectedOrder.equityGroupCode == 'HE' ||
                          isTakeProfitStopLoss ||
                          isConditionOrder ||
                          isViopOrder
                      ? const SizedBox.shrink()
                      : _addChainWidget(context),
          ],
        ),
      ),
    );
  }

  String _capitalizeEachWord(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word; // Boş stringleri koru
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' '); // Kelimeleri tekrar birleştir
  }

  Widget _seeChainDetailButton(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          OrderChainDetailsRoute(
            selectedOrder: widget.selectedOrder,
          ),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
            ImagesPath.link,
            width: 17,
            height: 17,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Text(
            L10n.tr('chain_order_details'),
            style: context.pAppStyle.labelReg16primary,
          ),
        ],
      ),
    );
  }

  Widget _addChainWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('zincir_ekle'),
          child: OrderDetailAddChainWidget(
            selectedOrder: widget.selectedOrder,
          ),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
            ImagesPath.plus,
            width: 17,
            height: 17,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          Text(
            L10n.tr('zincir_ekle'),
            style: context.pAppStyle.labelReg16primary,
          ),
        ],
      ),
    );
  }

  Widget _rowWidget(
    BuildContext context,
    String title,
    String value, {
    Color? valueColor,
    Widget? widget,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.pAppStyle.labelReg14textSecondary,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: widget ??
                  Text(
                    value,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m - Grid.xxs,
                      color: valueColor ?? context.pColorScheme.textPrimary,
                    ),
                  ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s + Grid.xs,
          ),
          child: PDivider(),
        ),
      ],
    );
  }

  Widget conditionWidget() {
    return Column(
      children: [
        const SizedBox(height: Grid.s),
        OrderDetailListTile(
          title: L10n.tr('Condition_Symbol'),
          text: widget.selectedOrder.conditionSymbol!,
        ),
        const SizedBox(height: Grid.s),
        OrderDetailListTile(
          title: L10n.tr('Condition_Type'),
          text: widget.selectedOrder.conditionType == '2' ? '>=' : '<=',
        ),
        const SizedBox(height: Grid.s),
        OrderDetailListTile(
          title: L10n.tr('Condition_Price'),
          text: '${MoneyUtils().readableMoney(widget.selectedOrder.conditionPrice!)} TL',
        ),
      ],
    );
  }
}
