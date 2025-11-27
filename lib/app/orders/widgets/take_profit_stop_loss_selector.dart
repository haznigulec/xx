import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_price_textfield.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TakeProfitStopLossSelector extends StatefulWidget {
  final MarketListModel? marketListModel;
  final FocusNode? slFocusNode;
  final FocusNode? tpFocusNode;
  final double? initialSlPrice;
  final double? initialTpPrice;
  final bool showValidityDate;
  final DateTime initialValidityDate;
  final TextEditingController? profitController;
  final TextEditingController? lossController;
  final Function({double? stopLoss, double? takeProfit, DateTime? validityDate}) onChange;
  final Function(GlobalKey) onTapPrice;
  final Color? fieldColor;
  final OrderActionTypeEnum action;
  final double currentPrice;
  final Function({double? takeProfit, double? stopLoss}) onTPSLChanged;
  final String? transactionExtId;
  final String accountId;

  const TakeProfitStopLossSelector({
    super.key,
    required this.onTapPrice,
    this.slFocusNode,
    this.tpFocusNode,
    this.initialSlPrice,
    this.initialTpPrice,
    this.showValidityDate = true,
    required this.initialValidityDate,
    this.profitController,
    this.lossController,
    required this.onChange,
    required this.marketListModel,
    this.fieldColor,
    required this.action,
    required this.currentPrice,
    required this.onTPSLChanged,
    this.transactionExtId,
    required this.accountId,
  });

  @override
  State<TakeProfitStopLossSelector> createState() => _TakeProfitStopLossSelectorState();
}

class _TakeProfitStopLossSelectorState extends State<TakeProfitStopLossSelector> {
  late DateTime _validityDate;
  late TextEditingController _profitController;
  late TextEditingController _lossController;
  final GlobalKey _profitKey = GlobalKey();
  final GlobalKey _lossKey = GlobalKey();
  final OrdersBloc _ordersBloc = getIt<OrdersBloc>();

  @override
  void initState() {
    super.initState();
    _profitController = widget.profitController ?? TextEditingController(text: '0.0');
    _lossController = widget.lossController ?? TextEditingController(text: '0.0');
    _profitController.text = MoneyUtils().readableMoney(widget.initialTpPrice ?? 0);
    _lossController.text = MoneyUtils().readableMoney(widget.initialSlPrice ?? 0);
    _validityDate = widget.initialValidityDate;
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      listenWhen: (previous, current) =>
          previous.newOrder.stopLossPrice != current.newOrder.stopLossPrice ||
          previous.newOrder.takeProfitPrice != current.newOrder.takeProfitPrice,
      listener: (context, state) {
        _profitController.text = MoneyUtils().readableMoney(state.newOrder.takeProfitPrice ?? 0);
        _lossController.text = MoneyUtils().readableMoney(state.newOrder.stopLossPrice ?? 0);
      },
      builder: (context, state) {
        return Column(
          children: [
            PPriceTextfield(
              key: _profitKey,
              title: L10n.tr('kar_al'),
              controller: _profitController,
              action: widget.action,
              focusNode: widget.tpFocusNode,
              marketListModel: widget.marketListModel,
              currentPrice: widget.currentPrice,
              onTapPrice: () {
                widget.onTapPrice(_lossKey);
              },
              onPriceChanged: (price) {
                setState(() {
                  widget.onTPSLChanged(
                    takeProfit: price,
                  );

                  if (widget.action == OrderActionTypeEnum.buy && widget.currentPrice > price) {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('tp_limit_up_alert'),
                    );
                    return;
                  } else if (widget.action == OrderActionTypeEnum.sell && widget.currentPrice < price) {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('tpsl_limit_sell_down_alert'),
                    );
                    return;
                  }

                  widget.onChange(takeProfit: price);
                  _profitController.text = MoneyUtils().readableMoney(
                    price,
                  );
                });
              },
            ),
            const SizedBox(
              height: Grid.s,
            ),
            PPriceTextfield(
              key: _lossKey,
              title: L10n.tr('zarar_durdur'),
              controller: _lossController,
              action: widget.action,
              focusNode: widget.slFocusNode,
              marketListModel: widget.marketListModel,
              currentPrice: widget.currentPrice,
              onTapPrice: () {
                widget.onTapPrice(_lossKey);
              },
              onPriceChanged: (price) {
                setState(() {
                  widget.onTPSLChanged(
                    stopLoss: price,
                  );

                  if (widget.action == OrderActionTypeEnum.buy && widget.currentPrice < price) {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('tpsl_limit_down_alert'),
                    );
                    return;
                  } else if (widget.action == OrderActionTypeEnum.sell && widget.currentPrice > price) {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('tpsl_limit_sell_up_alert'),
                    );
                    return;
                  }

                  _lossController.text = MoneyUtils().readableMoney(
                    price,
                  );
                  widget.onChange(
                    stopLoss: price,
                  );
                });
              },
            ),
            if (widget.showValidityDate) ...[
              const SizedBox(
                height: Grid.m,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.xs,
                ),
                child: InkWell(
                  onTap: () async {
                    await showPDatePicker(
                      context: context,
                      initialDate: _validityDate,
                      cancelTitle: L10n.tr('iptal'),
                      doneTitle: L10n.tr('tamam'),
                      onChanged: (selectedDate) {
                        if (selectedDate == null) return;
                        DateTime date = DateTimeUtils().moveToSessionDate(selectedDate);
                        widget.onChange(validityDate: date);
                        setState(() {
                          _validityDate = date;
                        });
                      },
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImagesPath.calendar,
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Text(
                        L10n.tr('gecerlilik_tarihi'),
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                      const Spacer(),
                      Text(
                        _validityDate.formatDayMonthYearDot(),
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
