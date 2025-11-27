import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_market_makers_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantMarketMakersList extends StatelessWidget {
  const WarrantMarketMakersList({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<WarrantBloc, WarrantState>(
      bloc: getIt<WarrantBloc>(),
      builder: (context, state) {
        if (state.marketMakerList.isEmpty) {
          return const SizedBox.shrink();
        }
        List<WarrantDropdownModel> marketMakerList =
            state.marketMakerList.where((element) => element.key.isNotEmpty).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.l,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    L10n.tr(
                      'market_makers',
                    ),
                    style: context.pAppStyle.labelMed18textPrimary,
                  ),
                  PCustomPrimaryTextButton(
                    text: L10n.tr(
                      'see_all',
                    ),
                    onPressed: () {
                      router.push(
                        WarrantMarketMakersRoute(
                          marketMakers: marketMakerList,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            SizedBox(
              height: 115,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: marketMakerList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                itemBuilder: (context, index) {
                  return WarrantMarketMakersTile(
                    marketMaker: marketMakerList[index],
                  );
                },
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
