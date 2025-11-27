import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_detail_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class IpoCompanyDetailWidget extends StatefulWidget {
  final IpoDetailModel ipo;
  const IpoCompanyDetailWidget({
    super.key,
    required this.ipo,
  });

  @override
  State<IpoCompanyDetailWidget> createState() => _IpoCompanyDetailWidgetState();
}

class _IpoCompanyDetailWidgetState extends State<IpoCompanyDetailWidget> {
  bool _isPastSuggestionsExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> companyDetailList = [
      if (widget.ipo.ipoTypeCapitalIncrease != null &&
          widget.ipo.ipoTypeStockholderSale != null &&
          widget.ipo.ipoTypeReference != null)
        {
          // Halka Arz Şekli
          'mainTitle': L10n.tr('hakkinda'),
          'subTitle': widget.ipo.companyDetailInfo ?? '',
          'referenceText': '',
        },
      {
        // Halka Arz Şekli
        'mainTitle': L10n.tr('ipo_type'),
        'subTitle':
            '${L10n.tr('ipo_type_capital_increase')} ${widget.ipo.ipoTypeCapitalIncrease ?? ''}${_getipoTypeStockholderSaleDesc()}',
        'referenceText': widget.ipo.ipoTypeReference ?? '',
      },
      if (widget.ipo.ipoFundUsingInfo != null && widget.ipo.ipoFundUsingInfoReference != null)
        {
          // Fon Kullanım Yeri
          'mainTitle': L10n.tr('ipo_fund_using_info'),
          'subTitle': widget.ipo.ipoFundUsingInfo ?? '',
          'referenceText': widget.ipo.ipoFundUsingInfoReference ?? '',
        },
      if (widget.ipo.allotments != null && widget.ipo.allotmentsReference != null)
        {
          // Tahsisat Grupları
          'mainTitle': L10n.tr('allotments'),
          'subTitle': widget.ipo.allotments ?? '',
          'referenceText': widget.ipo.allotmentsReference ?? '',
        },
      if (widget.ipo.sharesDistributed != null && widget.ipo.sharesDistributedReference != null)
        {
          // Dağıtılacak Pay Miktarı
          'mainTitle': L10n.tr('ipo_shares_distributed'),
          'subTitle': widget.ipo.sharesDistributed ?? '',
          'referenceText': widget.ipo.sharesDistributedReference ?? '',
        },
      if (widget.ipo.shareKeepingPromises != null && widget.ipo.shareKeepingPromisesReference != null)
        {
          // Satmama Taahhütü
          'mainTitle': L10n.tr('ipo_share_keeping_promises'),
          'subTitle': widget.ipo.shareKeepingPromises ?? '',
          'referenceText': widget.ipo.shareKeepingPromisesReference ?? '',
        },
      if (widget.ipo.publicityRate != null && widget.ipo.publicityRateReference != null)
        {
          // Halka Açıklık
          'mainTitle': L10n.tr('ipo_publicity_rate'),
          'subTitle': widget.ipo.publicityRate ?? '',
          'referenceText': widget.ipo.publicityRateReference ?? '',
        },
      if (widget.ipo.discount != null && widget.ipo.discountReference != null)
        {
          // İskonto
          'mainTitle': L10n.tr('ipo_discount'),
          'subTitle': widget.ipo.discount ?? '',
          'referenceText': widget.ipo.discountReference ?? '',
        },
      if (widget.ipo.size != null && widget.ipo.sizeReference != null)
        {
          // Halka Arz Büyüklüğü
          'mainTitle': L10n.tr('ipo_size'),
          'subTitle': widget.ipo.size ?? '',
          'referenceText': widget.ipo.sizeReference ?? '',
        },
    ];

