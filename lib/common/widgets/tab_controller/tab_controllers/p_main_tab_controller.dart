import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import '../model/tab_bar_item.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class PMainTabController extends StatefulWidget {
  final List<PTabItem> tabs;
  final bool scrollable;
  final int initialIndex;
  final Function(int)? onTabChange;
  final bool showTabbar;
  final bool preloadAllTabs; // <-- yeni parametre

  const PMainTabController({
    super.key,
    required this.tabs,
    this.scrollable = true,
    this.initialIndex = 0,
    this.onTabChange,
    this.showTabbar = true,
    this.preloadAllTabs = false, // default: lazy load
  });

  @override
  State<PMainTabController> createState() => _PMainTabControllerState();
}

class _PMainTabControllerState extends State<PMainTabController> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      widget.onTabChange?.call(_tabController.index);
      setState(() {}); // IndexedStack için index güncelle
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.showTabbar,
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs
                .map(
                  (tab) => tab.showCase == null
                      ? Tab(text: tab.title)
                      : ShowCaseView(
                          showCase: tab.showCase!,
                          targetRadius: BorderRadius.circular(Grid.m),
                          targetPadding: const EdgeInsets.symmetric(
                            horizontal: Grid.s + Grid.xs,
                          ),
                          child: SizedBox(
                            height: 32,
                            child: Tab(text: tab.title),
                          ),
                        ),
                )
                .toList(),
            indicatorColor: context.pColorScheme.primary,
            labelColor: context.pColorScheme.primary,
            unselectedLabelColor: context.pColorScheme.textTeritary,
            splashFactory: NoSplash.splashFactory,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: widget.scrollable ? TabAlignment.start : TabAlignment.center,
            isScrollable: widget.scrollable,
            dividerColor: context.pColorScheme.line,
            labelPadding: const EdgeInsets.symmetric(horizontal: Grid.m),
            indicatorPadding: const EdgeInsets.only(
              left: Grid.s + Grid.xxs,
              right: Grid.s + Grid.xxs,
              bottom: Grid.xs,
            ),
            labelStyle: context.pAppStyle.labelMed16primary,
            unselectedLabelStyle: context.pAppStyle.labelMed16primary.copyWith(
              color: context.pColorScheme.textTeritary,
            ),
          ),
        ),

        /// Burada seçim: preload mu lazy load mu
        Expanded(
          child: widget.preloadAllTabs
              ? IndexedStack(
                  index: _tabController.index,
                  children: widget.tabs.map((tab) => tab.page).toList(),
                )
              : TabBarView(
                  controller: _tabController,
                  physics: widget.scrollable ? null : const NeverScrollableScrollPhysics(),
                  children: widget.tabs.map((tab) => tab.page).toList(),
                ),
        ),
      ],
    );
  }
}
