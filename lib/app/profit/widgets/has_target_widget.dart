import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_state.dart';
import 'package:piapiri_v2/app/profit/model/customer_target_model.dart';
import 'package:piapiri_v2/app/profit/widgets/enter_target_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class HasTargetWidget extends StatefulWidget {
  final CustomerTargetModel customerTargetResponse;
  final double totalAmount;
  const HasTargetWidget({
    super.key,
    required this.customerTargetResponse,
    required this.totalAmount,
  });

  @override
  State<HasTargetWidget> createState() => _HasTargetWidgetState();
}

class _HasTargetWidgetState extends State<HasTargetWidget> {
  late ProfitBloc _profitBloc;

  @override
  initState() {
    _profitBloc = getIt<ProfitBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String targetDate = widget.customerTargetResponse.targetDate.toString().split('T')[0];
    double target = double.parse(
      widget.customerTargetResponse.target.toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.m,
        ),
        InkWell(
          onTap: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('update_profit_target'),
              child: EnterTargetWidget(
                date: DateTime.parse(targetDate),
                amount: target.toDouble(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.s,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  L10n.tr('profit_target'),
                  style: context.pAppStyle.labelMed14primary,
                ),
                SvgPicture.asset(
                  ImagesPath.pencil,
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        _currentBalanceWidget(),
        const SizedBox(
          height: Grid.s,
        ),
        _progressWidget(target),
        const SizedBox(
          height: Grid.s,
        ),
        _targetWidget(targetDate, target),
      ],
    );
  }

  Widget _currentBalanceWidget() {
    return PBlocBuilder<ProfitBloc, ProfitState>(
        bloc: _profitBloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    L10n.tr('your_current_balance'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ),
                Text(
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.totalAmount)}',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
          );
        });
  }

  Widget _progressWidget(num target) {
    return LinearProgressIndicator(
      minHeight: 7,
      color: context.pColorScheme.success,
      value: target == 0 ? 0 : widget.totalAmount / target,
      backgroundColor: context.pColorScheme.line,
      borderRadius: BorderRadius.circular(
        Grid.s,
      ),
    );
  }

  Widget _targetWidget(
    String targetDate,
    num targetPrice,
  ) {
    DateTime now = DateTime.now();
    bool isEnded = false;

    if (now.isAfter(DateTime.parse(targetDate))) {
      isEnded = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${DateTimeUtils.dateFormat(DateTime.parse(targetDate))} ${isEnded ? L10n.tr('your_dated_target_has_ended') : L10n.tr('your_dated_target')}',
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ),
          Text(
            '₺${MoneyUtils().readableMoney(targetPrice.toDouble())}',
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ],
      ),
    );
  }
}
