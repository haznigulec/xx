import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateList extends StatefulWidget {
  final List<FavoriteListItem>? favoriteListItems;
  final int popTimes;
  const CreateList({
    super.key,
    this.favoriteListItems,
    required this.popTimes,
  });

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          ImagesPath.favorites,
          width: Grid.l,
        ),
        const SizedBox(
          height: Grid.l,
        ),
        PTextField(
          controller: _controller,
          label: L10n.tr('list_name'),
          labelColor: context.pColorScheme.textSecondary,
          errorText: _controller.text.length >= 20 ? L10n.tr('max_20_char') : null,
          maxLength: 20,
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(
          height: Grid.l + Grid.s,
        ),
        PButton(
          text: L10n.tr('kaydet'),
          fillParentWidth: true,
          sizeType: PButtonSize.medium,
          variant: PButtonVariant.brand,
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () {
                  getIt<FavoriteListBloc>().add(
                    CreateListEvent(
                      name: _controller.text,
                      items: const [],
                      onSuccess: (listId) {
                        if (widget.favoriteListItems != null) {
                          getIt<FavoriteListBloc>().add(
                            UpdateListEvent(
                              id: listId,
                              name: _controller.text,
                              favoriteListItems: widget.favoriteListItems!,
                              sortingEnum: FavoriteSortingEnum.alphabetic,
                              onSuccess: () => _onSuccesCreateList(),
                            ),
                          );
                          return;
                        }
                        _onSuccesCreateList();
                      },
                    ),
                  );
                },
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
      ],
    );
  }

  void _onSuccesCreateList() {
    getIt<FavoriteListBloc>().add(
      GetListEvent(
        callback: (symbols) async {
          for (var i = 0; i < widget.popTimes; i++) {
            Navigator.of(context).pop();
          }
          PBottomSheet.showError(
            context,
            isSuccess: true,
            content: L10n.tr('favorite_list_created', args: [_controller.text]),
          );
        },
      ),
    );
  }
}
