import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_active_list.dart';
import 'package:piapiri_v2/app/markets/widgets/advice_history_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class BistAnalysisAllAdvicesPage extends StatefulWidget {
  final List<AdviceModel>? adviceList;
  final String mainGroup;
  const BistAnalysisAllAdvicesPage({
    super.key,
    this.adviceList,
    required this.mainGroup,
  });

  @override
  State<BistAnalysisAllAdvicesPage> createState() => _BistAnalysisAllAdvicesPageState();
}

class _BistAnalysisAllAdvicesPageState extends State<BistAnalysisAllAdvicesPage> {
  late AdvicesBloc _advicesBloc;

  @override
  void initState() {
    _advicesBloc = getIt<AdvicesBloc>();

    if (widget.adviceList == null) {
      _advicesBloc.add(
        GetAdvicesEvent(
          fetchRoboSignals: true,
          mainGroup: widget.mainGroup,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('oneriler'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.s,
          ),
          child: PMainTabController(
            scrollable: false,
            tabs: [
              PTabItem(
                title: L10n.tr('active'),
                page: widget.adviceList != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.s,
                        ),
                        child: AdviceActiveList(
                          adviceList: widget.adviceList!,
                          mainGroup: widget.mainGroup,
                        ),
                      )
                    : PBlocBuilder<AdvicesBloc, AdvicesState>(
                        bloc: _advicesBloc,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.s,
                            ),
                            child: AdviceActiveList(
                              adviceList: state.adviceList,
                              mainGroup: widget.mainGroup,
                            ),
                          );
                        }),
              ),
              PTabItem(
                title: L10n.tr('past'),
                page: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.m - Grid.xs,
                      bottom: Grid.m,
                      left: Grid.s,
                      right: Grid.s,
                    ),
                    child: AdviceHistoryWidget(
                      mainGroup: widget.mainGroup,
                      canShowAllText: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
