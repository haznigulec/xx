import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_themes_model.dart';
import 'package:piapiri_v2/common/widgets/list/sector_group_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';

class FundThemesWidget extends StatelessWidget {
  const FundThemesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
      bloc: getIt<FundBloc>(),
      builder: (context, state) {
        int total = state.fundThemeList!.length;
        
        // Eğer toplam 8 veya daha azsa, ilk 4 yukarı, kalan aşağı
        // Ama 8'den fazlaysa, yukarıya yarıdan fazlasını koy
        int topCount;
        if (total <= 4) {
          topCount = total; // Hepsi yukarı
        } else {
          topCount = (total / 2).ceil(); // Örn: 9 => 5 yukarı, 4 aşağı
        }

        List<FundThemesModel> topItems = state.fundThemeList!.take(topCount).toList();
        List<FundThemesModel> bottomItems = state.fundThemeList!.skip(topCount).toList();

        return Shimmerize(
          enabled: state.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: Grid.s,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: topItems
                      .map(
                        (e) => SectorGroupTile(
                          title: e.themeName,
                          cdnUrl: e.cdnUrl,
                          onTap: () => onTapTile(e),
                        ),
                      )
                      .toList(),
                ),
                if (bottomItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.s + Grid.xs,
                    ),
                    child: Row(
                      spacing: Grid.s,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: bottomItems
                          .map(
                            (e) => SectorGroupTile(
                              title: e.themeName,
                              cdnUrl: e.cdnUrl,
                              onTap: () => onTapTile(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onTapTile(FundThemesModel fundTheme) {
    getIt<FundBloc>().add(
      SetFilterEvent(
        fundFilter: FundFilterModel(
          institution: '',
          institutionName: '',
          themeId: fundTheme.themeId,
        ),
        callback: (list) {},
      ),
    );
    router.push(
      FundsListRoute(
        title: fundTheme.themeName,
        fromSectors: true,
      ),
    );
  }
}
