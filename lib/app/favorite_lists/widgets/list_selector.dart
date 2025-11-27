import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/list/list_item.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ListSelector extends StatelessWidget {
  final List<FavoriteList> watchList;
  final FavoriteList? selectedList;

  const ListSelector({
    super.key,
    this.selectedList,
    required this.watchList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: watchList.length,
          separatorBuilder: (context, index) => const PDivider(),
          itemBuilder: (context, index) => PListItem(
            title: '${watchList[index].name} (${watchList[index].favoriteListItems.length})',
            titleStyle: context.pAppStyle.interRegularBase.copyWith(
              color: selectedList == watchList[index] ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
              fontSize: Grid.m,
            ),
            leadingWidgetSize: const Size(13, 30),
            leading: Container(
              margin: const EdgeInsets.only(
                right: Grid.s,
              ),
              decoration: BoxDecoration(
                color:
                    selectedList == watchList[index] ? context.pColorScheme.primary : context.pColorScheme.transparent,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            onTap: () {
              getIt<FavoriteListBloc>().add(
                SelectListEvent(
                  selectedList: watchList[index],
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ),
        if (getIt<FavoriteListBloc>().state.watchList.length < 5) ...[
          const PDivider(),
          PTextButtonWithIcon(
            text: L10n.tr('create_favorite_list'),
            sizeType: PButtonSize.medium,
            icon: SvgPicture.asset(
              ImagesPath.plus,
              width: 17,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => FavoriteListUtils().createFavoriteList(context, popTimes: 2),
          )
        ]
      ],
    );
  }
}
