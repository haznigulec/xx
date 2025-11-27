import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

@RoutePage()
class IpoAllListPage extends StatefulWidget {
  const IpoAllListPage({super.key});

  @override
  State<IpoAllListPage> createState() => _IpoAllListPageState();
}

class _IpoAllListPageState extends State<IpoAllListPage> {
  late IpoBloc _ipoBloc;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _ipoBloc.add(
      GetPastListEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('past_ipos'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              ImagesPath.search,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              router.push(
                const IpoSearchRoute(),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: Grid.l - Grid.xs,
                  bottom: Grid.s + Grid.xs,
                ),
                child: PDivider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    L10n.tr('hisse'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  Text(
                    L10n.tr('last_price_total_change'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: Grid.s + Grid.xs,
                  bottom: Grid.s,
                ),
                child: PDivider(),
              ),
              PBlocBuilder<IpoBloc, IpoState>(
                bloc: _ipoBloc,
                builder: (context, state) {
                  return Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        final metrics = scrollInfo.metrics;
                        if (state.hasMorePastIpo &&
                            state.isNotFetching &&
                            metrics.pixels == metrics.maxScrollExtent &&
                            scrollInfo is ScrollEndNotification) {
                          _ipoBloc.add(
                            GetPastListEvent(),
                          );
                        }

                        return true;
                      },
                      child: ListView.builder(
                        itemCount: state.ipoDateGroup.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final String date = state.ipoDateGroup.keys.elementAt(index).toString();
                          if ((state.ipoDateGroup[date] ?? []).isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return StickyHeader(
                            header: Container(
                              width: double.infinity,
                              height: 25,
                              padding: const EdgeInsets.only(
                                top: Grid.s + Grid.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: context.pColorScheme.backgroundColor,
                              ),
                              child: Text(
                                L10n.tr(date),
                                style: context.pAppStyle.labelMed12textSecondary,
                              ),
                            ),
                            content: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.ipoDateGroup[date]!.length,
                              itemBuilder: (context, index) {
                                return IpoTile(
                                  ipo: state.ipoDateGroup[date]![index],
                                  showLastPrice: true,
                                  canRequest: true,
                                  fromPastIpo: true,
                                  dividerTopPadding: 10,
                                  showDivider: index != state.ipoDateGroup[date]!.length,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
