import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class GeneralRichText extends StatelessWidget {
  final String textSpan1;
  final String textSpan2;
  final TextStyle? textStyle;
  const GeneralRichText({
    super.key,
    required this.textSpan1,
    required this.textSpan2,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: textSpan1,
            style: textStyle ??
                context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
          ),
          TextSpan(
            text: ' $textSpan2',
            style: textStyle?.copyWith(
                  color: context.pColorScheme.primary,
                ) ??
                context.pAppStyle.labelMed16primary,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                router.push(
                  AuthRoute(),
                );
              },
          ),
        ],
      ),
    );
  }
}
