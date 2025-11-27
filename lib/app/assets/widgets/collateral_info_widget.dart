import 'dart:convert';

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class CollateralInfoWidget extends StatefulWidget {
  final bool? isAgreementPage;
  const CollateralInfoWidget({
    this.isAgreementPage = false,
    super.key,
  });

  @override
  CollateralInfoWidgetState createState() => CollateralInfoWidgetState();
}

class CollateralInfoWidgetState extends State<CollateralInfoWidget> {
  bool _showAll = false;
  final ScrollController _scrollController = ScrollController();
  bool _needsScrollbar = false;
  late AssetsBloc _assetsBloc;

  @override
  void initState() {
    super.initState();
    _assetsBloc = getIt<AssetsBloc>();
    if (widget.isAgreementPage == true) {
      _assetsBloc.add(
        GetAssetsCollateralInfoEvent(
          accountId: UserModel.instance.accountId,
        ),
      );
    }
    _scrollController.addListener(_checkIfScrollbarNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfScrollbarNeeded());
  }

  void _checkIfScrollbarNeeded() {
    if (!_scrollController.hasClients) return;
    final bool shouldShow = _scrollController.position.maxScrollExtent > 0;
    if (_needsScrollbar != shouldShow) {
      setState(() {
        _needsScrollbar = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkIfScrollbarNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetsBloc,
      builder: (context, state) {
        if (state.collateralInfo == null || state.isLoading) {
          return const PLoading();
        }

        List<String> prioritizedKeys =
            (jsonDecode(remoteConfig.getValue('collateralInfoSorting').asString())['keys'] as List)
                .map((e) => e.toString())
                .toList();
        final allEntries = state.collateralInfo!.toJson().entries;

        final prioritizedEntries = prioritizedKeys
            .map((key) => MapEntry(
                  key,
                  allEntries.firstWhere((e) => e.key == key, orElse: () => MapEntry(key, 0)).value,
                ))
            .toList();

        final remainingEntries = allEntries.where((entry) => !prioritizedKeys.contains(entry.key)).toList();

        final collateralList = [
          ...prioritizedEntries.map(
            (e) => MapEntry(e.key, MoneyUtils().readableMoney(e.value ?? 0)),
          ),
          ...remainingEntries.map(
            (e) => MapEntry(e.key, MoneyUtils().readableMoney(e.value ?? 0)),
          ),
        ];

        final visibleList = _showAll ? collateralList : collateralList.take(5).toList();

        return SizedBox(
          height: _showAll ? MediaQuery.sizeOf(context).height * .7 : MediaQuery.sizeOf(context).height * .3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RawScrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 2,
                  radius: const Radius.circular(Grid.xs),
                  thumbColor: context.pColorScheme.iconPrimary,
                  child: Padding(
                    padding: EdgeInsets.only(right: _needsScrollbar ? Grid.m : 0.0),
                    child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: visibleList.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: Grid.m + Grid.xs),
                      ),
                      itemBuilder: (context, index) {
                        final entry = visibleList[index];
                        return collateralRow(entry.key, entry.value);
                      },
                    ),
                  ),
                ),
              ),
              PCustomPrimaryTextButton(
                margin: const EdgeInsets.symmetric(vertical: Grid.m),
                text: _showAll ? L10n.tr('daha_az_göster') : L10n.tr('daha_fazla_goster'),
                onPressed: () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfScrollbarNeeded());
                },
              ),
              if (widget.isAgreementPage != true) ...[
                const PDivider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: PTextButtonWithIcon(
                    text: L10n.tr('teminat_cek_yatir'),
                    padding: EdgeInsets.zero,
                    iconAlignment: IconAlignment.end,
                    icon: SvgPicture.asset(
                      ImagesPath.arrow_up_right,
                      width: Grid.m,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      router.push(const ViopCollateralRoute());
                    },
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget collateralRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            L10n.tr(key),
            maxLines: 2,
            style: context.pAppStyle.labelMed14textSecondary,
          ),
        ),
        const SizedBox(width: Grid.xs),
        Text(
          '${key == 'collateralRate' ? '%' : key == 'riskLevel' ? '' : CurrencyEnum.turkishLira.symbol}$value',
          style: context.pAppStyle.labelMed14textPrimary,
        ),
      ],
    );
  }
}
