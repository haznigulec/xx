import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/model/condition_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AlarmSlidingPercentage extends StatefulWidget {
  final TextEditingController controller;
  final double lastPrice;
  final Function(double) goalPrice;
  const AlarmSlidingPercentage({
    super.key,
    required this.controller,
    required this.lastPrice,
    required this.goalPrice,
  });

  @override
  State<AlarmSlidingPercentage> createState() => _AlarmSlidingPercentageState();
}

class _AlarmSlidingPercentageState extends State<AlarmSlidingPercentage> {
  TextEditingController _priceChangeTC = TextEditingController();
  int _priceChange = 0;
  final List<int> _percentageRage = [0, 2, 4, 6, 8, 10];
  int _selectedRage = -1;
  double _alarmPrice = 0;
  ConditionEnum _selectedCondition = ConditionEnum.greatherThen;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _priceChangeTC = widget.controller;
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _priceChange = 0;

    _priceChangeTC.text = _priceChange.toString();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Grid.m,
      children: [
        PValueTextfieldWidget(
          key: const ValueKey('sliding_change'),
          controller: _priceChangeTC,
          focusNode: _focusNode,
          title: L10n.tr('price_change'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            AppInputFormatters.decimalFormatter(
              maxDigitAfterSeparator: 0,
            ),
          ],
          prefixText:
              '${_selectedCondition != ConditionEnum.greatherThen && _priceChangeTC.text != '0' && _priceChangeTC.text != '0,00' ? '-' : ''}%',
          prefixStyle: context.pAppStyle.interMediumBase.copyWith(
            fontSize: Grid.m + Grid.xxs,
            color: _selectedCondition == ConditionEnum.greatherThen
                ? context.pColorScheme.success
                : context.pColorScheme.critical,
          ),
          valueTextStyle: context.pAppStyle.interMediumBase.copyWith(
            fontSize: Grid.m + Grid.xxs,
            color: _selectedCondition == ConditionEnum.greatherThen
                ? context.pColorScheme.success
                : context.pColorScheme.critical,
          ),
          subTitleTopPadding: Grid.s,
          subTitle: InkWell(
            onTap: () {
              setState(() {
                if (_selectedCondition == ConditionEnum.greatherThen) {
                  _selectedCondition = ConditionEnum.dollar;
                } else {
                  _selectedCondition = ConditionEnum.greatherThen;
                }
              });
            },
            child: Row(
              children: [
                Text(
                  L10n.tr(_selectedCondition.localizationKey),
                  style: context.pAppStyle.labelReg12textSecondary,
                ),
                SvgPicture.asset(
                  ImagesPath.chevron_list,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textSecondary,
                    BlendMode.srcIn,
                  ),
                  width: 12,
                  height: 12,
                ),
              ],
            ),
          ),
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              double amount = _priceChangeTC.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceChangeTC.text);
              _priceChangeTC.text = MoneyUtils().readableMoney(
                amount,
                pattern: '#,##0',
              );
            }
          },
          onChanged: (deger) {
            if (!mounted) return;

            setState(() {
              _priceChangeTC.text = deger;
            });
          },
          onSubmitted: (value) {
            setState(() {
              _priceChange = MoneyUtils().fromReadableMoney(value).toInt();

              _priceChangeTC.text = _priceChange.toString();

              if (_selectedCondition == ConditionEnum.greatherThen) {
                _alarmPrice = widget.lastPrice / 100 * _priceChange + widget.lastPrice;
              } else {
                _alarmPrice = widget.lastPrice * (1 - _priceChange / 100);
              }

              widget.goalPrice(_alarmPrice);
              _selectedRage = -1;

              FocusScope.of(context).unfocus();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _percentageRage.asMap().entries.map((entry) {
            int index = entry.key;
            int value = entry.value;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedRage = index;

                  if (_selectedCondition == ConditionEnum.greatherThen) {
                    _alarmPrice = widget.lastPrice / 100 * _percentageRage[index] + widget.lastPrice;
                  } else {
                    _alarmPrice = widget.lastPrice * (1 - _percentageRage[index] / 100);
                  }

                  _priceChange = _percentageRage[index];
                  _priceChangeTC.text = _priceChange.toString();
                  widget.goalPrice(_alarmPrice);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedRage == index ? context.pColorScheme.card : context.pColorScheme.transparent,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Grid.m),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.s + Grid.xs,
                    vertical: Grid.xs,
                  ),
                  child: Text(
                    '${_selectedCondition == ConditionEnum.greatherThen || index == 0 ? '%' : '-%'}$value',
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m - Grid.xxs,
                      color: _selectedCondition == ConditionEnum.greatherThen
                          ? context.pColorScheme.success
                          : context.pColorScheme.critical,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10n.tr('alarm_price'),
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Text(
              widget.lastPrice == 0
                  ? '-'
                  : '₺${MoneyUtils().readableMoney(
                      _alarmPrice,
                      pattern: _alarmPrice < 1 && _alarmPrice > 0 ? '#,##0.0000' : '#,##0.00',
                    )}',
              style: context.pAppStyle.labelMed18textPrimary,
            ),
          ],
        ),
      ],
    );
  }
}
