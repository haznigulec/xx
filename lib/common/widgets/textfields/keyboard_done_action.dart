import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class KeyboardDoneAction extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;
  final Function()? onDone;
  final bool? disableScroll;

  const KeyboardDoneAction({
    required this.child,
    super.key,
    required this.focusNode,
    this.onDone,
    this.disableScroll,
  });

  @override
  State<KeyboardDoneAction> createState() => _KeyboardDoneActionState();
}

class _KeyboardDoneActionState extends State<KeyboardDoneAction> {
  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: context.pColorScheme.secondary,
      keyboardSeparatorColor: context.pColorScheme.secondary,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: widget.focusNode,
          toolbarButtons: [
            (node) {
              return InkWell(
                onTap: () {
                  if (widget.onDone != null) {
                    widget.onDone!();
                  } else {
                    node.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: Grid.m),
                  child: Text(
                    L10n.tr('tamam'),
                    style: TextStyle(
                      color: context.pColorScheme.primary,
                      fontSize: Grid.m,
                    ),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      autoScroll: false,
      disableScroll: widget.disableScroll ?? false,
      config: _buildConfig(),
      child: Center(
        child: widget.child,
      ),
    );
  }
}
