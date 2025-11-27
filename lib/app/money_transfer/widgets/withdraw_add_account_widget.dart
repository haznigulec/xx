import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_letter_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WithdrawAddAccountWidget extends StatefulWidget {
  final String selectedAccount;
  final bool isFirstIban;
  const WithdrawAddAccountWidget({
    super.key,
    required this.selectedAccount,
    required this.isFirstIban,
  });

  @override
  State<WithdrawAddAccountWidget> createState() => _WithdrawAddAccountWidgetState();
}

class _WithdrawAddAccountWidgetState extends State<WithdrawAddAccountWidget> {
  final TextEditingController _tcIban = TextEditingController();
  final TextEditingController _tcAccountName = TextEditingController();
  late AuthBloc _authBloc;
  late MoneyTransferBloc _moneyTransferBloc;
  final FocusNode _focusNodeAccountName = FocusNode(
    debugLabel: 'accountName',
  );
  final FocusNode _focusNodeIban = FocusNode(
    debugLabel: 'iban',
  );
  String? _maxDescriptionCharacter;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeAccountName.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PValueLetterTextfieldWidget(
          controller: _tcIban,
          focusNode: _focusNodeIban,
          title: L10n.tr('iban'),
          prefixText: 'TR',
          showSeperator: false,
          keyboardType: TextInputType.number,
          titleWidth: MediaQuery.sizeOf(context).width * .1,
          valueWidth: MediaQuery.sizeOf(context).width * .72,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            IbanInputFormatter(),
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
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Container(
          decoration: BoxDecoration(
            color: context.pColorScheme.card,
            borderRadius: BorderRadius.circular(
              Grid.m,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.s,
              horizontal: Grid.m,
            ),
            child: Row(
              spacing: Grid.xs,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        L10n.tr('account_name'),
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                      if (_maxDescriptionCharacter != null) ...[
                        const SizedBox(
                          height: Grid.s,
                        ),
                        Text(
                          _maxDescriptionCharacter!,
                          style: context.pAppStyle.interRegularBase.copyWith(
                            fontSize: Grid.s + Grid.xs,
                            color: context.pColorScheme.critical,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _tcAccountName,
                    focusNode: _focusNodeAccountName,
                    maxLength: 50,
                    maxLines: 2,
                    minLines: 1,
                    textAlign: TextAlign.right, // Metni sağa hizala
                    decoration: InputDecoration(
                      hintText: L10n.tr('optional'),
                      hintStyle: context.pAppStyle.labelReg14textTeritary,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterText: '', // Sayaç gizleniyor
                    ),
                    style: context.pAppStyle.labelReg14textPrimary.copyWith(
                      decoration: TextDecoration.none,
                      color: context.pColorScheme.primary,
                    ),
                    onChanged: (deger) {
                      setState(() {
                        _tcAccountName.text = deger.toString();

                        if (_tcAccountName.text.length == 50) {
                          _maxDescriptionCharacter = L10n.tr(
                            'withdraw_money_description_limit',
                            args: ['50'],
                          );
                        } else {
                          _maxDescriptionCharacter = null;
                        }
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _tcAccountName.text = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        PButton(
          text: L10n.tr('kaydet'),
          fillParentWidth: true,
          onPressed: () async {
            if (_tcIban.text.isEmpty) {
              PBottomSheet.show(
                context,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
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
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Text(
                        L10n.tr('please_enter_iban'),
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                    ],
                  ),
                ),
              );

              return;
            } else if (_tcIban.text.length != 29) {
              PBottomSheet.show(
                context,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
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
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Text(
                        L10n.tr('IBAN_numarasi_24_karakterli_olmalidir'),
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                    ],
                  ),
                ),
              );

              return;
            } else {
              _authBloc.add(
                RequestOtpEvent(
                  customerId: UserModel.instance.customerId ?? '',
                  onSuccess: (response) {
                    router.push(
                      CheckOtpRoute(
                        customerExtId: UserModel.instance.customerId ?? '',
                        otpDuration: response.data['otpTimeout'],
                        callOtpAfterClickButton: false,
                        onOtpValidated: (otp) {
                          _moneyTransferBloc.add(
                            AddCustomerBankAccountEvent(
                              customerAccountId: widget.selectedAccount.split('-')[1],
                              ibanNo: _tcIban.text.replaceAll(' ', ''),
                              otpCode: otp,
                              name: _tcAccountName.text,
                              onSuccess: (successMessage) async {
                                _moneyTransferBloc.add(
                                  GetCustomerBankAccountsEvent(
                                    accountId: widget.selectedAccount.split('-')[1],
                                  ),
                                );
                                router.push(
                                  InfoRoute(
                                    variant: InfoVariant.success,
                                    message: successMessage,
                                  ),
                                );

                                if (widget.isFirstIban) {
                                  await router.maybePop();
                                } else {
                                  await router.maybePop();
                                  await router.maybePop();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

/// IBAN formatına uygun olarak girilen karakterleri otomatik olarak düzenler.
class IbanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Eski ve yeni metinden boşlukları kaldırıyoruz
    String text = newValue.text.replaceAll(' ', '');

    // En fazla 26 karaktere izin ver (örneğin: TR123456789012345678901234)
    if (text.length > 24) {
      text = text.substring(0, 24);
    }

    // IBAN formatına uygun olarak her 4 karakterde bir boşluk ekleyelim
    String formattedText = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += text[i];
    }

    // Yeni text cursor pozisyonu
    int cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
