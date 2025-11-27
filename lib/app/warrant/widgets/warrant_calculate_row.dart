import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class WarrantCalculateRow extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final String? prefixLabel;
  final double priceStep;
  final Function(double velue) onChanged;
  const WarrantCalculateRow({
    super.key,
    required this.title,
    required this.controller,
    required this.onChanged,
    required this.priceStep,
    this.prefixLabel,
  });

  @override
  State<WarrantCalculateRow> createState() => _WarrantCalculateRowState();
}

class _WarrantCalculateRowState extends State<WarrantCalculateRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.s + Grid.xs),
          child: SizedBox(
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    double value = MoneyUtils().fromReadableMoney(widget.controller.text);
                    value -= widget.priceStep;
                    widget.controller.text = MoneyUtils().readableMoney(value);
                    widget.onChanged(value);
                    setState(() {});
                  },
                  child: SvgPicture.asset(
                    ImagesPath.minus,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                      SizedBox(
                        height: 19,
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: widget.controller,
                            textAlign: TextAlign.center,
                            cursorHeight: 15,
                            style: context.pAppStyle.labelMed14textPrimary,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                prefix: Text(
                                  widget.prefixLabel ?? '',
                                  style: context.pAppStyle.labelMed14textPrimary,
                                )),
                            onChanged: (value) {
                              double value = MoneyUtils().fromReadableMoney(widget.controller.text);
                              widget.onChanged(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    double value = MoneyUtils().fromReadableMoney(widget.controller.text);
                    value += widget.priceStep;
                    widget.controller.text = MoneyUtils().readableMoney(value);
                    widget.onChanged(value);
                    setState(() {});
                  },
                  child: SvgPicture.asset(
                    ImagesPath.plus,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
