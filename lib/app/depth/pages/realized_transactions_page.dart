import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_event.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_state.dart';
import 'package:piapiri_v2/app/depth/widgets/realized_transaction_row.dart';
import 'package:piapiri_v2/app/depth/widgets/realized_transactions_title.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RealizedTransactionsPage extends StatefulWidget {
  final MarketListModel symbol;
  const RealizedTransactionsPage({
    super.key,
    required this.symbol,
  });

  @override
  State<RealizedTransactionsPage> createState() => _RealizedTransactionsPageState();
}

class _RealizedTransactionsPageState extends State<RealizedTransactionsPage> {
  final DepthBloc _depthBloc = getIt<DepthBloc>();
  final AppInfoState _appInfoState = getIt<AppInfoBloc>().state;
  bool _isTradeExpanded = true;

  @override
  void initState() {
    _depthBloc.add(
      ConnectTradeEvent(
        symbol: widget.symbol,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PExpandablePanel(
          initialExpanded: _isTradeExpanded,
          isExpandedChanged: (isExpanded) => setState(() => _isTradeExpanded = isExpanded),
          titleBuilder: (_) => Row(
            children: [
              Text(
                L10n.tr('completed_transactions'),
                style: context.pAppStyle.labelMed16textPrimary,
              ),
              const SizedBox(width: Grid.xs),
              SvgPicture.asset(
                _isTradeExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              const RealizedTransactionsTitle(),
              const SizedBox(height: Grid.s),
              PDivider(
                color: context.pColorScheme.line,
                tickness: 1,
              ),
              PBlocBuilder<DepthBloc, DepthState>(
                bloc: _depthBloc,
                builder: (context, state) {
                  if (state.tradeList.isEmpty) return const SizedBox.shrink();
                  List<Map<String, dynamic>> elementList = state.tradeList
                      .map((e) => {
                            'fiyat': MoneyUtils().readableMoney(e.price),
                            'adet': e.quantity.toString(),
                            'alan': e.buyer.isEmpty ? '-' : e.buyer,
                            'satan': e.seller.isEmpty ? '-' : e.seller,
                            'activeBidOrAsk': e.activeBidOrAsk,
                          })
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: elementList.length < 20 ? elementList.length : 20,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RealizedTransactionRow(
                        qty: elementList[index]["adet"],
                        price:
                            '${MoneyUtils().getCurrency(stringToSymbolType(widget.symbol.type))}${elementList[index]["fiyat"]}',
                        buyer: _appInfoState.memberCodeShortNames[elementList[index]["alan"]] ??
                            elementList[index]["alan"],
                        seller: _appInfoState.memberCodeShortNames[elementList[index]["satan"]] ??
                            elementList[index]["satan"],
                        textColor: elementList[index]["activeBidOrAsk"] == "a"
                            ? context.pColorScheme.critical
                            : context.pColorScheme.success,
                      );
                    },
                  );
                },
              ),

                  
              const SizedBox(
                height: Grid.m,
              )
            ],
          ),
        )
      ],
    );
  }
}
