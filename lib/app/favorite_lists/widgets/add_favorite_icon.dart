import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

/// Sembolu favorilere eklemek icin kullanilan icon
class AddFavoriteIcon extends StatefulWidget {
  final String symbolCode;
  final SymbolTypes symbolType;

  const AddFavoriteIcon({
    super.key,
    required this.symbolCode,
    required this.symbolType,
  });

  @override
  State<AddFavoriteIcon> createState() => _AddFavoriteIconState();
}

class _AddFavoriteIconState extends State<AddFavoriteIcon> {
  late FavoriteListBloc _favoriteListBloc;

  @override
  void initState() {
    _favoriteListBloc = getIt<FavoriteListBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoriteListBloc, FavoriteListState, List<FavoriteList>>(
      bloc: _favoriteListBloc,
      selector: (state) => state.watchList,
      builder: (context, watchList) {
        bool isFavorite = watchList.any(
          (element) => element.favoriteListItems.any(
            (e) => e.symbol == widget.symbolCode && e.symbolType == widget.symbolType,
          ),
        );

        return InkWrapper(
          child: SvgPicture.asset(
            isFavorite ? ImagesPath.star_full : ImagesPath.star,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isFavorite ? context.pColorScheme.primary : context.pColorScheme.iconPrimary,
              BlendMode.srcIn,
            ),
          ),
          onTap: () {
            FavoriteListUtils().toggleFavorite(
              context,
              widget.symbolCode,
              widget.symbolType,
            );
          },
        );
      },
    );
  }
}
