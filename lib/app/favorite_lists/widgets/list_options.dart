import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/rename_list.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ListOptions extends StatelessWidget {
  const ListOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteListBloc favoriteListBloc = getIt<FavoriteListBloc>();
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: favoriteListBloc,
      builder: (context, state) {
        return PIconButton(
          type: PIconButtonType.outlined,
          svgPath: ImagesPath.circle_dots,
          sizeType: PIconButtonSize.xl,
          onPressed: () {
            PBottomSheet.show(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _listItem(
                    context,
                    title: 'favorite.rename',
                    assetPath: ImagesPath.pencil,
                    onTap: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('favorite.rename'),
                        child: const RenameList(),
                      );
                    },
                  ),
                  const PDivider(),
                  _listItem(
                    context,
                    title: 'favorite.remove',
                    assetPath: ImagesPath.trash,
                    onTap: () {
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('favorite.about_to_remove', args: [
                          state.selectedList?.name ?? '',
                        ]),
                        showFilledButton: true,
                        showOutlinedButton: true,
                        filledButtonText: L10n.tr('onayla'),
                        outlinedButtonText: L10n.tr('vazgec'),
                        onOutlinedButtonPressed: () => Navigator.pop(context),
                        onFilledButtonPressed: () {
                          favoriteListBloc.add(
                            RemoveListEvent(
                              id: state.selectedList?.id ?? 0,
                              callback: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                PBottomSheet.showError(
                                  context,
                                  isSuccess: true,
                                  content: L10n.tr(
                                    'favorite.removed',
                                    args: [state.selectedList?.name ?? ''],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _listItem(
    BuildContext context, {
    required String title,
    required String assetPath,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.l,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: Grid.xxs,
            ),
            SvgPicture.asset(
              assetPath,
              width: Grid.m + Grid.xxs,
              height: Grid.m + Grid.xxs,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: Grid.s),
            Text(
              L10n.tr(title),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
