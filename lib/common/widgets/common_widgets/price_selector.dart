import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

class PriceSelector extends StatefulWidget {
  final List<double> priceSteps;
  final double currentPrice;
  final Function(double) onPriceChanged;
  final String pattern;
  const PriceSelector({
    super.key,
    required this.priceSteps,
    required this.currentPrice,
    required this.onPriceChanged,
    this.pattern = '#,##0.00',
  });

  @override
  State<PriceSelector> createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PriceSelector> {
  final ScrollController _scrollController = ScrollController();
  late double _selectedValue;
  late List<GlobalKey> _keys;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedValue = MoneyUtils().findClosestPrice(widget.currentPrice, widget.priceSteps);
    _keys = List.generate(widget.priceSteps.length, (index) => GlobalKey());
    _selectedIndex = widget.priceSteps.indexOf(_selectedValue);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: widget.priceSteps.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) {
          return BottomsheetSelectTile(
            key: _keys[index],
            title: MoneyUtils().readableMoney(widget.priceSteps[index], pattern: widget.pattern),
            isSelected: _selectedValue == widget.priceSteps[index],
            value: widget.priceSteps[index],
            onTap: (_, value) {
              setState(() {
                _selectedValue = value;
              });
              router.maybePop();
              widget.onPriceChanged(_selectedValue);
            },
          );
        },
      ),
    );
  }

  void _scrollToIndex() {
    if (_selectedIndex >= 0 && _selectedIndex < widget.priceSteps.length) {
      const double itemHeight = 63.0;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double listHeight = screenHeight * 0.7;
      final double offset = itemHeight * _selectedIndex - (listHeight / 2) + (itemHeight / 2);

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 30),
        curve: Curves.easeInOut,
      );
    }
  }
}
