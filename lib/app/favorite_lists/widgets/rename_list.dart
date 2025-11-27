import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RenameList extends StatefulWidget {
  const RenameList({
    super.key,
  });

  @override
  State<RenameList> createState() => _RenameListState();
}

class _RenameListState extends State<RenameList> {
  String _listName = '';
  final TextEditingController _controller = TextEditingController();
  late FavoriteListBloc _favoriteListBloc;

  @override
  void initState() {
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _listName = _favoriteListBloc.state.selectedList?.name ?? '';
    _controller.text = _listName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: _favoriteListBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.l,
            ),
            SvgPicture.asset(
              ImagesPath.favorites,
              width: Grid.l,
            ),
            const SizedBox(
              height: Grid.l,
            ),
            PTextField(
              autoFocus: true,
              errorText: _controller.text.length >= 20 ? L10n.tr('max_20_char') : null,
              maxLength: 20,
              labelWidget: Text(
                L10n.tr('list_name'),
                style: context.pAppStyle.labelMed16textSecondary,
              ),
              onChanged: (value) {
                setState(() {});
              },
              controller: _controller,
            ),
            const SizedBox(
              height: Grid.l + Grid.s,
            ),
            PButton(
              text: L10n.tr('kaydet'),
              fillParentWidth: true,
              sizeType: PButtonSize.medium,
              variant: PButtonVariant.brand,
              onPressed: _controller.text.trim().isEmpty || _controller.text == _listName
                  ? null
                  : () {
                      _favoriteListBloc.add(
                        UpdateListEvent(
                          name: _controller.text,
                          items: (state.selectedList?.favoriteListItems ?? [])
                              .map((e) => SymbolModel(name: e.symbol, typeCode: e.symbolType.dbKey))
                              .toList(),
                          id: state.selectedList?.id ?? 0,
                          sortingEnum: state.selectedList?.sortingEnum ?? FavoriteSortingEnum.alphabetic,
                          onSuccess: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            PBottomSheet.show(
                              context,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      ImagesPath.checkCircle,
                                      width: Grid.xxl,
                                      height: Grid.xxl,
                                      colorFilter: ColorFilter.mode(
                                        context.pColorScheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: Grid.l,
                                    ),
                                    Text(
                                      L10n.tr(
                                        'favorite.renamed',
                                        args: [state.selectedList?.name ?? ''],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
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
      },
    );
  }
}
