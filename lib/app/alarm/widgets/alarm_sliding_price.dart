import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AlarmSlidingPrice extends StatefulWidget {
  final TextEditingController controller;
  final double lastPrice;
  final Function(double) goalPrice;
  final String currencySymbol;
  const AlarmSlidingPrice({
    super.key,
    required this.controller,
    required this.lastPrice,
    required this.goalPrice,
    required this.currencySymbol,
  });

  @override
  State<AlarmSlidingPrice> createState() => _AlarmSlidingPriceState();
}

class _AlarmSlidingPriceState extends State<AlarmSlidingPrice> {
  TextEditingController _askingPriceUnitTC = TextEditingController();
  double _alarmPrice = 0.0;
  int _change = 0;

  @override
  void initState() {
    _askingPriceUnitTC = widget.controller;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PValueTextfieldWidget(
          key: const ValueKey('sliding_price'),
          controller: _askingPriceUnitTC,
          title: L10n.tr('alarm_price'),
          suffixText: widget.currencySymbol,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            AppInputFormatters.decimalFormatter(
              maxDigitAfterSeparator: 2,
            ),
          ],
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              double amount =
                  _askingPriceUnitTC.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_askingPriceUnitTC.text);
              _askingPriceUnitTC.text = MoneyUtils().readableMoney(amount);
            }
          },
          onTapPrice: () {
            if (_askingPriceUnitTC.text == '0' || _askingPriceUnitTC.text == '0,00') {
              _askingPriceUnitTC.text = '';
            }
          },
          onChanged: (deger) {
            if (!mounted) return;

            setState(() {
              _alarmPrice = MoneyUtils().fromReadableMoney(deger);
            });
          },
          onSubmitted: (value) {
            setState(() {
              _alarmPrice = MoneyUtils().fromReadableMoney(value);

              _askingPriceUnitTC.text = MoneyUtils().readableMoney(_alarmPrice);

              if (widget.lastPrice != 0) {
                _change = (((_alarmPrice - widget.lastPrice) / widget.lastPrice) * 100).toInt();
              }

              widget.goalPrice(_alarmPrice);
              FocusScope.of(context).unfocus();
            });
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
        _changeWidget(),
      ],
    );
  }

  Widget _changeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          L10n.tr('change'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        if (widget.lastPrice != 0 && _change != 0)
          SvgPicture.asset(
            _change > 0 ? ImagesPath.trending_up : ImagesPath.trending_down,
            width: 19,
            height: 19,
            colorFilter: ColorFilter.mode(
              _change > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
              BlendMode.srcIn,
            ),
          ),
        const SizedBox(
          width: Grid.xxs,
        ),
        Text(
          widget.lastPrice == 0 ? '-' : '${_change < 0 ? '-' : ''}%${_change.toString().replaceAll('-', '')}',
          style: context.pAppStyle.interMediumBase.copyWith(
            fontSize: Grid.m + Grid.xxs,
            color: _change == 0
                ? context.pColorScheme.textPrimary
                : _change > 0
                    ? context.pColorScheme.success
                    : context.pColorScheme.critical,
          ),
        ),
      ],
    );
  }
}
