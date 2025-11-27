import '../model/tab_bar_item.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class PSubTabController extends StatefulWidget {
  final List<PTabItem> tabList;
  const PSubTabController({
    super.key,
    required this.tabList,
  });

  @override
  State<PSubTabController> createState() => _PSubTabControllerState();
}

class _PSubTabControllerState extends State<PSubTabController> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.m + Grid.xs,
      ),
      child: DefaultTabController(
        length: widget.tabList.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Grid.l + Grid.s + Grid.xs,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                shrinkWrap: true,
                itemCount: widget.tabList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final bool isSelected = _selectedIndex == index;
                  final GlobalKey buttonKey = GlobalKey();
                  return OutlinedButton(
                    key: buttonKey,
                    style: isSelected
                        ? context.pAppStyle.oulinedMediumPrimaryStyle.copyWith(
                            foregroundColor: WidgetStateProperty.all(context.pColorScheme.primary),
                            backgroundColor: WidgetStateProperty.all(context.pColorScheme.secondary),
                            side: WidgetStatePropertyAll(
                              BorderSide(
                                color: context.pColorScheme.secondary,
                              ),
                            ),
                          )
                        : context.pAppStyle.oulinedMediumPrimaryStyle,
                    onPressed: () => _onTabSelected(index, buttonKey),
                    child: Text(
                      widget.tabList[index].title,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: Grid.xs),
              ),
            ),
            const SizedBox(
              height: Grid.m + Grid.xs,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: widget.tabList.map((tab) => tab.page).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index, GlobalKey buttonKey) {
    setState(() {
      _selectedIndex = index;
    });
    Scrollable.ensureVisible(
      buttonKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.5,
    );
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
