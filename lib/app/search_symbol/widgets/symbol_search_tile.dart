import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchTile extends StatefulWidget {
  final SymbolModel symbol;
  final void Function(SymbolModel symbol) onTapSymbol;
  final bool isSelected;
  final bool isCheckbox;
  final double horizontalPadding;

  const SymbolSearchTile({
    super.key,
    required this.symbol,
    required this.onTapSymbol,
    required this.isSelected,
    this.isCheckbox = false,
    this.horizontalPadding = 0,
  });

  @override
  State<SymbolSearchTile> createState() => _SymbolSearchTileState();
}

class _SymbolSearchTileState extends State<SymbolSearchTile> {
  late SymbolTypes _symbolTypes;
  late AuthBloc _authBloc;
  late FavoriteListBloc _favoriteListBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _symbolTypes = stringToSymbolType(widget.symbol.typeCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapSymbol(widget.symbol),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Grid.m + Grid.xs,
              horizontal: widget.horizontalPadding,
            ),
            child: PSymbolTile(
              variant: PSymbolVariant.search,
              title: widget.symbol.name,
              subTitle: '${widget.symbol.description} · ${getDescription()}',
              symbolName: _symbolTypes == SymbolTypes.warrant ||
                      _symbolTypes == SymbolTypes.option ||
                      _symbolTypes == SymbolTypes.future ||
                      _symbolTypes == SymbolTypes.fund
                  ? widget.symbol.underlyingName
                  : widget.symbol.name,
              symbolType: _symbolTypes,
              trailingWidget: widget.isCheckbox
                  ? InkWell(
                      onTap: () => widget.onTapSymbol(widget.symbol),
                      child: IgnorePointer(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: PCheckbox(
                            value: widget.isSelected,
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                    )
                  : _authBloc.state.isLoggedIn
                      ? _addFavouriteWidget()
                      : const SizedBox(),
            ),
          ),
          const PDivider()
        ],
      ),
    );
  }

  Widget _addFavouriteWidget() {
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: _favoriteListBloc,
      builder: (context, state) {
        bool isFavourite = FavoriteListUtils().isFavorite(widget.symbol.name, _symbolTypes);
        return InkWell(
          child: SvgPicture.asset(
            height: 24,
            width: 24,
            isFavourite ? ImagesPath.star_full : ImagesPath.star,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          onTap: () => FavoriteListUtils().toggleFavorite(
            context,
            widget.symbol.name,
            _symbolTypes,
          ),
        );
      },
    );
  }

  String getDescription() {
    if (_symbolTypes != SymbolTypes.parity) {
      return L10n.tr(_symbolTypes.filter?.localization ?? '');
    }
    bool isPreciousMetal = SymbolSearchUtils.isPreciousMetal(widget.symbol);
    if (isPreciousMetal) {
      return L10n.tr(SymbolSearchFilterEnum.preciousMetals.localization);
    }
    return L10n.tr(SymbolSearchFilterEnum.parity.localization);
  }
}
