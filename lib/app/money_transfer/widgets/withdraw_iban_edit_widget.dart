import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/utils/iban_utils.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WithdrawIbanEditWidget extends StatefulWidget {
  final List<CustomerBankAccountModel>? bankAccountList;
  final CustomerBankAccountModel selectedBank;
  final String selectedAccount;
  const WithdrawIbanEditWidget({
    super.key,
    required this.selectedBank,
    required this.bankAccountList,
    required this.selectedAccount,
  });

  @override
  State<WithdrawIbanEditWidget> createState() => _WithdrawIbanEditWidgetState();
}

class _WithdrawIbanEditWidgetState extends State<WithdrawIbanEditWidget> {
  final TextEditingController _tcIban = TextEditingController();
  final TextEditingController _tcAccountName = TextEditingController();
  final FocusNode _focusNodeIban = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodeName = FocusNode(canRequestFocus: false);
  late MoneyTransferBloc _moneyTransferBloc;

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();

    _tcIban.text = widget.selectedBank.ibanNo;
    _tcAccountName.text = widget.selectedBank.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.m,
        ),
        IgnorePointer(
          ignoring: true,
          child: PValueTextfieldWidget(
            controller: _tcIban,
            title: L10n.tr('iban'),
            valueTextStyle: context.pAppStyle.labelReg14primary,
            focusNode: _focusNodeIban,
            titleWidth: MediaQuery.sizeOf(context).width * .2,
            valueWidth: MediaQuery.sizeOf(context).width * .63,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              IbanFormatter(),
            ],
            onChanged: (deger) {
              setState(() {
                _tcIban.text = deger.toString();
              });
            },
            onSubmitted: (value) {
              setState(() {
                _tcIban.text = value;
                FocusScope.of(context).unfocus();
              });
            },
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        IgnorePointer(
          ignoring: true,
          child: PValueTextfieldWidget(
            controller: _tcAccountName,
            title: L10n.tr('account_name'),
            valueTextStyle: context.pAppStyle.labelReg14primary,
            focusNode: _focusNodeName,
            onChanged: (deger) {
              setState(() {
                _tcAccountName.text = deger.toString();
              });
            },
            onSubmitted: (value) {
              setState(() {
                _tcAccountName.text = value;
                FocusScope.of(context).unfocus();
              });
            },
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        OrderApprovementButtons(
          approveButtonText: L10n.tr('sil'),
          onPressedApprove: () async {
            if (widget.bankAccountList != null &&
                widget.bankAccountList!.isNotEmpty &&
                widget.bankAccountList!.length == 1) {
              return PBottomSheet.show(
                context,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    spacing: Grid.m,
                    children: [
                      SvgPicture.asset(
                        ImagesPath.alert_circle,
                        width: 52,
                        height: 52,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        L10n.tr(
                          'least_registered_bank_account',
                        ),
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                    ],
                  ),
                ),
              );
            }

            _moneyTransferBloc.add(
              DeleteCustomerBankAccountEvent(
                accountId: widget.selectedAccount.split('-').last,
                bankAccountId: widget.selectedBank.bankAccId,
                onSuccess: (String message) async {
                  _moneyTransferBloc.add(
                    GetCustomerBankAccountsEvent(
                      accountId: widget.selectedAccount.split('-').last,
                    ),
                  );

                  await router.maybePop();
                  await router.maybePop();
                  await router.maybePop();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
