import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/charts/risk_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/app/fund/model/fund_brief_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_expansion_grid.dart';

class FundBrief extends StatefulWidget {
  final FundDetailModel fund;
  final BuildContext context;
  const FundBrief({
    super.key,
    required this.fund,
    required this.context,
  });

  @override
  State<FundBrief> createState() => _FundBriefState();
}

class _FundBriefState extends State<FundBrief> {
  late List<FundBriefModel> _symbolBriefs;
  bool _isExpanded = false;
  late FundDetailModel _fund;
  late FundBloc _fundBloc;

  @override
  void initState() {
    super.initState();
    _fundBloc = getIt<FundBloc>();
    _fund = widget.fund;

    _symbolBriefs = [
      FundBriefModel(
        title: L10n.tr('fund_tefas_start_date_v2'),
        value: _fund.tefasStartTime,
      ),
      FundBriefModel(
        title: L10n.tr('fund_tefas_end_date_v2'),
        value: _fund.tefasEndTime,
      ),
      FundBriefModel(
        title: L10n.tr('fund_purchase_valor'),
        value: 'T+${_fund.buyMaturity}',
      ),
      FundBriefModel(
        title: L10n.tr('fund_sell_valor'),
        value: 'T+${_fund.sellMaturity}',
      ),
      FundBriefModel(
        title: L10n.tr('risk_level'),
        value: _fund.riskLevel != null && _fund.riskLevel == 0 ? '-' : RiskBar(riskLevel: _fund.riskLevel!),
      ),
      FundBriefModel(
        title: L10n.tr('fund_management_fee'),
        value: '%${MoneyUtils().readableMoney(
          double.parse(_fund.managementFee.toString()),
        )}',
      ),
      FundBriefModel(
        title: L10n.tr('fund_tefas_min_purchase'),
        value: _fund.minBuyAmount.toStringAsFixed(0),
      ),
      FundBriefModel(
        title: L10n.tr('fund_tefas_min_sell'),
        value: _fund.minSellAmount.toStringAsFixed(0),
      ),
      FundBriefModel(
        title: L10n.tr('fund_tefas_status'),
        value: L10n.tr(_fund.tefasStatus == 1 ? 'fund_trading' : 'fund_not_trading'),
      ),
      FundBriefModel(
        title: L10n.tr('fund_total_value'),
        value: '₺${MoneyUtils().compactLong(_fund.portfolioSize)}',
      ),
      FundBriefModel(
        title: L10n.tr('category'),
        value: _clickableRow(
          context: widget.context,
          briefText: widget.fund.applicationCategoryName ?? _fund.subType,
          onTap: _fundBloc.state.founderInfoList != null && _fundBloc.state.applicationCategories != null
              ? () {
                  _fundBloc.add(
                    SetFilterEvent(
                      fundFilter: FundFilterModel(
                        institution: '',
                        institutionName: '',
                        applicationCategory: widget.fund.applicationCategoryCode.toString(),
                      ),
                      callback: (list) {},
                    ),
                  );
                  router.push(
                    FundsListRoute(
                      title: widget.fund.applicationCategoryName ?? _fund.subType,
                      fromSectors: true,
                    ),
                  );
                }
              : null,
        ),
      ),
      FundBriefModel(
        title: L10n.tr('fund_market_share'),
        value: MoneyUtils().readableMoney(_fund.marketShare * 100),
      ),
      FundBriefModel(
        title: L10n.tr('fund_rank'),
        value: _fund.rank.toStringAsFixed(0),
        tooltipText: L10n.tr('fund_rank_tooltip'),
        isShowInfoIcon: true,
      ),
      FundBriefModel(
          title: L10n.tr('fund_number_of_category'),
          value: _fund.categoryCount.toStringAsFixed(0),
          tooltipText: L10n.tr('fund_number_of_category_tooltip'),
          isShowInfoIcon: true),
      FundBriefModel(
        title: L10n.tr('fund_number_of_investors'),
        value: _fund.numberOfPeople.toStringAsFixed(0),
      ),
      FundBriefModel(
        title: L10n.tr('fund_found_date'),
        value: _fund.founded.isEmpty ? L10n.tr('-') : _fund.founded,
      ),
      FundBriefModel(
        title: L10n.tr('kurucu'),
        value: _clickableRow(
          context: widget.context,
          briefText: _fund.founder,
          onTap: _fundBloc.state.founderInfoList != null
              ? () {
                  router.push(
                    FundFoundersDetailRoute(
                      institution: _fundBloc.state.founderInfoList!.firstWhere((e) => e.code == _fund.institutionCode),
                    ),
                  );
                }
              : null,
        ),
      ),
      FundBriefModel(
        title: L10n.tr('fund_isin_code'),
        value: _fund.isin,
        isShowInfoIcon: true,
        tooltipText: L10n.tr('isin_code_tooltip'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr('fund_summary'),
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        const SizedBox(height: Grid.s + Grid.xs),
        ..._generateHeaderInfos(),
        PExpandablePanel(
          initialExpanded: _isExpanded,
          isExpandedChanged: (isExpanded) => setState(() {
            _isExpanded = isExpanded;
          }),
          setTitleAtBottom: true,
          titleBuilder: (isExpanded) => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isExpanded ? L10n.tr('daha_az_göster') : L10n.tr('daha_fazla_goster'),
              style: context.pAppStyle.labelReg16primary,
            ),
          ),
          child: _generateExpansionInfos(),
        ),
        const SizedBox(height: Grid.l),
      ],
    );
  }

  List<Widget> _generateHeaderInfos() {
    List<Widget> headerInfos = [];
    for (var i = 0; i < 6; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs[i].title,
                  value: _symbolBriefs[i].value,
                  isShowInfo: _symbolBriefs[i].isShowInfoIcon,
                ),
              ),
              const SizedBox(width: Grid.m),
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs[i + 1].title,
                  value: _symbolBriefs[i + 1].value,
                  isShowInfo: _symbolBriefs[i + 1].isShowInfoIcon,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }

  Widget _clickableRow({required String briefText, Function()? onTap, required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .5 - (Grid.m * 3),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              briefText,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                matchTextDirection: true,
                ImagesPath.arrow_up_right,
                width: Grid.m,
                height: Grid.m,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generateExpansionInfos() {
    final expansionItems = _symbolBriefs.sublist(6);
    return FundExpansionGrid(items: expansionItems);
  }
}
