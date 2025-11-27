import 'package:p_core/keys/navigator_keys.dart';

import '../buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/platform_utils.dart';

Future<void> showPDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? maximumDate,
  DateTime? minimumDate,
  bool includeTime = false,
  required ValueChanged<DateTime?> onChanged,
  String? cancelTitle,
  void Function()? onCancel,
  String? doneTitle,
}) async {
  initialDate ??= DateTime.now();
  maximumDate ??= DateTime(2100);
  minimumDate ??= DateTime(1900);

  if (initialDate.isAfter(maximumDate)) {
    initialDate = maximumDate;
  }

  if (initialDate.isBefore(minimumDate)) {
    initialDate = minimumDate;
  }

  KeyboardUtils.dismissKeyboard();
  if (PlatformUtils.isIos) {
    DateTime selected = initialDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return _buildBottomPicker(
          context: context,
          picker: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: context.pColorScheme.textPrimary,
                  fontSize: 22,
                ),
              ),
            ),
            child: Container(
              color: context.pColorScheme.backgroundColor,
              child: CupertinoDatePicker(
                backgroundColor: context.pColorScheme.backgroundColor,
                onDateTimeChanged: (DateTime newDate) {
                  selected = newDate;
                },
                initialDateTime: initialDate,
                maximumDate: maximumDate,
                minimumDate: minimumDate,
                maximumYear: maximumDate?.year,
                mode: includeTime ? CupertinoDatePickerMode.dateAndTime : CupertinoDatePickerMode.date,
              ),
            ),
          ),
          onDone: () => onChanged(selected),
          onCancel: onCancel,
          cancelTitle: cancelTitle,
          doneTitle: doneTitle,
        );
      },
    );
  } else {
    DateTime? date = await material.showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate,
      lastDate: maximumDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.pColorScheme.primary,
              onPrimary: Theme.of(context).dialogBackgroundColor,
              onSurface: context.pColorScheme.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.pColorScheme.textPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && includeTime) {
      final material.TimeOfDay? time = await material.showTimePicker(
        context: NavigatorKeys.navigatorKey.currentContext ?? context,
        initialTime: material.TimeOfDay.fromDateTime(initialDate),
      );
      if (time == null) {
        onChanged(null);
        return;
      } else {
        date = date.add(Duration(hours: time.hour, minutes: time.minute));
      }
    }

    onChanged(date);
  }
}

Future<void> showPTimePicker({
  required BuildContext context,
  material.TimeOfDay? initialTime,
  required ValueChanged<material.TimeOfDay?> onChanged,
  void Function()? onCancel,
  String? cancelTitle,
  String? doneTitle,
}) async {
  initialTime ??= material.TimeOfDay.now();

  KeyboardUtils.dismissKeyboard();

  if (PlatformUtils.isIos) {
    final DateTime now = DateTime.now();
    final DateTime time = DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute);
    DateTime selected = time;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return _buildBottomPicker(
          context: context,
          picker: CupertinoDatePicker(
            onDateTimeChanged: (DateTime newDate) {
              selected = newDate;
            },
            initialDateTime: time,
            mode: CupertinoDatePickerMode.time,
          ),
          onDone: () => onChanged(
            material.TimeOfDay.fromDateTime(selected),
          ),
          onCancel: onCancel,
          cancelTitle: cancelTitle,
          doneTitle: doneTitle,
        );
      },
    );
  } else {
    onChanged(
      await material.showTimePicker(
        context: context,
        initialTime: initialTime,
      ),
    );
  }
}

Widget _buildBottomPicker({
  required BuildContext context,
  required Widget picker,
  VoidCallback? onCancel,
  required VoidCallback onDone,
  String? cancelTitle,
  String? doneTitle,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 6.0),
    color: context.pColorScheme.backgroundColor,
    child: DefaultTextStyle(
      style: TextStyle(
        color: context.pColorScheme.textPrimary,
        fontSize: 22.0,
      ),
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PTextButton(
                    text: cancelTitle ?? '',
                    variant: PButtonVariant.error,
                    onPressed: () {
                      Navigator.pop(context);
                      if (onCancel != null) {
                        onCancel();
                      }
                    },
                  ),
                  PTextButton(
                    key: const Key(ButtonKeys.pickerDoneButton),
                    text: doneTitle ?? '',
                    onPressed: () {
                      Navigator.pop(context);
                      onDone();
                    },
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 150,
                child: picker,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<T?> showPBottomPicker<T>({
  String? title,
  String? message,
  String? cancelMessage,
  VoidCallback onCancel = PageNavigator.pop,
  required List<PickerAction> actions,
}) {
  KeyboardUtils.dismissKeyboard();
  if (PlatformUtils.isIos) {
    return showCupertinoModalPopup<T>(
      context: PageNavigator.globalContext!,
      builder: (BuildContext context) {
        return Theme(
          data: material.ThemeData.light(),
          child: CupertinoActionSheet(
            title: title != null ? Text(title) : null,
            message: message != null ? Text(message) : null,
            cancelButton: cancelMessage != null
                ? CupertinoActionSheetAction(
                    onPressed: onCancel,
                    child: Text(
                      cancelMessage,
                      style: const TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                  )
                : null,
            actions: actions
                .map(
                  (PickerAction? action) => CupertinoActionSheetAction(
                    onPressed: action?.action ?? () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: Grid.s),
                        if (action?.icon != null) Icon(action?.icon, color: context.pColorScheme.primary),
                        if (action?.text != null)
                          Expanded(
                            child: Text(
                              action!.text!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: context.pColorScheme.primary),
                            ),
                          ),
                        const SizedBox(width: 32),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  } else {
    return material.showModalBottomSheet<T>(
      context: PageNavigator.globalContext!,
      builder: (BuildContext context) {
        return Container(
          color: context.pColorScheme.backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: Grid.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: context.pColorScheme.textPrimary,
                    ),
                  ),
                ),
              const SizedBox(height: Grid.s),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: context.pColorScheme.lightHigh,
                    ),
                  ),
                ),
              const SizedBox(height: Grid.m),
              if (actions.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return material.InkWell(
                      onTap: actions[index].action,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Grid.s),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: Grid.m),
                            if (actions[index].icon != null)
                              Icon(
                                actions[index].icon,
                                color: context.pColorScheme.primary,
                              ),
                            if (actions[index].text != null) const SizedBox(width: Grid.s),
                            if (actions[index].text != null)
                              Text(
                                actions[index].text!,
                                style: TextStyle(color: context.pColorScheme.primary),
                              ),
                            const SizedBox(width: Grid.m),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const material.Divider(height: Grid.s);
                  },
                  itemCount: actions.length,
                ),
            ],
          ),
        );
      },
    );
  }
}

class PickerAction {
  final String? text;
  final IconData? icon;
  final VoidCallback? action;

  PickerAction({this.text, this.icon, this.action});
}
