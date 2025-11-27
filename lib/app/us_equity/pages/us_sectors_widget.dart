import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/widgets/list/sector_group_tile.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/us_sector_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class UsSectorsWidget extends StatefulWidget {
  const UsSectorsWidget({super.key});

  @override
  State<UsSectorsWidget> createState() => _UsSectorsWidgetState();
}

class _UsSectorsWidgetState extends State<UsSectorsWidget> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  List<UsSectorModel> _topSectors = [];
  List<UsSectorModel> _bottomSectors = [];
  @override
  initState() {
    _usEquityBloc.add(
      GetUsSectorsEvent(
        callback: (sectors) {
          int total = sectors.length;

          // Eğer toplam 8 veya daha azsa, ilk 4 yukarı, kalan aşağı
          // Ama 8'den fazlaysa, yukarıya yarıdan fazlasını koy
          int topCount;
          if (total <= 4) {
            topCount = total; // Hepsi yukarı
          } else {
            topCount = (total / 2).ceil(); // Örn: 9 => 5 yukarı, 4 aşağı
          }

          _topSectors = sectors.take(topCount).toList();
          _bottomSectors = sectors.skip(topCount).toList();

          setState(() {});
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Grid.m,
            right: Grid.m,
          ),
          child: Text(
            L10n.tr('us_sectors'),
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Shimmerize(
          enabled: _topSectors.isEmpty && _bottomSectors.isEmpty,
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
                  children: _topSectors
                      .map(
                        (e) => SectorGroupTile(
                          title: e.sectorName,
                          cdnUrl: e.cdnUrl,
                          onTap: () => onTapTile(e),
                        ),
                      )
                      .toList(),
                ),
                if (_bottomSectors.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.s + Grid.xs,
                    ),
                    child: Row(
                      spacing: Grid.s,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _bottomSectors
                          .map(
                            (e) => SectorGroupTile(
                              title: e.sectorName,
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
        ),
      ],
    );
  }

  void onTapTile(UsSectorModel sector) {
    router.push(
      UsListingRoute(
        title: sector.sectorName,
        symbolNames: sector.symbolList,
        sortenum: SortEnum.ascending,
        ignoreUnsubscribeSymbols: getIt<UsEquityBloc>().state.favoriteIncomingDividends,
      ),
    );
  }

}