    return Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: PExpandablePanel(
          initialExpanded: _isPastSuggestionsExpanded,
          isExpandedChanged: (isExpanded) => setState(() {
            _isPastSuggestionsExpanded = isExpanded;
          }),
          titleBuilder: (isExpanded) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m - Grid.xs,
            ),
            child: Row(
              children: [
                Text(
                  L10n.tr('ipo_company_details'),
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                  isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.pColorScheme.textPrimary, BlendMode.srcIn),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              _websiteRow(
                context,
                widget.ipo.companyWebsite ?? '',
              ),
              ...companyDetailList.map(
                (e) => Column(
                  children: [
                    _companyDetailCommonWidget(
                      context,
                      mainTitle: e['mainTitle'],
                      subTitle: e['subTitle'],
                      referenceText: e['referenceText'],
                    ),
                  ],
                ),
              ),
              // Finansal Tablo
              _financialTableWidget(
                context,
                widget.ipo,
              ),
              // Halka Arz Sonuçları
              _resultTableWidget(
                context,
                widget.ipo,
              ),
              // Dipnot
              if (widget.ipo.summaryFootnotes != null) _companyDetailRow(widget.ipo.summaryFootnotes ?? ''),
            ],
          ),
        ));
  }

  Widget _websiteRow(
    BuildContext context,
    String value,
  ) {
    String? domain = _getBaseDomain(value);
    if (domain == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.xs,
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.tr('web_sitesi'),
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          const SizedBox(
            height: Grid.s,
          ),
          RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              text: domain,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _goLink(value);
                },
            ),
          ),
        ],
      ),
    );
  }

  String? _getBaseDomain(String url) {
    RegExp regExp = RegExp(r'(?<=://)([^/]+)');
    Match? match = regExp.firstMatch(url);
    return match?.group(0);
  }

  void _goLink(String url) async {
    if (url.isEmpty) return;

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }

  Widget _companyDetailCommonWidget(
    BuildContext context, {
    String mainTitle = '',
    String subTitle = '',
    String referenceText = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _companyDetailMainTitle(
            context,
            mainTitle: mainTitle,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          _companyDetailRow(
            subTitle,
          ),
          const SizedBox(
            height: Grid.xxs,
          ),
          _referanceTextWidget(
            referenceText,
          ),
        ],
      ),
    );
  }

  Widget _companyDetailMainTitle(BuildContext context, {String mainTitle = ''}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        mainTitle,
        textAlign: TextAlign.start,
        style: context.pAppStyle.labelMed14textPrimary,
      ),
    );
  }

  Widget _companyDetailRow(String value) {
    return Text(
      value,
      style: context.pAppStyle.labelReg14textSecondary,
    );
  }

  Widget _referanceTextWidget(String value) {
    return Text(
      value,
      style: context.pAppStyle.interRegularBase.copyWith(
        fontSize: Grid.s + Grid.xs,
        color: context.pColorScheme.textTeritary,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _financialTableWidget(
    BuildContext context,
    IpoDetailModel ipo,
  ) {
    if (ipo.financialTablePeriod1 == null &&
        ipo.financialTablePeriod2 == null &&
        ipo.financialTablePeriod3 == null &&
        ipo.financialTableRevenues1 == null &&
        ipo.financialTableRevenues2 == null &&
        ipo.financialTableRevenues3 == null &&
        ipo.financialTableGrossProfit1 == null &&
        ipo.financialTableGrossProfit2 == null &&
        ipo.financialTableGrossProfit3 == null) {
      return const SizedBox.shrink();
    }

    List<Map<String, dynamic>> tableDataList = [
      {
        'value1': L10n.tr('ipo_financial_table'),
        'value2': ipo.financialTablePeriod1 ?? '',
        'value3': ipo.financialTablePeriod2 ?? '',
        'value4': ipo.financialTablePeriod3 ?? '',
      },
      {
        // Hasılat
        'value1': L10n.tr('ipo_financial_table_revenues'),
        'value2': ipo.financialTableRevenues1 ?? '',
        'value3': ipo.financialTableRevenues2 ?? '',
        'value4': ipo.financialTableRevenues3 ?? '',
      },
      {
        // Brüt Kar
        'value1': L10n.tr('financial_table_gross_profit'),
        'value2': ipo.financialTableGrossProfit1 ?? '',
        'value3': ipo.financialTableGrossProfit2 ?? '',
        'value4': ipo.financialTableGrossProfit3 ?? '',
      },
    ];
    return _commonTableWidget(context, tableDataList);
  }

  Widget _resultTableWidget(
    BuildContext context,
    IpoDetailModel ipo,
  ) {
    if (ipo.ipoResultDomesticIndividualPerson == null &&
        ipo.ipoResultDomesticIndividualLot == null &&
        ipo.ipoResultDomesticIndividualRate == null &&
        ipo.ipoResultDomesticCorporatePerson == null &&
        ipo.ipoResultDomesticIndividualLot == null &&
        ipo.ipoResultDomesticCorporateRate == null) {
      return const SizedBox.shrink();
    }

    List<Map<String, dynamic>> tableDataList = [
      {
        'value1': L10n.tr('ipo_investor_group'),
        'value2': L10n.tr('ipo_person'),
        'value3': 'Lot',
        'value4': L10n.tr('ipo_ratio'),
      },
      {
        'value1': L10n.tr('ipo_result_domestic_individual'),
        'value2': ipo.ipoResultDomesticIndividualPerson?.toString() ?? '',
        'value3': ipo.ipoResultDomesticIndividualLot?.toString() ?? '',
        'value4': '%${ipo.ipoResultDomesticIndividualRate?.toString() ?? ''}',
      },
      {
        // Hasılat
        'value1': L10n.tr('ipo_result_domestic_corporate'),
        'value2': ipo.ipoResultDomesticCorporatePerson?.toString() ?? '',
        'value3': ipo.ipoResultDomesticCorporateLot?.toString() ?? '',
        'value4': '%${ipo.ipoResultDomesticCorporateRate?.toString() ?? ''}',
      },
    ];
    if (ipo.ipoResultGroupEmployeesLot != null &&
        ipo.ipoResultGroupEmployeesPerson != null &&
        ipo.ipoResultGroupEmployeesRate != null) {
      tableDataList.add({
        'value1': L10n.tr('ipo_result_group_employees'),
        'value2': ipo.ipoResultGroupEmployeesPerson?.toString() ?? '',
        'value3': ipo.ipoResultGroupEmployeesLot?.toString() ?? '',
        'value4': '%${ipo.ipoResultGroupEmployeesRate?.toString() ?? ''}',
      });
    }

    if (ipo.ipoResultAbroadCorporateLot != null &&
        ipo.ipoResultAbroadCorporatePerson != null &&
        ipo.ipoResultAbroadCorporateRate != null) {
      tableDataList.add({
        'value1': L10n.tr('ipo_result_abroad_corporate'),
        'value2': ipo.ipoResultAbroadCorporatePerson?.toString() ?? '',
        'value3': ipo.ipoResultAbroadCorporateLot?.toString() ?? '',
        'value4': '%${ipo.ipoResultAbroadCorporateRate?.toString() ?? ''}',
      });
    }

    tableDataList.add(
      {
        // Brüt Kar
        'value1': L10n.tr('toplam'),
        'value2':
            '${(ipo.ipoResultDomesticIndividualPerson ?? 0) + (ipo.ipoResultDomesticCorporatePerson ?? 0) + (ipo.ipoResultGroupEmployeesPerson ?? 0) + (ipo.ipoResultAbroadCorporatePerson ?? 0)}',
        'value3':
            '${(ipo.ipoResultDomesticIndividualLot ?? 0) + (ipo.ipoResultDomesticCorporateLot ?? 0) + (ipo.ipoResultGroupEmployeesLot ?? 0) + (ipo.ipoResultAbroadCorporateLot ?? 0)}',
        'value4':
            '%${(ipo.ipoResultDomesticIndividualRate ?? 0) + (ipo.ipoResultDomesticCorporateRate ?? 0) + (ipo.ipoResultGroupEmployeesRate ?? 0) + (ipo.ipoResultAbroadCorporateRate ?? 0)}',
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _companyDetailMainTitle(
          context,
          mainTitle: L10n.tr('ipo_result'),
        ),
        const SizedBox(height: Grid.s),
        _commonTableWidget(context, tableDataList),
        _referanceTextWidget(ipo.ipoResultFootnotes ?? ''),
      ],
    );
  }

  Widget _commonTableWidget(BuildContext context, List<Map<String, dynamic>> dataList) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        ...List.generate(
          dataList.length,
          (index) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Grid.s,
                  ),
                  child: _companyDetailRow(dataList[index]['value1'].toString()),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Grid.s,
                  ),
                  child: _companyDetailRow(dataList[index]['value2'].toString()),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Grid.s,
                  ),
                  child: _companyDetailRow(dataList[index]['value3'].toString()),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Grid.s,
                  ),
                  child: _companyDetailRow(dataList[index]['value4'].toString()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getipoTypeStockholderSaleDesc() {
    if (widget.ipo.ipoTypeStockholderSale != null) {
      return '\n${L10n.tr('ipo_type_stockholder_sale')} ${widget.ipo.ipoTypeStockholderSale}';
    }
    return '';
  }
}
