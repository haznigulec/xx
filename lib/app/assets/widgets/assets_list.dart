import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/widgets/assets_components_widget.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AssetsList extends StatelessWidget {
  final String date;
  final AssetModel? assets;
  final bool? isFromAgreement;
  final String? assetSelectedAccount;
  final bool isVisible;
  final String selectedAccount;
  final bool hasViop;
  final bool hasIpo;

  const AssetsList({
    super.key,
    this.date = '',
    this.assets,
    this.isFromAgreement = false,
    this.assetSelectedAccount = '',
    required this.isVisible,
    required this.selectedAccount,
    required this.hasViop,
    required this.hasIpo,
  });

  @override
  Widget build(BuildContext context) {
    final ipoList = getIt<IpoBloc>().state.ipoDemandList;
    final hasIpoList = ipoList != null && ipoList.isNotEmpty;
    final allIpoDatesAfterNow = hasIpoList &&
        ipoList.every((e) => DateTime.now().isBefore(DateTime.parse(e.demandDate ?? DateTime.now().toString())));

    List<OverallItemModel> defaultValue = [
      if (!isFromAgreement!) ...[
        OverallItemModel(
          instrumentCategory: 'cash',
          totalAmount: 0,
          ratio: 0,
          overallSubItems: [
            OverallSubItemModel(
              amount: 0,
              category: 'cash',
              cost: 0,
              exchangeValue: 0,
              financialInstrumentCode: 'cash',
              financialInstrumentId: '',
              financialInstrumentType: 'cash',
              potentialProfitLoss: 0,
              price: 1,
              profitLossPercent: 0,
              qty: 0,
              symbol: 'TRY',
              totalStock: 0,
              transTypeOrder: '0-CASH',
            ),
          ],
          totalPotentialProfitLoss: 0,
        ),
        OverallItemModel(
          instrumentCategory: 'viop_collateral',
          totalAmount: 0,
          ratio: 0,
          overallSubItems: [
            OverallSubItemModel(
              amount: 0,
              category: 'VIOP Teminat',
              cost: 0,
              exchangeValue: 0,
              financialInstrumentCode: '',
              financialInstrumentId: '',
              financialInstrumentType: 'Nakit',
              potentialProfitLoss: 0,
              price: 1,
              profitLossPercent: 0,
              qty: 0,
              symbol: 'TRY VIOP',
              totalStock: 0,
              transTypeOrder: '15-VIOP_CASH',
            ),
          ],
          totalPotentialProfitLoss: 0,
        ),
      ],
      if ((hasIpo && !isFromAgreement! && hasIpoList) ||
          (isFromAgreement! && allIpoDatesAfterNow && hasIpoList && hasIpo))
        OverallItemModel(
          instrumentCategory: 'ipo',
          totalAmount: 0,
          ratio: 0,
          overallSubItems: [],
          totalPotentialProfitLoss: 0,
        ),
    ];
    // 1. Null değilse ve boş değilse listeyi al, yoksa defaultValue ata
    List<OverallItemModel> assetsDataList = (assets?.overallItemGroups == null || assets!.overallItemGroups.isEmpty)
        ? defaultValue
        : assets!.overallItemGroups;

// 2. "viop" olanları kaldır
    assetsDataList.removeWhere((item) => item.instrumentCategory == 'viop');

// 3. Kategori çakışmayanları ekle
    assetsDataList.addAll(
      defaultValue.where(
        (item) => !assetsDataList.any((group) => group.instrumentCategory == item.instrumentCategory),
      ),
    );
    return PBlocBuilder<AppInfoBloc, AppInfoState>(
      bloc: getIt<AppInfoBloc>(),
      builder: (context, state) {
        return ListView.separated(
          itemCount: assetsDataList.length,
          shrinkWrap: true,
          physics: const PageScrollPhysics(),
          separatorBuilder: (context, index) => const PDivider(),
          itemBuilder: (context, index) {
            assetsDataList.sort((a, b) {
              int getPriority(dynamic asset) {
                if (asset.instrumentCategory == 'cash' && asset.totalAmount != 0) return 0;
                if (asset.instrumentCategory == 'equity') return 1;
                if (asset.instrumentCategory == 'viop') return 2;
                if (asset.instrumentCategory == 'viop_collateral' && asset.totalAmount != 0) return 3;
                if (asset.instrumentCategory == 'fund') return 4;
                if ((asset.instrumentCategory == 'cash' || asset.instrumentCategory == 'viop_collateral') &&
                    asset.totalAmount == 0) {
                  return 99; // Listenin en sonunda olacaklar
                }
                return 5; // Diğer tüm kategoriler
              }

              return getPriority(a).compareTo(getPriority(b));
            });

            if (assetsDataList[index].overallSubItems.any((element) => element.qty == 0) &&
                assetsDataList[index].instrumentCategory != 'cash' &&
                assetsDataList[index].instrumentCategory != 'viop' &&
                assetsDataList[index].instrumentCategory != 'viop_collateral') {
              return const SizedBox.shrink();
            }

            return AssetsComponentsWidget(
              hasViop: hasViop,
              isVisible: isVisible,
              assets: assetsDataList[index],
              totalValue: assets?.totalTlOverall ?? 0,
              lastIndex: assetsDataList.length - 1,
              index: index,
              totalUsdOverall: assets?.totalUsdOverall ?? 0,
              selectedAccount: selectedAccount,
              isAgreementPage: isFromAgreement,
            );
          },
        );
      },
    );
  }
}
