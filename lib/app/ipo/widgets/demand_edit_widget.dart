import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

class DemandEdit extends StatefulWidget {
  final String initialValue;
  final Function(String) onFieldChanged;
  final Function() onEditingComplete;
  final bool enabled;

  const DemandEdit({
    super.key,
    required this.initialValue,
    required this.onFieldChanged,
    required this.onEditingComplete,
    required this.enabled,
  });

  @override
  State<StatefulWidget> createState() => _DemandEditState();
}

class _DemandEditState extends State<DemandEdit> {
  late TextEditingController _editingController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _editingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Grid.xxs,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 55,
          ),
          child: IntrinsicWidth(
            child: KeyboardDoneAction(
              focusNode: _focusNode,
              child: TextField(
                controller: _editingController,
                showCursor: true,
                textAlign: TextAlign.end,
                focusNode: _focusNode,
                enabled: widget.enabled,
                onChanged: widget.onFieldChanged,
                onSubmitted: widget.onFieldChanged,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,\-]')),
                ],
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  widget.onEditingComplete();
                },
                onTap: () {
                  _editingController.text = '';
                },
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color: widget.enabled ? context.pColorScheme.primary : context.pColorScheme.textTeritary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  suffixText: CurrencyEnum.turkishLira.symbol,
                  suffixStyle: context.pAppStyle.labelMed14primary.copyWith(
                    color: widget.enabled ? context.pColorScheme.primary : context.pColorScheme.textTeritary,
                    letterSpacing: 0,
                  ),
                  fillColor: context.pColorScheme.card,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Grid.s + Grid.s,
                    vertical: 7,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: context.pColorScheme.transparent,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: context.pColorScheme.transparent,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
