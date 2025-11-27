import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class ShortcutButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  const ShortcutButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });
//Tek kelime mi var
  bool get isSingleWord => title.trim().split(' ').length == 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - (Grid.m * 2)) / 5,
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .12,
              padding: const EdgeInsets.all(
                Grid.s + Grid.xs,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.pColorScheme.card,
              ),
              child: SvgPicture.asset(
                imagePath,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final textStyle = context.pAppStyle.labelMed12textPrimary;
                final textSpan = TextSpan(
                  text: title,
                  style: textStyle,
                );

                // Metin ölçümü yapıyoruz
                final textPainter = TextPainter(
                  text: textSpan,
                  maxLines: isSingleWord ? 1 : 2,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                // Eğer metin sığmıyorsa font boyutunu küçültüyoruz
                double fontSize =
                    textStyle.fontSize ?? context.pAppStyle.labelMed14textPrimary.fontSize ?? Grid.m - Grid.xxs;
                while (textPainter.didExceedMaxLines && fontSize > Grid.s) {
                  fontSize -= 0.5;
                  textPainter.text = TextSpan(
                    text: title,
                    style: textStyle.copyWith(fontSize: fontSize),
                  );
                  textPainter.layout(maxWidth: constraints.maxWidth);
                }

                return Text(
                  title.replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  maxLines: isSingleWord ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelMed14textPrimary.copyWith(
                    fontSize: fontSize,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
