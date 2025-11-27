import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class BankListWidget extends StatefulWidget {
  const BankListWidget({
    this.comeFromWelcomeScreen = false,
    super.key,
  });

  final bool comeFromWelcomeScreen;
  @override
  State<BankListWidget> createState() => _BankListWidgetState();
}

class _BankListWidgetState extends State<BankListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // bellek sızıntısını önlemek için
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BankInfoModel> bankList = [];

    if (getIt<AppInfoBloc>().state.bankModel != null && getIt<AppInfoBloc>().state.bankModel!.bankInfos != null) {
      bankList = getIt<AppInfoBloc>().state.bankModel!.bankInfos!;
    }

    return bankList.isEmpty
        ? const SizedBox.shrink()
        : RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thumbColor: context.pColorScheme.iconPrimary,
            radius: const Radius.circular(2),
            thickness: 2,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: bankList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    router.push(
                      DepositMoneyAccountRoute(
                        bankList: bankList,
                        selectedIndex: index,
                      ),
                    );

                    router.maybePop(widget.comeFromWelcomeScreen ? true : null);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Grid.s,
                        ),
                        child: Row(
                          spacing: Grid.s,
                          children: [
                            SymbolIcon(
                              symbolName: bankList[index].symbolIcon ?? '',
                              symbolType: SymbolTypes.bankIcon,
                              size: 15,
                            ),
                            Text(
                              bankList[index].title ?? '',
                              textAlign: TextAlign.start,
                              style: context.pAppStyle.labelReg14textPrimary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      if (index != bankList.length - 1) const PDivider(),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
