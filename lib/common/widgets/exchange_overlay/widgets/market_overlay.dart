import '../model/market_overlay_model.dart';
import 'bottom_market_overlay_tile.dart';
import 'market_overlay_button.dart';
import 'show_case_view.dart';
import 'top_market_overlay_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class MarketOverlay extends StatefulWidget {
  final List<MarketOverlayModel> list;
  final Function(int) onSelected;
  final Function(bool isOverlayVisible) onOverlayVisibilityChanged;
  final int? initialIndex;
  final bool isActiveShowCase;
  final List<ShowCaseViewModel> marketShowCaseKeys;

  const MarketOverlay({
    super.key,
    required this.list,
    required this.onSelected,
    required this.onOverlayVisibilityChanged,
    this.initialIndex,
    this.isActiveShowCase = false,
    required this.marketShowCaseKeys,
  });

  @override
  State<MarketOverlay> createState() => _MarketOverlayState();
}

class _MarketOverlayState extends State<MarketOverlay> with SingleTickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _overlayKey = GlobalKey();
  bool _isOverlayVisible = false;
  int _selectedIndex = 0;
  List<BottomMarketOverlayModel> bottomList = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    bottomList.addAll(
      widget.list
          .where((MarketOverlayModel model) => model.runtimeType == BottomMarketOverlayModel)
          .map(
            (e) => e as BottomMarketOverlayModel,
          )
          .toList(),
    );
    // ShowCase için ilk yüklemede açık gelecek
    if (widget.isActiveShowCase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlay(
          context: context,
          onShowedCallBack: () async {
            await Future.delayed(Duration.zero);
            setState(() {
              _controller.forward();
              _isOverlayVisible = true;
              widget.onOverlayVisibilityChanged(_isOverlayVisible);
            });
            await Future.delayed(const Duration(milliseconds: 350));
            ShowcaseView.get().startShowCase([
              ...widget.marketShowCaseKeys.map((e) => e.globalKey),
            ]);
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bottomList.length != 2) {
      throw Exception('There must be 2 BottomExchangeOverlayModel in the given item list.');
    }
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        _overlayEntry.remove();
        _isOverlayVisible = false;
        widget.onOverlayVisibilityChanged(_isOverlayVisible);
      },
      child: MarketOverlayButton(
        key: _buttonKey,
        selectedOverlayModel: widget.list.firstWhere((e) => e.index == _selectedIndex),
        isOverlayVisible: _isOverlayVisible,
        onTap: () {
          if (_isOverlayVisible) {
            _controller.reverse().then((_) {
              setState(() {
                _overlayEntry.remove();
                _isOverlayVisible = false;
                widget.onOverlayVisibilityChanged(_isOverlayVisible);
              });
            });
          } else {
            _showOverlay(context: context);
            setState(() {
              _controller.forward();
              _isOverlayVisible = true;
              widget.onOverlayVisibilityChanged(_isOverlayVisible);
            });
          }
          setState(() {});
        },
      ),
    );
  }

  void _showOverlay({
    required BuildContext context,
    Function? onShowedCallBack,
  }) {
    if (_buttonKey.currentContext == null || _buttonKey.currentContext!.findRenderObject() == null) {
      return;
    }

    final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => const SizedBox.shrink(),
    );
    Overlay.of(context).insert(_overlayEntry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry.markNeedsBuild();
      _overlayEntry.remove();
      _overlayEntry = _createOverlayEntry(position, size);
      Overlay.of(context).insert(_overlayEntry);
      onShowedCallBack?.call();
    });
  }

  OverlayEntry _createOverlayEntry(Offset position, Size size) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _controller.reverse().then((_) {
                setState(() {
                  _overlayEntry.remove();
                  _isOverlayVisible = false;
                  widget.onOverlayVisibilityChanged(_isOverlayVisible);
                });
              });
            },
            child: Container(
              color: Colors.transparent, // Dokunma algılayıcısı için transparan bir katman
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            key: _overlayKey,
            left: position.dx - ((MediaQuery.of(context).size.width * .59 - size.width) / 2),
            top: position.dy + size.height + Grid.s,
            width: MediaQuery.of(context).size.width * .6,
            child: Material(
              color: Colors.transparent,
              child: SizeTransition(
                sizeFactor: _sizeAnimation,
                axisAlignment: 1.0,
                child: ShowCaseView(
                  showCase: widget.marketShowCaseKeys.first,
                  targetRadius: BorderRadius.circular(Grid.m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Grid.m,
                        ),
                        child: Container(
                          color: context.pColorScheme.backgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...widget.list
                                  .where((MarketOverlayModel model) => model.runtimeType == TopMarketOverlayModel)
                                  .map(
                                (e) {
                                  if (e.index == 1) {
                                    return ShowCaseView(
                                      showCase: widget.marketShowCaseKeys.skip(1).take(1).first,
                                      targetRadius: BorderRadius.circular(Grid.m),
                                      child: TopMarketOverlayTile(
                                        model: e as TopMarketOverlayModel,
                                        isSelected: _selectedIndex == e.index,
                                        onTap: () => toggleTile(e.index),
                                      ),
                                    );
                                  }
                                  return TopMarketOverlayTile(
                                    model: e as TopMarketOverlayModel,
                                    isSelected: _selectedIndex == e.index,
                                    onTap: () => toggleTile(e.index),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.xs,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * .59,
                          color: context.pColorScheme.backgroundColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: BottomMarketOverlayTile(
                                  model: bottomList.first,
                                  isSelected: _selectedIndex == bottomList.first.index,
                                  onTap: () => toggleTile(bottomList.first.index),
                                ),
                              ),
                              Container(
                                color: context.pColorScheme.iconSecondary,
                                height: 46,
                                width: 1,
                              ),
                              Expanded(
                                child: ShowCaseView(
                                  showCase: widget.marketShowCaseKeys.last,
                                  targetRadius: BorderRadius.circular(Grid.m),
                                  child: BottomMarketOverlayTile(
                                    model: bottomList.last,
                                    isSelected: _selectedIndex == bottomList.last.index,
                                    onTap: () => toggleTile(bottomList.last.index),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggleTile(int index) {
    _controller.reverse().then((_) {
      setState(() {
        _selectedIndex = index;
        widget.onSelected(index);
        _overlayEntry.remove();
        _isOverlayVisible = false;
        widget.onOverlayVisibilityChanged(_isOverlayVisible);
      });
    });
  }
}
