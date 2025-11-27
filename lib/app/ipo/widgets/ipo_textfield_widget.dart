import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';

class IpoTextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool enable;
  final String hintText;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onFieldChanged;
  final Function()? onTapAction;
  final List<TextInputFormatter>? textInputFormatter;
  final FocusNode? focusNode;
  const IpoTextFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.enable,
    required this.hintText,
    this.onFieldSubmitted,
    this.onFieldChanged,
    this.onTapAction,
    this.textInputFormatter,
    this.focusNode,
  });

  @override
  State<IpoTextFieldWidget> createState() => _IpoTextFieldWidgetState();
}

class _IpoTextFieldWidgetState extends State<IpoTextFieldWidget> {
  late FocusNode _focusNode;

  @override
  initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.pColorScheme.transparent,
      padding: const EdgeInsets.all(
        Grid.s,
      ),
      height: inputComponentHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontSize: 14,
                ),
          ),
          SizedBox(
            height: 38,
            child: KeyboardDoneAction(
              focusNode: _focusNode,
              child: TextField(
                showCursor: true,
                onTap: () {
                  widget.onTapAction?.call();
                },
                onTapAlwaysCalled: true,
                enabled: widget.enable,
                focusNode: _focusNode,
                textAlign: TextAlign.right,
                controller: widget.controller,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: widget.enable
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).unselectedWidgetColor,
                      fontSize: 14,
                    ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: widget.textInputFormatter ?? [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  fillColor: context.pColorScheme.transparent,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 12,
                      ),
                ),
                onChanged: widget.onFieldChanged,
                onSubmitted: widget.onFieldSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
