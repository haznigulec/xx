import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_bloc.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_event.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_state.dart';
import 'package:piapiri_v2/app/twitter/widget/twitter_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class TwitterPage extends StatefulWidget {
  final String symbolName;
  const TwitterPage({
    super.key,
    required this.symbolName,
  });

  @override
  State<TwitterPage> createState() => _TwitterPageState();
}

class _TwitterPageState extends State<TwitterPage> {
  late TwitterBloc _twitterBloc;

  @override
  void initState() {
    _twitterBloc = getIt<TwitterBloc>();
    _twitterBloc.add(
      GetListEvent(
        symbol: widget.symbolName,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: Grid.m),
          child: InkWell(
            child: SvgPicture.asset(
              ImagesPath.chevron_left,
              height: 19,
              width: 19,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              router.maybePop();
            },
          ),
        ),
        centerTitle: false,
        titleSpacing: Grid.xs,
        title: Text(
          L10n.tr('shared_on_x'),
          style: context.pAppStyle.labelReg18primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: PBlocBuilder<TwitterBloc, TwitterState>(
          bloc: _twitterBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return const PLoading();
            }
            if (state.twitterList == null) {
              return NoDataWidget(message: L10n.tr('no_news_found'));
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: state.twitterList!.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return TwitterTile(
                  twitter: state.twitterList![index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const PDivider();
              },
            );
          },
        ),
      ),
    );
  }
}
