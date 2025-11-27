import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:readmore/readmore.dart';

class TransactionTypeCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool hasDivider;
  const TransactionTypeCard({
    super.key,
    required this.data,
    this.hasDivider = true,
  });

  @override
  State<TransactionTypeCard> createState() => _TransactionTypeCardState();
}

class _TransactionTypeCardState extends State<TransactionTypeCard> {
  String _headerLeft = '';
  String _headerRight = '';
  String _middleLeft = '';
  String _middleRight = '';
  String _middleRightBottom = '';
  String _bottomLeft = '';
  String _bottomRight = '';
  late int _sideType;

  @override
  initState() {
    _sideType = widget.data['sideType'] ?? 1;

    if (widget.data['list_type'] == TransactionMainTypeEnum.equity.responseListType) {
      _equityCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.viop.responseListType) {
      _viopCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.fund.responseListType) {
      _fundCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.eurobond.responseListType) {
      _eurobondCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.cash.responseListType) {
      _cashCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.ipo.responseListType) {
      _ipoCard();
    } else if (widget.data['list_type'] == TransactionMainTypeEnum.foreignCurrency.responseListType) {
      _foreignCurrencyCard();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Grid.s,
          children: [
            Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _headerLeft,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    if (widget.data['list_type'] != TransactionMainTypeEnum.cash.responseListType &&
                        widget.data['list_type'] != TransactionMainTypeEnum.foreignCurrency.responseListType) ...[
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Grid.xs,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 4,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: _sideType == 1 ? L10n.tr('alis').toUpperCase() : L10n.tr('satis').toUpperCase(),
                        style: context.pAppStyle.interRegularBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: _sideType == 1 ? context.pColorScheme.success : context.pColorScheme.critical,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                _headerRight,
                textAlign: TextAlign.right,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: Grid.xxs,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ReadMoreText(
                _middleLeft,
                trimLines: 2,
                style: context.pAppStyle.labelReg12textSecondary,
                colorClickableText: context.pColorScheme.primary,
                trimMode: TrimMode.Line,
                trimCollapsedText: L10n.tr('show_more'),
                trimExpandedText: L10n.tr('show_less'),
                moreStyle: const TextStyle(
                  fontSize: Grid.m,
                  fontStyle: FontStyle.italic,
                ),
                lessStyle: const TextStyle(
                  fontSize: Grid.s + Grid.xs,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                !_middleRight.contains('/')
                    ? Text(
                        _middleRight,
                        textAlign: TextAlign.right,
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.s + Grid.xs,
                          color: _transactionControl(_sideType),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _middleRight.split('/')[0],
                              style: context.pAppStyle.interMediumBase.copyWith(
                                fontSize: Grid.s + Grid.xs,
                                color: _transactionControl(_sideType),
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Grid.xs,
                                ),
                                child: Icon(
                                  Icons.circle,
                                  size: 4,
                                  color: _transactionControl(_sideType),
                                ),
                              ),
                            ),
                            TextSpan(
                                text: _middleRight.split('/')[1],
                                style: context.pAppStyle.interMediumBase.copyWith(
                                  fontSize: Grid.s + Grid.xs,
                                  color: _transactionControl(_sideType),
                                )),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${L10n.tr('hesap_numarasi')}: $_bottomLeft',
              style: context.pAppStyle.labelReg12textSecondary,
              textAlign: TextAlign.start,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _middleRightBottom,
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.s + Grid.xxs / 2 + Grid.xxs,
                    color: context.pColorScheme.textTeritary,
                  ),
                ),
                const SizedBox(
                  height: Grid.xxs / 2,
                ),
                Text(
                  _bottomRight,
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelReg12textSecondary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        if (widget.hasDivider) const PDivider(),
      ],
    );
  }

  _equityCard() {
    // FILL_AMOUNT Kontrolü nün amacı emir işlem daha gerçekleşmediği için. Biz sadece gerçekleşenleri gösteriyoruz.

    String transactionAmount = '';
    String shortSelling = '';

    if (widget.data['shortFall'] != null && widget.data['shortFall']) {
      shortSelling = L10n.tr('short_selling');
    }

    transactionAmount = widget.data['orderStatus'] == 'FILLED'
        ? MoneyUtils().readableMoney(widget.data['transactionAmount'])
        : MoneyUtils().readableMoney(widget.data['orderAmount']);

    _headerLeft = widget.data['symbol'] ?? '';
    _headerRight = L10n.tr('${widget.data['orderStatus']}');
    _middleLeft = '${L10n.tr('bist_equity')} $shortSelling';
    _middleRight =
        '${((widget.data['orderStatus'] == 'FILLED' ? widget.data['realizedUnit'] : widget.data['orderUnit']) as double).toInt()} ${L10n.tr('adet')}/${CurrencyEnum.turkishLira.symbol}$transactionAmount';

    _middleRightBottom = 'REF: ${widget.data['transactionExtId'] ?? ''}';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';
    _bottomRight = DateTimeUtils.dateFormatAndTime(
      DateTime.parse(
        widget.data['orderDate'].toString(),
      ).toLocal(),
    );
    setState(() {});
  }

  _viopCard() {
    // if (widget.data.containsKey('realizedUnit') && widget.data['realizedUnit'] <= 0) return const SizedBox.shrink();

    String transactionPrice = '';

    if (widget.data['transactionPrice'] != null) {
      transactionPrice =
          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.data['transactionPrice'])}';
    }

