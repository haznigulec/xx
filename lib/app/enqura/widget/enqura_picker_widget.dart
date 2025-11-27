import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/textfields/text_field.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_picker_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraPickerWidget extends StatefulWidget {
  const EnquraPickerWidget({
    required this.pickerModel,
    required this.onSelectionChanged,
    super.key,
  });

  final EnquraPickerModel pickerModel;
  final Function(EnquraPickerModel) onSelectionChanged;

  @override
  State<EnquraPickerWidget> createState() => _EnquraPickerWidgetState();
}

class _EnquraPickerWidgetState extends State<EnquraPickerWidget> {
  late List<ItemListModel> _selectableItems;
  late ItemListModel? _listValue;
  late final TextEditingController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _selectableItems = widget.pickerModel.selectableItems;
    _listValue = widget.pickerModel.listValue;
    _controller = TextEditingController(
      text: _listValue?.key ?? L10n.tr('choose'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.m + Grid.xs,
      ),
      child: InkWell(
        onTap: () {
          PBottomSheet.show(
            context,
            title: L10n.tr(widget.pickerModel.label),
            titlePadding: const EdgeInsets.only(
              top: Grid.m,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: RawScrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thumbColor: context.pColorScheme.iconPrimary,
                thickness: 2.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: _selectableItems.length,
                  physics: const ScrollPhysics(),
                  separatorBuilder: (context, i) => const PDivider(),
                  itemBuilder: (context, i) {
                    final option = _selectableItems[i];
                    return BottomsheetSelectTile(
                      title: option.key,
                      isSelected: _listValue != null && _listValue!.key == option.key,
                      value: option.value,
                      onTap: (title, value) {
                        Navigator.pop(context);
                        setState(
                          () {
                            _listValue = option;
                            _controller.text = option.key;
                          },
                        );
                        widget.pickerModel.listValue = _listValue;
                        widget.onSelectionChanged.call(widget.pickerModel);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
        child: PTextField(
          label: L10n.tr(widget.pickerModel.label),
          labelColor: context.pColorScheme.textSecondary,
          floatingLabelSize: Grid.m,
          textStyle: _listValue == null
              ? context.pAppStyle.labelMed16textPrimary.copyWith(
                  color: context.pColorScheme.primary,
                )
              : context.pAppStyle.labelMed16textPrimary,
          controller: _controller,
          hasText: _listValue != null,
          enabled: false,
          suffixWidget: Transform.scale(
            scale: 0.4,
            child: SvgPicture.asset(
              ImagesPath.chevron_down,
              width: Grid.m,
              height: Grid.m,
              colorFilter: ColorFilter.mode(
                _listValue != null ? context.pColorScheme.textPrimary : context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
