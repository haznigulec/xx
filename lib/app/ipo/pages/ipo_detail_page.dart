import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_detail_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_company_detail_widget.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_last_price_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class IpoDetailPage extends StatefulWidget {
  final Uint8List? symbolLogo;
  final bool isDemanded;
  final bool canRequest;
  final IpoModel ipo;
  final int id;
  final VoidCallback onSuccess;
  final bool fromPastIpo;
  const IpoDetailPage({
    super.key,
    this.symbolLogo,
    this.isDemanded = false,
    this.canRequest = false,
    required this.ipo,
    required this.id,
    required this.onSuccess,
    this.fromPastIpo = false,
  });

  @override
  State<IpoDetailPage> createState() => _IpoDetailPageState();
}

class _IpoDetailPageState extends State<IpoDetailPage> {
  late IpoBloc _ipoBloc;
  bool _isAttachmentsExpanded = false;
  bool _isLinksExpanded = false;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _ipoBloc.add(
      GetIpoDetailsByIdEvent(
        ipoId: widget.id,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<IpoBloc, IpoState>(
      bloc: getIt<IpoBloc>(),
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: state.ipoDetailModel?.symbol ?? '',
            ),
            body: const PLoading(),
          );
        }

        if (state.ipoDetailModel == null) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: state.ipoDetailModel?.symbol ?? '',
            ),
            body: NoDataWidget(
              message: L10n.tr('no_data'),
            ),
          );
        }

        String startDate = '';
        String endDate = '';
        String startPrice = '';
        String endPrice = '';

        if (state.ipoDetailModel!.startDate != null) {
          startDate = DateTime.parse(state.ipoDetailModel!.startDate!).formatDayMonthYearTimeWithComma();
        }

        if (state.ipoDetailModel!.endDate != null) {
          endDate = DateTime.parse(
            state.ipoDetailModel!.endDate ?? DateTime.now().toString(),
          ).formatDayMonthYearTimeWithComma();
        }

        if (state.ipoDetailModel!.startPrice != null) {
          if (state.ipoDetailModel!.endPrice == null) {
            startPrice = '₺${MoneyUtils().readableMoney(state.ipoDetailModel!.startPrice!)}';
          } else {
            startPrice = '₺${MoneyUtils().readableMoney(state.ipoDetailModel!.startPrice!)}';
          }
        }

        if (state.ipoDetailModel!.endPrice != null) {
          endPrice = ' - ₺${MoneyUtils().readableMoney(state.ipoDetailModel!.endPrice!)}';
        }

        List<Map<String, dynamic>> generalDetailList = [
          {
            'title': L10n.tr('start_demand_collection'),
            'value': startDate,
          },
          {
            'title': L10n.tr('end_demand_collection'),
            'value': endDate,
          },
          {
            'title': endPrice.isNotEmpty ? L10n.tr('ipo_price_range') : L10n.tr('ipo_price'),
            'value': '$startPrice$endPrice',
          },
          if (state.ipoDetailModel!.distributionType != null)
            {
              'title': L10n.tr('distribution_method'),
              'value': state.ipoDetailModel!.distributionType ?? '',
            },
          if (state.ipoDetailModel!.ipoSaleType != null)
            {
              'title': L10n.tr('ipo_sale_type'),
              'value': state.ipoDetailModel!.ipoSaleType ?? '',
            },
          if (state.ipoDetailModel!.ipoTypeReference != null)
            {
              'title': L10n.tr('ipo_reference'),
              'value': state.ipoDetailModel!.ipoTypeReference ?? '',
            },
          if (state.ipoDetailModel!.sharesToDistribute != null)
            {
              'title': L10n.tr('pay'),
              'value': '${MoneyUtils().readableMoney(
                state.ipoDetailModel!.sharesToDistribute!.toDouble(),
                pattern: '#,##0',
              )} LOT',
            },
          if (state.ipoDetailModel!.brokerageFirm != null)
            {
              'title': L10n.tr('brokerage_firm'),
              'value': state.ipoDetailModel!.brokerageFirm ?? '',
            },
          if (state.ipoDetailModel!.market != null)
            {
              'title': L10n.tr('ipo_market'),
              'value': state.ipoDetailModel!.market ?? '',
            },
          if (state.ipoDetailModel!.freeFloatingShares != null)
            {
              'title': L10n.tr('ipo_free_floating_shares'),
              'value': '${state.ipoDetailModel!.freeFloatingShares ?? ''} Lot',
            },
          if (state.ipoDetailModel!.freeFloatingShareRate != null)
            {
              'title': L10n.tr('ipo_free_floating_share_rate'),
              'value': '%${state.ipoDetailModel!.freeFloatingShareRate ?? ''}',
            },
          if (state.ipoDetailModel!.bistFirstTransactionDate != null)
            {
              'title': L10n.tr('ipo_bist_first_transaction_date'),
              'value': DateTime.parse(
                state.ipoDetailModel!.bistFirstTransactionDate ?? DateTime.now().toString(),
              ).formatDayNameDayMonthYear(),
            },
        ];

        return Scaffold(
          appBar: PInnerAppBar(
            title: state.ipoDetailModel!.symbol ?? '',
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(
                        top: Grid.s,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: context.pColorScheme.line,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.symbolLogo != null
                              ? ClipOval(
                                  child: Image.memory(
                                    widget.symbolLogo!,
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Utils.generateCapitalFallback(
                                  context,
                                  state.ipoDetailModel!.symbol ?? 'U',
                                  size: 38,
                                ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.ipoDetailModel!.symbol ?? '',
                                  style: context.pAppStyle.labelReg14textPrimary,
                                ),
                                Expanded(
                                  child: Text(
                                    (state.ipoDetailModel!.companyName ?? '').trim(),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.pAppStyle.labelMed12textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.fromPastIpo) ...[
                            const SizedBox(
                              width: Grid.s,
                            ),
                            IpoLastPriceWidget(
                              ipo: widget.ipo,
                              symbol: state.ipoDetailModel!.symbol ?? '',
                              showIpoPrice: false,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: Grid.s,
                        ),
                        ...generalDetailList.map(
                          (e) => _generalDetailRow(
                            context,
                            e['title'] ?? '',
                            e['value'] ?? '',
                          ),
                        ),
                        IpoCompanyDetailWidget(
                          ipo: state.ipoDetailModel!,
                        ),
                        _attachmentsWidget(
                          context,
                          state.ipoDetailModel!,
                        ), // Ekler
                        _linksWidget(
                          context,
                          state.ipoDetailModel!,
                        ), // Bağlantılar
                        SizedBox(
                          height: !widget.canRequest ? Grid.s : (56 + MediaQuery.paddingOf(context).bottom),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: generalButtonPadding(
            context: context,
            child: !widget.canRequest
                ? const SizedBox.shrink()
                : widget.fromPastIpo
                    ? PButtonWithIcon(
                        text: state.ipoDetailModel!.symbol ?? '',
                        height: 52,
                        iconAlignment: IconAlignment.end,
                        fillParentWidth: true,
                        icon: SvgPicture.asset(
                          ImagesPath.arrow_up_right,
                          width: 17,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.lightHigh,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          String symbolName = state.ipoDetailModel!.symbol ?? '';

                          if (symbolName.contains('.HE')) {
                            symbolName = symbolName.replaceAll('.HE', '');
                          }

                          MarketListModel selectedItem = MarketListModel(
                            symbolCode: symbolName,
                            updateDate: '',
                          );

                          router.push(
                            SymbolDetailRoute(
                              symbol: selectedItem,
                            ),
                          );
                        },
                      )
                    : widget.isDemanded
                        ? state.ipoDetailModel!.symbol!.toUpperCase().contains('.HE')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: PCustomOutlinedButtonWithIcon(
                                      fillParentWidth: true,
                                      text: L10n.tr('demand_detail'),
                                      iconSource: ImagesPath.arrow_up_right,
                                      buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                                      onPressed: () {
                                        router.push(
                                          IpoEnterDemandRoute(
                                            ipoDetail: state.ipoDetailModel!,
                                            ipo: widget.ipo,
                                            onSuccess: widget.onSuccess,
                                            hasSymbolHE: state.ipoDetailModel!.symbol!.toUpperCase().contains('.HE'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Grid.s,
                                  ),
                                  Expanded(
                                    child: PButton(
                                      text: L10n.tr('enter_demand'),
                                      fillParentWidth: true,
                                      onPressed: () {
                                        router.push(
                                          IpoEnterDemandRoute(
                                            ipoDetail: state.ipoDetailModel!,
                                            ipo: widget.ipo,
                                            onSuccess: widget.onSuccess,
                                            hasSymbolHE: state.ipoDetailModel!.symbol!.toUpperCase().contains('.HE'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : PButtonWithIcon(
                                text: L10n.tr('request_detail'),
                                height: 52,
                                fillParentWidth: true,
                                iconAlignment: IconAlignment.end,
                                icon: SvgPicture.asset(
                                  ImagesPath.arrow_up_right,
                                  width: Grid.m,
                                  height: Grid.m,
                                  colorFilter: ColorFilter.mode(
                                    context.pColorScheme.lightHigh,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () {
                                  router.push(
                                    IpoDemandedDetailRoute(
                                      ipo: widget.ipo,
                                      onSuccess: widget.onSuccess,
                                    ),
                                  );
                                },
                              )
                        : PButton(
                            text: L10n.tr('join_public_offering'),
                            fillParentWidth: true,
                            onPressed: () {
                              getIt<Analytics>().track(
                                AnalyticsEvents.halkaArzTalepGirButonClick,
                                taxonomy: [
                                  InsiderEventEnum.controlPanel.value,
                                  InsiderEventEnum.marketsPage.value,
                                  InsiderEventEnum.ipoTab.value,
                                ],
                                properties: {
                                  'symbol': widget.ipo.symbol ?? '',
                                },
                              );

                              router.push(
                                IpoEnterDemandRoute(
                                  ipoDetail: state.ipoDetailModel!,
                                  ipo: widget.ipo,
                                  onSuccess: widget.onSuccess,
                                  hasSymbolHE: state.ipoDetailModel!.symbol!.toUpperCase().contains('.HE'),
                                ),
                              );
                            },
                          ),
          ),
        );
      },
    );
  }

  Widget _attachmentsWidget(BuildContext context, IpoDetailModel ipoDetailModel) {
    if (ipoDetailModel.ipoAttachments!.isEmpty) return const SizedBox.shrink();

    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
      ),
      child: PExpandablePanel(
        initialExpanded: _isAttachmentsExpanded,
        isExpandedChanged: (isExpanded) => setState(() {
          _isAttachmentsExpanded = isExpanded;
        }),
        titleBuilder: (isExpanded) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Row(
            children: [
              Text(
                L10n.tr('ipo_attachments'),
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
            ...ipoDetailModel.ipoAttachments!.map(
              (e) => Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _goLink(e.url ?? ''),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          Grid.s,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.title ?? '',
                                style: _valueTextStyle(context),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_outward,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (e.children != null)
                      ...e.children!.map(
                        (item) => InkWell(
                          onTap: () => _goLink(item['url']),
                          child: Padding(
                            padding: const EdgeInsets.all(Grid.s),
                            child: Row(
                              children: [
                                Text(
                                  ' - ${item['title']}',
                                  style: _valueTextStyle(context),
                                ),
                                const Icon(
                                  Icons.arrow_outward,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linksWidget(BuildContext context, IpoDetailModel ipoDetailModel) {
    if (ipoDetailModel.ipoLinks!.isEmpty) return const SizedBox.shrink();

    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Theme.of(context).secondaryHeaderColor,
      ),
      child: PExpandablePanel(
        initialExpanded: _isLinksExpanded,
        isExpandedChanged: (isExpanded) => setState(() {
          _isLinksExpanded = isExpanded;
        }),
        titleBuilder: (isExpanded) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Row(
            children: [
              Text(
                L10n.tr('ipo_links'),
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
            ...ipoDetailModel.ipoLinks!.map(
              (e) => Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _goLink(e.url ?? ''),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.title ?? '',
                          style: context.pAppStyle.labelReg14textSecondary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_outward,
                        size: 14,
                        color: context.pColorScheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goLink(String url) async {
    if (url.isEmpty) return;

    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }

  TextStyle _titleTextStyle(BuildContext context) {
    return context.pAppStyle.labelReg14textSecondary;
  }

  TextStyle _valueTextStyle(BuildContext context) {
    return context.pAppStyle.labelMed14textPrimary;
  }

  Widget _generalDetailRow(
    BuildContext context,
    String title,
    String value, [
    bool showBorder = true,
  ]) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Grid.s,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: _titleTextStyle(context),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: _valueTextStyle(context),
                ),
              ),
            ],
          ),
        ),
        if (showBorder)
          const PDivider(
            padding: EdgeInsets.symmetric(
              vertical: Grid.s + Grid.xs,
            ),
          ),
      ],
    );
  }
}
