import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/order_validator.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/price_selector.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PSLTPTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String title;
  final OrderActionTypeEnum action;
  final Function(double newPrice) onPriceChanged;
  final MarketListModel marketListModel;
  final Color? backgroundColor;
  final double currentPrice;
  final bool isStopLoss;
  const PSLTPTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.title,
    required this.action,
    required this.onPriceChanged,
    required this.marketListModel,
    this.backgroundColor,
    required this.currentPrice,
    required this.isStopLoss,
  });

  @override
  State<PSLTPTextField> createState() => _PSLTPTextFieldState();
}

class _PSLTPTextFieldState extends State<PSLTPTextField> {
  late TextEditingController _priceController;
  late FocusNode _focusNode;
  double limitDown = 0;
  double limitUp = 0;
  bool _isPriceError = false;
  String? _priceErrorText;
  @override
  void initState() {
    super.initState();
    _priceController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.unfocus();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        double newPrice = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
        validateSLTP(newPrice);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double priceStep = 0.1;
    String symbolType = widget.marketListModel.type;
    String marketCode = widget.marketListModel.marketCode;
    double price = 0;

    if (stringToSymbolType(symbolType) != SymbolTypes.warrant) {
      if (MoneyUtils().fromReadableMoney(_priceController.text) > widget.marketListModel.limitUp) {
        priceStep = Utils().getPriceStep(
          limitUp,
          symbolType,
          marketCode,
          widget.marketListModel.subMarketCode,
          widget.marketListModel.priceStep,
        );
      } else if (MoneyUtils().fromReadableMoney(_priceController.text) < widget.marketListModel.limitDown) {
        priceStep = Utils().getPriceStep(
          limitDown,
          symbolType,
          marketCode,
          widget.marketListModel.subMarketCode,
          widget.marketListModel.priceStep,
        );
      } else {
        priceStep = Utils().getPriceStep(
          MoneyUtils().fromReadableMoney(_priceController.text),
          symbolType,
          marketCode,
          widget.marketListModel.subMarketCode,
          widget.marketListModel.priceStep,
        );
      }
      limitDown = (widget.marketListModel.limitDown / priceStep).ceil() * priceStep;
      limitDown = double.parse(limitDown.toStringAsFixed(2));
      limitUp = (widget.marketListModel.limitUp / priceStep).floor() * priceStep;
      limitUp = double.parse(limitUp.toStringAsFixed(2));
      double newPrice = MoneyUtils().getPrice(widget.marketListModel, widget.action);
      price = newPrice == 0 ? widget.marketListModel.basePrice : newPrice;
    }

    return PValueTextfieldWidget(
      controller: _priceController,
      title: widget.title,
      focusNode: _focusNode,
      suffixText: CurrencyEnum.turkishLira.symbol,
      backgroundColor: context.pColorScheme.card,
      isError: _isPriceError,
      errorText: _priceErrorText,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 2,
        ),
      ],

      prefix: stringToSymbolType(symbolType) == SymbolTypes.warrant
          ? null
          : GestureDetector(
              child: SvgPicture.asset(
                height: 17,
                width: 17,
                ImagesPath.sort_up_down,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                _showPriceSteps(
                  price,
                  priceStep,
                  limitUp,
                  limitDown,
                  symbolType,
                  marketCode,
                );
              },
            ),
    );
  }

  void _showPriceSteps(
    double price,
    double priceStep,
    double limitUp,
    double limitDown,
    String symbolType,
    String marketCode,
  ) {
    List<double> priceSteps = MoneyUtils().getPriceSteps(
      price: price,
      priceStep: priceStep,
      limitUp: limitUp,
      limitDown: limitDown,
      symbolType: symbolType,
      marketCode: marketCode,
    );
    PBottomSheet.show(context,
        title: L10n.tr('fiyat'),
        child: PriceSelector(
          priceSteps: priceSteps,
          currentPrice: MoneyUtils().fromReadableMoney(_priceController.text),
          onPriceChanged: (newPrice) {
            if (newPrice > limitUp) {
              newPrice = limitUp;
            } else if (newPrice < limitDown) {
              newPrice = limitDown;
            }
            _priceController.text = MoneyUtils().readableMoney(newPrice);

            widget.onPriceChanged(newPrice);
          },
        ));
  }

  void validateSLTP(double newPrice) {
    if (!widget.isStopLoss) {
      if (newPrice == widget.currentPrice) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_equal_alert');
        if (widget.action == OrderActionTypeEnum.buy) {
          newPrice = widget.currentPrice + widget.marketListModel.priceStep;
        } else {
          newPrice = widget.currentPrice - widget.marketListModel.priceStep;
        }
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      if (newPrice < widget.currentPrice && widget.action == OrderActionTypeEnum.buy) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_min_alert');
        newPrice = widget.currentPrice + widget.marketListModel.priceStep;
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      if (newPrice > widget.currentPrice && widget.action == OrderActionTypeEnum.sell) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_max_alert');
        newPrice = widget.currentPrice - widget.marketListModel.priceStep;
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      _isPriceError = false;
      _priceErrorText = null;
      setState(() {});
      returnPrice(newPrice);
    } else {
      if (newPrice == widget.currentPrice) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_equal_alert');
        if (widget.action == OrderActionTypeEnum.buy) {
          newPrice = widget.currentPrice - widget.marketListModel.priceStep;
        } else {
          newPrice = widget.currentPrice + widget.marketListModel.priceStep;
        }
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      if (newPrice > widget.currentPrice && widget.action == OrderActionTypeEnum.buy) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_max_alert');
        newPrice = widget.currentPrice - widget.marketListModel.priceStep;
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      if (newPrice < widget.currentPrice && widget.action == OrderActionTypeEnum.sell) {
        _isPriceError = true;
        _priceErrorText = L10n.tr('sltp_min_alert');
        newPrice = widget.currentPrice + widget.marketListModel.priceStep;
        setState(() {});
        returnPrice(newPrice);
        return;
      }
      _isPriceError = false;
      _priceErrorText = null;
      setState(() {});
      returnPrice(newPrice);
    }
  }

  void returnPrice(double newPrice) {
    newPrice = OrderValidator.priceValidator(
      context,
      symbolName: widget.marketListModel.symbolCode,
      price: newPrice,
      limitUp: limitUp,
      limitDown: limitDown,
      type: stringToSymbolType(widget.marketListModel.type),
    );
    _priceController.text = MoneyUtils().readableMoney(newPrice);
    widget.onPriceChanged(newPrice);
  }
}
