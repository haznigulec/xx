import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'model/sliding_segment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SlidingSegment extends StatefulWidget {
  final List<PSlidingSegmentModel> segmentList;
  final Function(int) onValueChanged;
  final double? slidingSegmentWidth;
  final double? slidingSegmentRadius;
  final Color? backgroundColor;
  final Color? selectedTextColor;
  final Color? unSelectedTextColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unSelectedTextStyle;
  final Color? dividerColor;

  final int? initialSelectedSegment;

  const SlidingSegment({
    super.key,
    required this.segmentList,
    this.slidingSegmentWidth,
    required this.onValueChanged,
    this.slidingSegmentRadius = 24,
    this.backgroundColor,
    this.selectedTextColor,
    this.unSelectedTextColor,
    this.selectedTextStyle,
    this.unSelectedTextStyle,
    this.initialSelectedSegment,
    this.dividerColor,
  });

  @override
  State<SlidingSegment> createState() => _SlidingSegmentState();
}

class _SlidingSegmentState extends State<SlidingSegment> {
  int _selectedSegment = 0;

  @override
  void initState() {
    _selectedSegment = widget.initialSelectedSegment ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CustomSlidingSegmentedControl<int>(
        initialValue: widget.initialSelectedSegment,
        fixedWidth: (widget.slidingSegmentWidth ?? MediaQuery.of(context).size.width * .9) / widget.segmentList.length,
        isShowDivider: true,
        padding: 2,
        customSegmentSettings: CustomSegmentSettings(),
        dividerSettings: DividerSettings(
          indent: 10,
          endIndent: 10,
          decoration: BoxDecoration(
            color: widget.dividerColor ?? context.pColorScheme.textTeritary,
          ),
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? context.pColorScheme.lightHigh,
          borderRadius: BorderRadius.circular(
            widget.slidingSegmentRadius!,
          ),
        ),
        thumbDecoration: BoxDecoration(
          color: widget.segmentList[_selectedSegment].segmentColor,
          borderRadius: BorderRadius.circular(
            widget.slidingSegmentRadius!,
          ),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        children: {
          for (var i = 0; i < widget.segmentList.length; i++)
            i: widget.segmentList[i].showCase != null
                ? ShowCaseView(
                    showCase: widget.segmentList[i].showCase!,
                    targetPadding: const EdgeInsets.symmetric(
                      vertical: Grid.xs,
                      horizontal: Grid.l,
                    ),
                    targetRadius: BorderRadius.circular(
                      Grid.m,
                    ),
                    child: Text(
                      widget.segmentList[i].segmentTitle,
                      style: _selectedSegment == i
                          ? widget.selectedTextStyle ??
                              context.pAppStyle.interRegularBase.copyWith(
                                fontSize: Grid.m,
                                color: widget.selectedTextColor ?? context.pColorScheme.primary,
                              )
                          : widget.unSelectedTextStyle ??
                              context.pAppStyle.interRegularBase.copyWith(
                                fontSize: Grid.m,
                                color: widget.unSelectedTextColor ?? context.pColorScheme.textSecondary,
                              ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.segmentList[i].imagePath != null) ...[
                        SvgPicture.asset(
                          widget.segmentList[i].imagePath!,
                          colorFilter: ColorFilter.mode(
                            _selectedSegment == i
                                ? (widget.selectedTextColor ?? context.pColorScheme.primary)
                                : widget.unSelectedTextColor ?? context.pColorScheme.textSecondary,
                            BlendMode.srcIn,
                          ),
                          width: Grid.m + Grid.xxs,
                          height: Grid.m + Grid.xxs,
                        ),
                        const SizedBox(
                          width: Grid.xs,
                        ),
                      ],
                      Text(
                        widget.segmentList[i].segmentTitle,
                        style: _selectedSegment == i
                            ? widget.selectedTextStyle ??
                                context.pAppStyle.interRegularBase.copyWith(
                                  fontSize: Grid.m,
                                  color: widget.selectedTextColor ?? context.pColorScheme.primary,
                                )
                            : widget.unSelectedTextStyle ??
                                context.pAppStyle.interRegularBase.copyWith(
                                  fontSize: Grid.m,
                                  color: widget.unSelectedTextColor ?? context.pColorScheme.textSecondary,
                                ),
                      ),
                    ],
                  ),
        },
        onValueChanged: (v) {
          setState(() {
            _selectedSegment = v;
          });
          widget.onValueChanged(v);
        },
      ),
    );
  }
}
