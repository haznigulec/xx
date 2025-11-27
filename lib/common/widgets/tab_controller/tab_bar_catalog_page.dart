import 'model/tab_bar_item.dart';
import 'tab_controllers/p_main_tab_controller.dart';
import 'tab_controllers/p_sub_tab_bar_controller.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class TabBarCatalogPage extends StatefulWidget {
  const TabBarCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _TabBarCatalogPageState();
}

class _TabBarCatalogPageState extends State<TabBarCatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            SizedBox(
              height: 350,
              child: PSubTabController(
                tabList: [
                  PTabItem(
                    title: 'Tab One',
                    page: Center(
                      child: Text(
                        'Tab One',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                        ),
                      ),
                    ),
                  ),
                  PTabItem(
                    title: 'Tab Two',
                    page: Center(
                      child: Text(
                        'Tab Two',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 350,
              child: PMainTabController(
                tabs: [
                  PTabItem(
                    title: 'Tab One',
                    page: Center(
                      child: Text(
                        'Tab Onee',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                        ),
                      ),
                    ),
                  ),
                  PTabItem(
                    title: 'Tab Twoe',
                    page: Center(
                      child: Text(
                        'Tab Two',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
