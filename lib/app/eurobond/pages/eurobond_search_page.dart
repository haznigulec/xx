import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_state.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_field.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class EurobondSearchSelectPage extends StatefulWidget {
  const EurobondSearchSelectPage({
    super.key,
  });

  @override
  State<EurobondSearchSelectPage> createState() => _EurobondSearchSelectPageState();
}

class _EurobondSearchSelectPageState extends State<EurobondSearchSelectPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController queryController = TextEditingController();
  List<Bonds> bondSearchResults = [];
  late EuroBondBloc _euroBondBloc;
  @override
  void initState() {
    _euroBondBloc = getIt<EuroBondBloc>();
    bondSearchResults.addAll(_euroBondBloc.state.bondListModel?.bonds ?? []);
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: PBlocBuilder<EuroBondBloc, EuroBondState>(
            bloc: _euroBondBloc,
            builder: (context, state) {
              return Column(
                children: [
                  SymbolSearchField(
                    controller: queryController,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        bondSearchResults.clear();
                        bondSearchResults.addAll(
                          (_euroBondBloc.state.bondListModel?.bonds ?? [])
                              .where((element) => element.name!.toLowerCase().contains(text.toLowerCase()))
                              .toList(),
                        );
                      } else {
                        bondSearchResults.clear();
                        bondSearchResults.addAll(_euroBondBloc.state.bondListModel?.bonds ?? []);
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: Grid.s),
                  bondSearchResults.isEmpty
                      ? Expanded(
                          child: NoDataWidget(message: L10n.tr('no_news_found')),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: bondSearchResults.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return const PDivider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              splashColor: context.pColorScheme.transparent,
                              highlightColor: context.pColorScheme.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Grid.s),
                                child: SizedBox(
                                  height: 48,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        ImagesPath.yurt_disi,
                                        width: 28,
                                        height: 28,
                                      ),
                                      const SizedBox(
                                        width: Grid.s,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            bondSearchResults[index].name ?? '',
                                            style: context.pAppStyle.labelReg14textPrimary,
                                          ),
                                          Text(
                                            '${bondSearchResults[index].currencyName ?? ''} • ${L10n.tr('eurobond')}',
                                            style: context.pAppStyle.labelReg12textSecondary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                router.popUntilRouteWithName(EuroBondDetailRoute.name);
                                router.replace(
                                  EuroBondDetailRoute(
                                    selectedEuroBond: bondSearchResults[index],
                                    transactionStartTime: _euroBondBloc.state.bondListModel?.transactionStartTime ?? '',
                                    transactionEndTime: _euroBondBloc.state.bondListModel?.transactionEndTime ?? '',
                                  ),
                                );
                                router.push(
                                  EuroBondBuySellRoute(
                                    action: OrderActionTypeEnum.buy,
                                    selectedEuroBond: bondSearchResults[index],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
