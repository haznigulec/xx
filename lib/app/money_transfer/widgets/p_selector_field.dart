import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';

class PSelectorField extends StatefulWidget {
  final String title;
  final Widget? subTitle;
  final List<DropdownModel> items;
  final DropdownModel? initializeValue;
  final Widget? itemWidget;
  final Function(DropdownModel value) onChanged;
  final AccountModel selectedAccount;
  const PSelectorField({
    super.key,
    required this.title,
    this.subTitle,
    required this.items,
    required this.onChanged,
    this.initializeValue,
    this.itemWidget,
    required this.selectedAccount,
  });

  @override
  State<PSelectorField> createState() => _PSelectorFieldState();
}

class _PSelectorFieldState extends State<PSelectorField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
        vertical: Grid.s + Grid.xs,
      ),
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            Grid.m,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: widget.subTitle != null ? Grid.s : 0,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              if (widget.subTitle != null) widget.subTitle!
            ],
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          if (widget.itemWidget != null) ...[
            widget.itemWidget!
          ] else ...[
            widget.items.length == 1
                ? Text(
                    widget.selectedAccount.accountId,
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : InkWell(
                    onTap: () {
                      PBottomSheet.show(
                        context,
                        title: widget.title,
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            return BottomsheetSelectTile(
                              title: item.name,
                              isSelected: widget.selectedAccount.accountId == item.name,
                              value: item,
                              onTap: (title, value) {
                                setState(() {
                                  widget.onChanged(value);

                                  router.maybePop();
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      spacing: Grid.xs,
                      children: [
                        Text(
                          widget.selectedAccount.accountId,
                          style: context.pAppStyle.labelMed14primary,
                        ),
                        SvgPicture.asset(
                          ImagesPath.chevron_down,
                          width: 15,
                          height: 15,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}
