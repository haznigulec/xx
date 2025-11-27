import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnterTargetWidget extends StatefulWidget {
  final double? amount;
  final DateTime? date;
  const EnterTargetWidget({
    super.key,
    this.amount,
    this.date,
  });

  @override
  State<EnterTargetWidget> createState() => _EnterTargetWidgetState();
}

class _EnterTargetWidgetState extends State<EnterTargetWidget> {
  final TextEditingController _tcAmount = TextEditingController(text: '0');
  DateTime? _date;
  late ProfitBloc _profitBloc;

  @override
  void initState() {
    _profitBloc = getIt<ProfitBloc>();
    if (widget.amount != null) {
      _tcAmount.text = MoneyUtils().readableMoney(
        widget.amount ?? 0,
      );
    }
    if (widget.date != null) {
      _date = widget.date;
    }

    super.initState();
  }

  @override
  void dispose() {
    _date = null;
    _tcAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PValueTextfieldWidget(
          controller: _tcAmount,
          title: L10n.tr('tutar'),
          suffixText: CurrencyEnum.turkishLira.symbol,
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
              double amount = _tcAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_tcAmount.text);
              _tcAmount.text = MoneyUtils().readableMoney(amount);
            }
          },
          onTapPrice: () {
            if (MoneyUtils().fromReadableMoney(_tcAmount.text) == 0) {
              _tcAmount.text = '';
            }
          },
          onSubmitted: (value) {
            setState(() {
              _tcAmount.text = value;
              FocusScope.of(context).unfocus();
            });
          },
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
            vertical: Grid.l - Grid.xxs,
          ),
          decoration: BoxDecoration(
            color: context.pColorScheme.card,
            borderRadius: const BorderRadius.all(
              Radius.circular(Grid.m),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr('date'),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              InkWell(
                splashColor: context.pColorScheme.transparent,
                highlightColor: context.pColorScheme.transparent,
                onTap: () async {
                  await showPDatePicker(
                    context: context,
                    initialDate: _date,
                    cancelTitle: L10n.tr('iptal'),
                    doneTitle: L10n.tr('tamam'),
                    onChanged: (selectedDate) {
                      if (selectedDate == null) return;

                      setState(() {
                        _date = selectedDate;
                      });
                    },
                  );
                },
                child: Row(
                  children: [
                    Text(
                      _date != null ? _date!.formatDayMonthYearDot() : L10n.tr('target_date'),
                      style: context.pAppStyle.labelReg14textTeritary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    SvgPicture.asset(
                      ImagesPath.calendar,
                      width: 15,
                      height: 15,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        PButton(
          text: L10n.tr('kaydet'),
          fillParentWidth: true,
          onPressed: _date == null || _tcAmount.text.isEmpty || _tcAmount.text == '0' || _tcAmount.text == '0,00'
              ? null
              : () async {
                  _profitBloc.add(
                    SetCustomerTargetEvent(
                      target: MoneyUtils().fromReadableMoney(_tcAmount.text),
                      targetDate: _date!,
                      onSuccess: () async {
                        _profitBloc.add(
                          GetCustomerTargetEvent(),
                        );

                        await router.maybePop();
                      },
                    ),
                  );
                },
        ),
      ],
    );
  }
}
