import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/chip/chip.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_volume_history_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_volume_chart_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class VolumeInfosWidget extends StatefulWidget {
  const VolumeInfosWidget({super.key});

  @override
  VolumeInfosWidgetState createState() => VolumeInfosWidgetState();
}

class VolumeInfosWidgetState extends State<VolumeInfosWidget> {
  late FundBloc _fundBloc;
  late ScrollController _chipScrollController;

  final List<String> _categories = [
    L10n.tr('portfolioSize'),
    L10n.tr('numberOfPeople'),
    L10n.tr('numberOfShares'),
  ];

  String _selectedCategory = L10n.tr('portfolioSize');

  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _chipScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  double _getVolumeHistoryListByCategory(FundVolumeHistoryModel model, String category) {
    if (category == L10n.tr('portfolioSize')) {
      return model.portfolioSize;
    } else if (category == L10n.tr('numberOfPeople')) {
      return model.numberOfPeople;
    } else if (category == L10n.tr('numberOfShares')) {
      return model.numberOfShares;
    } else {
      return model.portfolioSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
      bloc: _fundBloc,
      builder: (context, state) {
        if (state.fundVolumeHistoryDataList == null || state.fundVolumeHistoryDataList!.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Text(
                L10n.tr('volume_infos'),
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m + Grid.xxs,
                ),
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            SizedBox(
              height: 36,
              child: ListView.builder(
                controller: _chipScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Row(
                    children: [
                      PChoiceChip(
                        label: category,
                        selected: _selectedCategory == category,
                        chipSize: ChipSize.medium,
                        enabled: true,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });

                          _chipScrollController.animateTo(
                            index * 100.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      const SizedBox(
                        width: Grid.xs,
                      ),
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.s + Grid.xs,
                horizontal: Grid.m,
              ),
              child: PDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory,
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                  Text(
                    MoneyUtils().compactMoney(
                      _getVolumeHistoryListByCategory(
                        state.fundVolumeHistoryDataList!.last,
                        _selectedCategory,
                      ),
                    ),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: FundVolumeHistoryChartWidget(
                data: state.fundVolumeHistoryDataList ?? [],
                isLoading: false,
                isFailed: false,
                category: _selectedCategory,
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
