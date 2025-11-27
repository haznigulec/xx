import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/string_utils.dart';

enum PLozengeSize { small, medium }

enum PLozengeVariant { success, warning, critical, info, neutral }

enum PLozengeEmphasis { regular, high }

class PLozenge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color? textColor;
  final PLozengeSize size;
  final PLozengeEmphasis emphasis;
  final bool withIcon;
  final double maxWidth;
  final TextOverflow textOverflow;

  const PLozenge.withColor({
    super.key,
    required this.text,
    required this.backgroundColor,
    PLozengeSize? size,
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
  })  : size = size ?? PLozengeSize.medium,
        emphasis = PLozengeEmphasis.regular,
        withIcon = false,
        maxWidth = 200;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        height: size == PLozengeSize.small ? 18 : 24,
        padding: const EdgeInsets.symmetric(horizontal: Grid.s),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Grid.xs),
        ),
        child: Center(
          widthFactor: 1,
          child: LayoutBuilder(
            builder: (context, s) {
              final TextSpan span = TextSpan(
                text: text,
                style: size == PLozengeSize.small
                    ? context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.s + Grid.xs)
                    : context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.s + Grid.xs + Grid.xxs),
              );
              final TextPainter tp = TextPainter(
                maxLines: 1,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                text: span,
              );
              tp.layout(maxWidth: s.maxWidth);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      StringUtils.capitalize(text),
                      style: size == PLozengeSize.small
                          ? context.pAppStyle.interRegularBase.copyWith(
                              fontSize: tp.didExceedMaxLines ? 11 : 12,
                              color: textColor ?? context.pColorScheme.textPrimary,
                            )
                          : context.pAppStyle.interRegularBase.copyWith(
                              fontSize: tp.didExceedMaxLines ? 11 : 12,
                              color: textColor ?? context.pColorScheme.textPrimary,
                            ),
                      overflow: textOverflow,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
