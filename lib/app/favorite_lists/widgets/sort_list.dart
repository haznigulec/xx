import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SortList extends StatefulWidget {
  final List<FavoriteListItem> items;
  final List<FundDetailModel> tefasSymbolDetails;
  final Function(List<FavoriteListItem> items) onApprove;
  const SortList({
    super.key,
    required this.items,
    required this.tefasSymbolDetails,
    required this.onApprove,
  });

  @override
  State<SortList> createState() => _SortListState();
}

class _SortListState extends State<SortList> {
  final List<FavoriteListItem> _items = [];

  @override
  initState() {
    _items.addAll(widget.items);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: ReorderableListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            proxyDecorator: (child, index, animation) {
              return Material(
                color: Colors.transparent, // Gölgeyi kaldırır
                child: child,
              );
            },
            itemCount: _items.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final FavoriteListItem instrumentName = _items.removeAt(oldIndex);
                _items.insert(newIndex, instrumentName);
              });
            },
            itemBuilder: (context, index) {
              FundDetailModel? fundDetailModel =
                  widget.tefasSymbolDetails.firstWhereOrNull((element) => element.code == _items[index].symbol);
              return GestureDetector(
                key: ValueKey('CUSTOM_SORT_${_items[index].symbol}'),
                onTap: () {},
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.m + Grid.xs,
                      ),
                      child: PSymbolTile(
                        variant: PSymbolVariant.search,
                        title: _items[index].symbol,
                        subTitle:
                            '${fundDetailModel != null ? fundDetailModel.founder : _items[index].description} · ${L10n.tr(_items[index].symbolType.filter?.localization ?? '')}',
                        symbolName: _items[index].symbolType == SymbolTypes.warrant ||
                                _items[index].symbolType == SymbolTypes.option ||
                                _items[index].symbolType == SymbolTypes.future
                            ? _items[index].underlyingName
                            : _items[index].symbolType == SymbolTypes.fund
                                ? fundDetailModel?.institutionCode
                                : _items[index].symbol,
                        symbolType: _items[index].symbolType,
                        trailingWidget: SvgPicture.asset(
                          ImagesPath.drag,
                          width: 15,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    if (index != _items.length - 1) const PDivider()
                  ],
                ),
              );
            },
          ),
        ),
        OrderApprovementButtons(
          onPressedApprove: () => widget.onApprove(_items),
        ),
      ],
    );
  }
}
