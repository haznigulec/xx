import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_info_row_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_info_selectable_row_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/deposit_currency_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/inner_bank_list_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class DepositMoneyAccountPage extends StatefulWidget {
  final List<BankInfoModel>? bankList;
  final int? selectedIndex;
  const DepositMoneyAccountPage({
    super.key,
    this.bankList,
    this.selectedIndex,
  });

  @override
  State<DepositMoneyAccountPage> createState() => _DepositMoneyAccountPageState();
}

class _DepositMoneyAccountPageState extends State<DepositMoneyAccountPage> {
  late BankInfoModel _selectedBank;
  CurrencyEnum _selectedCurreny = CurrencyEnum.turkishLira;
  List<BankInfoModel> _bankList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (getIt<AppInfoBloc>().state.bankModel != null && getIt<AppInfoBloc>().state.bankModel!.bankInfos != null) {
      _bankList = widget.bankList ?? getIt<AppInfoBloc>().state.bankModel!.bankInfos!;
    }

    if (_bankList.isEmpty) {
      router.maybePop().then((_) {
        if (context.mounted) {
          PBottomSheet.showError(
            NavigatorKeys.navigatorKey.currentContext ?? context,
            content: L10n.tr('no_data'),
            filledButtonText: L10n.tr('tamam'),
          );
        }
      });
      return;
    }
    _selectedBank = _bankList[widget.selectedIndex ?? 0];
    if (_selectedBank.usdIban?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await _onSelectCurrency();
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // bellek sızıntısını önlemek için
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !openUygunlukTestiAfterWelcomeScreen,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && openUygunlukTestiAfterWelcomeScreen) {
          setState(() {
            openUygunlukTestiAfterWelcomeScreen = false;
          });
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              router.pop(context);
              router.push(
                ContractsSurveyRoute(title: L10n.tr('uygunluk_testi')),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: PInnerAppBar(
          title: L10n.tr('depositMoneyAccount'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            Grid.m,
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('choose_bank'),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      child: InnerBankListWidget(
                          scrollController: _scrollController,
                          bankList: _bankList,
                          selectedBank: _selectedBank,
                          onSelectedBank: (selectedBank) async {
                            setState(() {
                              _selectedBank = selectedBank;
                            });
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) async {
                                if (_selectedBank.usdIban?.isNotEmpty == true) {
                                  await _onSelectCurrency();
                                } else if (_selectedCurreny != CurrencyEnum.turkishLira) {
                                  setState(() {
                                    _selectedCurreny = CurrencyEnum.turkishLira;
                                  });
                                }
                              },
                            );
                          }),
                    ),
                  );

                  return;
                },
                child: Row(
                  children: [
                    Text(
                      _selectedBank.title ?? '',
                      style: context.pAppStyle.labelMed14primary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    SvgPicture.asset(
                      ImagesPath.chevron_down,
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.l - Grid.xs,
              ),
              BankInfoSelectableRowWidget(
                title: L10n.tr('account_type'),
                value: L10n.tr(_selectedCurreny.shortName),
                isSelectable: _selectedBank.usdIban?.isNotEmpty == true,
                onClick: () async {
                  await _onSelectCurrency();
                },
              ),
              const PDivider(),
              BankInfoRowWidget(
                title: L10n.tr('iban'),
                value: _selectedCurreny == CurrencyEnum.dollar ? _selectedBank.usdIban ?? '' : _selectedBank.iban ?? '',
                onTapCopy: () => _copyTextAndShowMessage(
                  context,
                  _selectedCurreny == CurrencyEnum.dollar ? _selectedBank.usdIban ?? '' : _selectedBank.iban ?? '',
                ),
              ),
              const PDivider(),
              BankInfoRowWidget(
                title: L10n.tr('alici'),
                value: getIt<AppInfoBloc>().state.bankModel!.recipientName ?? '',
                onTapCopy: () => _copyTextAndShowMessage(
                  context,
                  getIt<AppInfoBloc>().state.bankModel!.recipientName ?? '',
                ),
              ),
              const PDivider(),
              BankInfoRowWidget(
                title: L10n.tr('aciklama'),
                value: '${UserModel.instance.customerId} ${UserModel.instance.name}',
                onTapCopy: () =>
                    _copyTextAndShowMessage(context, '${UserModel.instance.customerId} ${UserModel.instance.name}'),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              PInfoWidget(
                infoText: L10n.tr('deposit_info'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _selectedBank.title != 'TakasBank'
            ? generalButtonPadding(
                context: context,
                child: PButtonWithIcon(
                  text: L10n.tr('continue_with_banking_application'),
                  height: 52,
                  fillParentWidth: true,
                  iconAlignment: IconAlignment.end,
                  icon: SvgPicture.asset(
                    ImagesPath.arrow_up_right,
                    width: 17,
                    height: 17,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.lightHigh,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => _goStore(),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Future _onSelectCurrency() async {
    CurrencyEnum? selectedCurrency = await PBottomSheet.show<CurrencyEnum?>(
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      context,
      title: L10n.tr('para_birimi'),
      child: const DepositCurrencyWidget(),
    );
    if (selectedCurrency != null && selectedCurrency != _selectedCurreny) {
      setState(() {
        _selectedCurreny = selectedCurrency;
      });
    }
  }

  Future<void> _goStore() async {
    String? appId = Platform.isAndroid ? _selectedBank.androidAppId : _selectedBank.iosAppId;
    if (appId == null) return;

    final Uri schemeUri = Uri.parse(_selectedBank.scheme!);
    final Uri webUri = Uri.parse(_selectedBank.webUrl!);

    if (await canLaunchUrl(schemeUri)) {
      await launchUrl(schemeUri);
    } else {
      if (Platform.isAndroid) {
        String playStoreUrl = 'https://play.google.com/store/apps/details?id=$appId';
        final Uri playStoreUri = Uri.parse(playStoreUrl);
        if (await canLaunchUrl(playStoreUri)) {
          await launchUrl(playStoreUri);
        } else {
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri);
          } else {
            throw 'Yönlendirme yapılırken bir hata oluştu.';
          }
        }
      } else if (Platform.isIOS) {
        String appStoreUrl = 'https://apps.apple.com/app/id/$appId';
        final Uri appStoreUri = Uri.parse(appStoreUrl);
        if (await canLaunchUrl(appStoreUri)) {
          await launchUrl(appStoreUri);
        } else {
          if (await canLaunchUrl(webUri)) {
            await launchUrl(webUri);
          } else {
            throw 'Yönlendirme yapılırken bir hata oluştu.';
          }
        }
      } else {
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri);
        } else {
          throw 'Yönlendirme yapılırken bir hata oluştu.';
        }
      }
    }
  }

  void _copyTextAndShowMessage(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 90,
        left: MediaQuery.sizeOf(context).width * 0.1,
        width: MediaQuery.sizeOf(context).width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Row(
            spacing: Grid.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagesPath.checkCircle,
                width: 19,
                height: 19,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                L10n.tr('kopyalandi'),
                style: context.pAppStyle.labelReg16textPrimary,
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
