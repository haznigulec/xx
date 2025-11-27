import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:talker_flutter/talker_flutter.dart';

//Fon sepetleri liste tileleri
class FundPortfolioDetailTile extends StatefulWidget {
  final QuickPortfolioAssetModel item;

  const FundPortfolioDetailTile({
    super.key,
    required this.item,
  });

  @override
  State<FundPortfolioDetailTile> createState() => _FundPortfolioDetailTileState();
}

class _FundPortfolioDetailTileState extends State<FundPortfolioDetailTile> {
  late FundBloc _fundBloc;
  double _performance = 0;
  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _fundBloc.add(
      SetFilterEvent(
        fundFilter: getIt<FundBloc>().state.fundFilter.copyWith(
              institution: widget.item.founderCode,
              institutionName: widget.item.founderName,
              subType: 'ALL',
              subTypeName: 'ALL',
            ),
        callback: (symbols) {},
      ),
    );
    _performance = _fundBloc.state.fundList.firstWhereOrNull((e) => e.code == widget.item.code)?.performance1M ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          FundDetailRoute(
            fundCode: widget.item.code,
          ),
        );
      },
      child: PBlocBuilder<FundBloc, FundState>(
        bloc: _fundBloc,
        builder: (context, state) {
          _performance =
              _fundBloc.state.fundList.firstWhereOrNull((e) => e.code == widget.item.code)?.performance1M ?? 0;

          return SymbolListTile(
            leadingText: widget.item.subType ?? '',
            subLeadingText: '${widget.item.code} • ${widget.item.founderName}',
            infoText: '%${MoneyUtils().readableMoney(widget.item.ratio)}',
            symbolName: widget.item.founderCode ?? 'UNP',
            symbolType: SymbolTypes.fund,
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  _performance > 0
                      ? ImagesPath.trending_up
                      : _performance < 0
                          ? ImagesPath.trending_down
                          : ImagesPath.trending_notr,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    _performance > 0
                        ? context.pColorScheme.success
                        : _performance < 0
                            ? context.pColorScheme.critical
                            : context.pColorScheme.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: Grid.xxs),
                Text(
                  '%${MoneyUtils().readableMoney(_performance * 100)}',
                  style: context.pAppStyle.labelMed14textPrimary.copyWith(
                    color: _performance > 0
                        ? context.pColorScheme.success
                        : _performance < 0
                            ? context.pColorScheme.critical
                            : context.pColorScheme.iconPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