    _headerLeft = 'VIOP';
    _headerRight = L10n.tr('${widget.data['orderStatus']}');
    _middleLeft = '${widget.data['symbol'] ?? ''} ${widget.data['shortLong'] ?? ''}';
    _middleRight = '${(widget.data['realizedUnit'] as double).toInt()} ${L10n.tr('adet')}/$transactionPrice';
    _middleRightBottom = 'REF: ${widget.data['transactionExtId'] ?? ''}';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';
    _bottomRight = DateTimeUtils.dateFormatAndTime(
      DateTime.parse(
        widget.data['orderDate'].toString(),
      ).toLocal(),
    );
    setState(() {});
  }

  _fundCard() {
    // if (widget.data.containsKey('orderAmount') && widget.data['orderAmount'] <= 0) return const SizedBox.shrink();
    String orderAmount = '';

    if (widget.data['orderAmount'] != null) {
      orderAmount = '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.data['orderAmount'])}';
    }

    _headerLeft = L10n.tr('fund');
    _headerRight = L10n.tr('${widget.data['orderStatus']}');
    _middleLeft = '${widget.data['symbol'] ?? ''}';
    _middleRight = '${(widget.data['orderUnit'] as double).toInt()} ${L10n.tr('adet')}/$orderAmount';
    _middleRightBottom = 'REF: ${widget.data['transactionExtId'] ?? ''}';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';

    _bottomRight = widget.data['orderDate'] == null
        ? ''
        : DateTimeUtils.dateFormatAndTime(
            DateTime.parse(
              widget.data['orderDate'].toString(),
            ).toLocal(),
          );
    setState(() {});
  }

  _eurobondCard() {
    // if (widget.data.containsKey('amount') && widget.data['amount'] <= 0) return const SizedBox.shrink();

    String amount = '';
    String transactionId = widget.data['transactionId'].toString().substring(5, 10);

    if (widget.data['amount'] != null) {
      amount = '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.data['amount'])}';
    }

    _sideType = widget.data['sideType'] ?? 1;

    _headerLeft = L10n.tr('sgmk');
    _headerRight = L10n.tr('${widget.data['Status'] ?? ''}');
    _middleLeft = '${widget.data['asset'] ?? ''}';
    _middleRight = '${(widget.data['units'] as double).toInt()} ${L10n.tr('adet')}/$amount';
    _middleRightBottom = 'REF: $transactionId';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';

    _bottomRight = DateTimeUtils.dateFormatAndTime(
      DateTime.parse(
        widget.data['created'].toString(),
      ).toLocal(),
    );
    setState(() {});
  }

  _cashCard() {
    // status = I => İşlem, T => Talep, S => İptal
    _sideType = widget.data['sideType'] ?? 1;
    _headerLeft = L10n.tr(widget.data['transactionType']);
    _headerRight = L10n.tr(widget.data['status']);
    _middleLeft = '${widget.data['description'] ?? ''}';
    if (widget.data['amount'] != null) {
      _middleRight =
          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney((widget.data['amount'] as double))}';
    }

    _middleRightBottom = 'REF: ${widget.data['transactionExtId'] ?? ''}';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';
    _bottomRight = DateTimeUtils.dateFormatAndTime(
      DateTime.parse(
        widget.data['orderDate'],
      ).toLocal(),
    );
    setState(() {});
  }

  _ipoCard() {
    DateTime time = DateTimeUtils.fromString(widget.data['orderDate'].toString());
    int orderUnit = double.parse(widget.data['orderUnit'].toString()).toInt();

    _headerLeft = L10n.tr('halka_arz');
    _headerRight = '';
    _middleLeft = '${widget.data['symbol'] ?? ''}';
    _middleRight =
        ' $orderUnit ${L10n.tr('adet')}/${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(double.parse(widget.data['orderAmount'].toString()))}';
    _middleRightBottom = '';
    _bottomLeft = '${widget.data['customerExtId'] ?? ''}-${widget.data['accountExtId'] ?? ''}';
    _bottomRight = DateTimeUtils.dateFormatAndTime(time);
    setState(() {});
  }

  _foreignCurrencyCard() {
    DateTime time = DateTimeUtils.fromString(widget.data['created'].toString());

    _sideType = widget.data['debitCredit'] == 'CREDIT' ? 1 : 2;
    String description = widget.data['description'] ?? '';

    String headerLeft = '';

    if (description.contains('Gönderen Hesap : 300767-905') || description.contains('Gönderen Hesap : 300767-900')) {
      headerLeft = L10n.tr('us_balance_withdrawal');
    } else if (description.contains('Alan Hesap : 300767-905') || description.contains('Alan Hesap : 300767-900')) {
      headerLeft = L10n.tr('us_balance_deposit');
    } else {
      headerLeft = widget.data['finInstName'] ?? '';
    }

    _headerLeft = headerLeft;
    _headerRight = L10n.tr(widget.data['status'] ?? '');

    _middleLeft = L10n.tr(TransactionMainTypeEnum.foreignCurrency.name);

    _middleRight =
        '${widget.data['amount'] ?? ''} ${widget.data['finInstName'] ?? ''}/${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.data['lcAmount'] ?? 0)}';
    _middleRightBottom = 'REF: ${widget.data['transactionExtId'] ?? ''}';
    _bottomLeft = widget.data['accountExtId'] ?? '';
    _bottomRight = DateTimeUtils.dateFormatAndTime(time);
    setState(() {});
  }

  Color _transactionControl(int sideType) {
    if (sideType == 1) return context.pColorScheme.success;

    return context.pColorScheme.critical;
  }
}
