import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/withdraw_add_account_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/withdraw_iban_edit_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WithdrawIbanWidget extends StatefulWidget {
  final List<CustomerBankAccountModel>? bankAccountList;
  final String selectedAccount;
  final Function(CustomerBankAccountModel) onSelectedBankAccount;
  const WithdrawIbanWidget({
    super.key,
    this.bankAccountList,
    required this.selectedAccount,
    required this.onSelectedBankAccount,
  });

  @override
  State<WithdrawIbanWidget> createState() => _WithdrawIbanWidgetState();
}

class _WithdrawIbanWidgetState extends State<WithdrawIbanWidget> {
  CustomerBankAccountModel? _selectedBank;

  @override
  void initState() {
    if (widget.bankAccountList != null && widget.bankAccountList!.isNotEmpty) {
      _selectedBank = widget.bankAccountList![0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
        vertical: Grid.l - Grid.xxs,
      ),
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            Grid.m,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            L10n.tr('iban'),
            style: context.pAppStyle.labelReg14textPrimary,
          ),
          Expanded(
            child: widget.bankAccountList == null || widget.bankAccountList!.isEmpty
                ? _addNewAccountWidget(
                    true,
                    MainAxisAlignment.end,
                  )
                : InkWell(
                    onTap: () => _chooseAccountBottomSheet(),
                    child: Text(
                      '${_selectedBank!.bankName} (${_selectedBank!.ibanNo.substring(_selectedBank!.ibanNo.length - 4)})',
                      textAlign: TextAlign.end,
                      style: context.pAppStyle.labelMed14primary,
                    ),
                  ),
          ),
          if (widget.bankAccountList == null || widget.bankAccountList!.isEmpty)
            const SizedBox.shrink()
          else
            Padding(
              padding: const EdgeInsets.only(
                left: Grid.xs,
              ),
              child: SvgPicture.asset(
                ImagesPath.chevron_down,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _chooseAccountBottomSheet() {
    return PBottomSheet.show(
      context,
      title: L10n.tr('account_selection'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            itemCount: widget.bankAccountList!.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const PDivider(),
            itemBuilder: (context, index) {
              final e = widget.bankAccountList![index];

              return BottomsheetSelectTile(
                title: '${e.bankName}(${e.ibanNo.substring(e.ibanNo.length - 4)})',
                isSelected: _selectedBank == e,
                value: e,
                onTap: (title, value) {
                  setState(() {
                    _selectedBank = value;
                    widget.onSelectedBankAccount(value);
                  });
                  router.maybePop();
                },
                trailingWidget: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedBank = e;
                    });

                    PBottomSheet.show(
                      context,
                      title: L10n.tr('edit_account'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: WithdrawIbanEditWidget(
                        selectedBank: _selectedBank!,
                        bankAccountList: widget.bankAccountList,
                        selectedAccount: widget.selectedAccount,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Grid.s),
                    child: SvgPicture.asset(
                      ImagesPath.pencil,
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const PDivider(),
          const SizedBox(
            height: Grid.m,
          ),
          _addNewAccountWidget(
            false,
            MainAxisAlignment.start,
          ),
        ],
      ),
    );
  }

  Widget _addNewAccountWidget(
    bool isFirstIban,
    MainAxisAlignment mainAxisAlignment,
  ) {
    return InkWell(
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('hesap_ekle'),
          child: WithdrawAddAccountWidget(
            selectedAccount: widget.selectedAccount,
            isFirstIban: isFirstIban,
          ),
        );

        return;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: Row(
          spacing: Grid.xs,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            SvgPicture.asset(
              ImagesPath.plus,
              width: 17,
              height: 17,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Text(
              L10n.tr('hesap_ekle'),
              textAlign: TextAlign.end,
              style: context.pAppStyle.labelReg16primary,
            ),
          ],
        ),
      ),
    );
  }
}
