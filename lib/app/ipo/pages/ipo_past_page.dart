import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoPastPage extends StatefulWidget {
  const IpoPastPage({super.key});

  @override
  State<IpoPastPage> createState() => _IpoPastPageState();
}

class _IpoPastPageState extends State<IpoPastPage> {
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
    return PBlocBuilder<IpoBloc, IpoState>(
      bloc: _ipoBloc,
      builder: (context, state) {
        if (state.pastIpoList.isEmpty) {
          return NoDataWidget(
            message: L10n.tr(
              'no_found_ipo',
              args: [
                L10n.tr('past'),
              ],
            ),
          );
        }

        bool showMore = false;
        List<IpoModel> pastIpoList = state.pastIpoList;

        if (state.pastIpoList.length > 5) {
          showMore = true;
          pastIpoList = state.pastIpoList.take(5).toList();
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: Grid.m,
            right: Grid.m,
            top: Grid.l,
          ),
          child: Shimmerize(
            enabled: state.isFetching,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    ),
                    child: PDivider(),
                  ),
                  ListView.builder(
                    itemCount: pastIpoList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                    itemBuilder: (context, index) {
                      IpoModel ipo = pastIpoList[index];

                      return IpoTile(
                        key: ValueKey('past_ipo_tile_${ipo.id}_$index'),
                        ipo: ipo,
                        showLastPrice: true,
                        canRequest: true,
                        fromPastIpo: true,
                        dividerTopPadding: 10,
                        showDivider: index != pastIpoList.length - 1,
                      );
                    },
                  ),
                  if (showMore) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Grid.s,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PCustomOutlinedButtonWithIcon(
                          text: L10n.tr('view_full_list'),
                          iconSource: ImagesPath.arrow_up_right,
                          buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                          onPressed: () {
                            router.push(
                              const IpoAllListRoute(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
