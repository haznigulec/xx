import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/dropdown_model.dart';

class SettingsBottomsheetTile<T> extends StatefulWidget {
  final String title;
  final List<DropdownModel> items;
  final T selectedValue;
  final Function(T value) onSelect;
  const SettingsBottomsheetTile({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  State<SettingsBottomsheetTile<T>> createState() => _SettingsBottomsheetTileState<T>();
}

class _SettingsBottomsheetTileState<T> extends State<SettingsBottomsheetTile<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () {
        PBottomSheet.show(context,
            title: widget.title,
            titlePadding: const EdgeInsets.only(
              top: Grid.m,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: ListView.separated(
                itemCount: widget.items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BottomsheetSelectTile(
                    title: widget.items[index].name,
                    value: widget.items[index].value,
                    isSelected: widget.items[index].value == widget.selectedValue,
                    onTap: (_, value) {
                      router.maybePop();
                      widget.onSelect(value);
                    },
                  );
                },
                separatorBuilder: (context, index) => const PDivider(),
              ),
            ));
      },
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: context.pAppStyle.labelMed12textSecondary.copyWith(
                height: 0.7,
              ),
            ),
            const SizedBox(
              height: Grid.xs,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.items.firstWhere((element) => element.value == widget.selectedValue).name,
                  style: context.pAppStyle.labelMed16textPrimary,
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_down,
                  width: 17,
                  height: 17,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Grid.s,
            ),
            PDivider(
              color: context.pColorScheme.textQuaternary,
            ),
          ],
        ),
      ),
    );
  }
}
