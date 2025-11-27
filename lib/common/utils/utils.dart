import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_tile.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Widget generateCapitalFallback(BuildContext context, String symbolName, {double size = 14}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          symbolName.isEmpty ? '-' : symbolName.characters.first,
          style: TextStyle(
            color: context.pColorScheme.darkHigh,
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void setListPageEvent({
    String? pageName,
    String eventName = AnalyticsEvents.listingPageView,
  }) {
    List<String> breadCrumbs = router.routeNames.toList();
    if (breadCrumbs.isNotEmpty && breadCrumbs.last != pageName) {
      breadCrumbs.add(pageName ?? router.routeNames.last);
      getIt<Analytics>().track(
        eventName,
        properties: {
          'taxonomy': breadCrumbs,
        },
      );
      getIt<Analytics>().screen(breadCrumbs.last);
    }
  }

  static Future<void> launchURL({
    required String url,
    LaunchMode mode = LaunchMode.inAppWebView,
  }) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.inAppWebView,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getDestination(String url) {
    final raw = remoteConfig.getValue('bannerDestinationControl').asString();
    if (raw.isEmpty) return url;

    final decoded = jsonDecode(raw);
    final List<dynamic> list = decoded['destination'] ?? [];

    for (final item in list) {
      final map = Map<String, dynamic>.from(item);

      if (map['loginDestination'] == url) {
        return map['nonLoginDestination'] as String? ?? url;
      }
    }
    return url;
  }

  static urlHandler(BuildContext context, String url) {
    if (url.startsWith('http') || url.startsWith('mailto:') || url.startsWith('tel:')) {
      launchURL(url: url);
      return;
    }

    if (url.startsWith('/profile')) {
      switch (url) {
        case '/profile':
          router.push(const ProfileRoute());
          break;
        case '/profile/account':
          router.push(
            const AccountInformationRoute(),
          );
          break;
        case '/profile/education':
          router.push(
            EducationRoute(title: L10n.tr('educations')),
          );
          break;
        case '/profile/licences':
          router.push(
            const LicensesRoute(),
          );
          break;
        case '/profile/order_transmission':
          router.push(
            const OrderSettingsRoute(),
          );
          break;
        case '/profile/agreements':
          router.push(
            AgreementsRoute(
              title: L10n.tr('mutabakatlarim'),
            ),
          );
          break;
        case '/profile/app_settings':
          router.push(
            const AppSettingsRoute(),
          );
          break;
        case '/profile/change_password':
          router.push(
            ChangePasswordRoute(
              onSuccess: (isSuccess, message) async {
                if (isSuccess) {
                  await router.maybePop();
                }
                PBottomSheet.showError(
                  NavigatorKeys.navigatorKey.currentContext!,
                  isSuccess: isSuccess,
                  content: L10n.tr(message),
                );
              },
            ),
          );
          break;
        case '/profile/contact_us':
          router.push(
            ContactUsRoute(
              title: L10n.tr('bize_ulasin'),
            ),
          );
          break;
        case '/profile/contracts':
          router.push(
            ContractsListRoute(
              title: L10n.tr('agreements'),
            ),
          );
          break;
        default:
      }

      return;
    }
    if (url == '/set_alarm') {
      router.push(
        MyAlarmsRoute(),
      );
      return;
    }

    if (url.startsWith('/createaccount')) {
      router.popUntilRoot();
      router.replace(
        CreateAccountRoute(),
      );
      return;
    }

    if (url.startsWith('/uscreateaccount')) {
      getIt<GlobalAccountOnboardingBloc>().add(
        AccountSettingStatusEvent(
          succesCallback: (accountSettingStatus) {
            AlpacaAccountStatusEnum? alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
              (e) => e.value == accountSettingStatus.accountStatus,
            );
            if (alpacaAccountStatus == null || alpacaAccountStatus == AlpacaAccountStatusEnum.rejected) {
              router.push(
                const GlobalAccountOnboardingRoute(),
              );
            } else {
              getIt<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 2,
                  marketMenu: MarketMenu.americanStockExchanges,
                ),
              );
            }
          },
        ),
      );
      return;
    }

    if (url.startsWith('/transfers/withdrawmoneyfromaccount/quickcash')) {
      router.push(
        WithdrawMoneyFromAccountRoute(
          currencyType: CurrencyEnum.values[0],
          comeFromBanner: true,
        ),
      );
      return;
    }
    if (url.startsWith('/public_offering')) {
      getIt<TabBloc>().add(
        const TabChangedEvent(
          tabIndex: 2,
          marketMenu: MarketMenu.ipo,
        ),
      );
    }
    if (url.startsWith('/public_offering_detail')) {
      RegExp regex = RegExp(r"\{([^}]+)\}");
      Match? match = regex.firstMatch(url);
      if (match != null) {
        String ipoId = match.group(1)!;
        getIt<IpoBloc>().add(
          GetIpoDetailsByIdEvent(
            ipoId: int.parse(ipoId),
            callback: (IpoModel ipoModel) {
              Uint8List? decodedBytesUint8List =
                  ipoModel.companyLogo != null ? base64.decode(ipoModel.companyLogo!) : null;
              router.push(
                IpoDetailRoute(
                  symbolLogo: decodedBytesUint8List,
                  ipo: ipoModel,
                  id: ipoModel.id,
                  onSuccess: () {},
                ),
              );
            },
          ),
        );
        return;
      }
    }

    if (url.startsWith('/symbol/detail')) {
      String symbolCode = url.split('/symbol/detail?symbol=').last;
      getIt<SymbolBloc>().add(
        GetSymbolTypesEvent(
          symbolList: [symbolCode],
          callback: (symbolTypesList) {
            SymbolTypes symbolTypes = stringToSymbolType(symbolTypesList[symbolCode]?.symbolType ?? '');
            Utils().routeToDetail(symbolCode, symbolTypes);
          },
        ),
      );

      return;
    }
    if (url == '/portfolio') {
      getIt<TabBloc>().add(
        const TabChangedEvent(
          tabIndex: 3,
        ),
      );
      return;
    }

    if (url.startsWith('/fund/detail')) {
      RegExp regex = RegExp(r"\{([^}]+)\}");
      Match? match = regex.firstMatch(url);
      if (match != null) {
        String fundCode = match.group(1)!;
        router.push(
          FundDetailRoute(
            fundCode: fundCode,
          ),
        );
      }
      return;
    }

    if (url.startsWith('/eurobond/detail')) {
      RegExp regex = RegExp(r"\{([^}]+)\}");
      Match? match = regex.firstMatch(url);
      if (match != null) {
        String bondCode = match.group(1)!;
        getIt<EuroBondBloc>().add(
          GetBondListEvent(
            finInstId: '',
            onSuccess: (EuroBondListModel bond) {
              Bonds selectedEuroBond = bond.bonds!.firstWhere((element) => element.name == bondCode);
              router.push(
                EuroBondDetailRoute(
                  selectedEuroBond: selectedEuroBond,
                  transactionStartTime: bond.transactionStartTime!,
                  transactionEndTime: bond.transactionEndTime!,
                ),
              );
            },
          ),
        );

        getIt<EuroBondBloc>().add(
          GetBondListEvent(
            finInstId: bondCode,
            onSuccess: (EuroBondListModel bond) => router.push(
              EuroBondDetailRoute(
                selectedEuroBond: bond.bonds!.first,
                transactionStartTime: bond.transactionStartTime!,
                transactionEndTime: bond.transactionEndTime!,
              ),
            ),
          ),
        );
      }
      return;
    }
    if (url.startsWith('/warrant/calculate')) {
      RegExp regex = RegExp(r"\{([^}]+)\}");
      Match? match = regex.firstMatch(url);
      if (match != null) {
        String warrantCode = match.group(1)!;

        ///verilen warrantin detaylarını alıp hesaplama sayfasına yönlendirme
        getIt<SymbolBloc>().add(
          GetSymbolDetailEvent(
            symbolName: warrantCode,
            callback: (marketListModel) {
              router.push(
                WarrantCalculateRoute(
                  symbol: marketListModel,
                ),
              );
            },
          ),
        );
      }
    }

    if (url.startsWith('/market')) {
      switch (url.split('?tab=').last) {
        case 'lists':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.favorites,
            ),
          );
          break;
        case 'equity_bist':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.istanbulStockExchange,
              marketMenuTabIndex: 0,
            ),
          );
          break;
        case 'warrant_bist':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.istanbulStockExchange,
              marketMenuTabIndex: 2,
            ),
          );
          break;
        case 'viop_bist':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.istanbulStockExchange,
              marketMenuTabIndex: 1,
            ),
          );
          break;
        case 'fund':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.investmentFund,
            ),
          );
          break;
        case 'currency_parity':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.currencyParity,
            ),
          );
          break;
        case 'crypto_currency':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.crypto,
            ),
          );
          break;
        case 'initial_public_offering':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.ipo,
            ),
          );
          break;
        case 'eurobond':
          getIt<TabBloc>().add(
            const TabChangedEvent(
              tabIndex: 2,
              marketMenu: MarketMenu.eurobond,
            ),
          );
          break;
        default:
      }

      return;
    }

    if (url.startsWith('/orders')) {
      switch (url.split('&tab=').last) {
        case 'waiting':
          getIt.get<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 1,
                  ordersTabIndex: 0,
                ),
              );
          break;
        case 'completed':
          getIt.get<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 1,
                  ordersTabIndex: 1,
                ),
              );
          break;
        case 'deleted':
          getIt.get<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 1,
                  ordersTabIndex: 2,
                ),
              );
          break;
        default:
      }
      return;
    }
  }

  Widget profitLossPercentWidget({
    required BuildContext context,
    required double performance,
    required bool isVisible,
    bool? isTruePercentData,
    double? fontSize,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          performance > 0
              ? ImagesPath.trending_up
              : performance < 0
                  ? ImagesPath.trending_down
                  : ImagesPath.trending_notr,
          height: fontSize ?? Grid.m,
          colorFilter: ColorFilter.mode(
            performance > 0
                ? context.pColorScheme.success
                : performance < 0
                    ? context.pColorScheme.critical
                    : context.pColorScheme.iconPrimary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: Grid.xxs),
        Text(
          isVisible
              ? '%${MoneyUtils().readableMoney(performance * (isTruePercentData ?? true ? 1 : 100))}'
                  .formatNegativePriceAndPercentage()
              : '%**',
          style: context.pAppStyle.interMediumBase.copyWith(
            fontSize: fontSize ?? Grid.m,
            color: performance > 0
                ? context.pColorScheme.success
                : performance < 0
                    ? context.pColorScheme.critical
                    : context.pColorScheme.iconPrimary,
          ),
        ),
      ],
    );
  }

  double getPriceStep(
    double value,
    String? symbolTypeName,
    String? marketCode,
    String? subMarketCode,
    double priceStep,
  ) {
    if (symbolTypeName == null) return 0.01;
    SymbolTypes type = stringToSymbolType(symbolTypeName);
    Map<String, dynamic> steps = getIt<AppInfoBloc>().state.priceSteps;
    if (type == SymbolTypes.future || type == SymbolTypes.option) {
      if (subMarketCode == 'SSF') {
        if (steps['SSF'].runtimeType == double) {
          return steps['SSF'];
        } else {
          List priceStepLimit = steps['SSF'];
          for (Map<String, dynamic> item in priceStepLimit) {
            if (value < item['UpperLimit']!) {
              return item['PriceStep']!;
            }
          }
        }
      } else {
        return priceStep;
      }
    }
    List priceStepLimit = steps[type.matriks];
    for (Map<String, dynamic> item in priceStepLimit) {
      if (value < item['UpperLimit']!) {
        return item['PriceStep']!;
      }
    }
    return 0.01; // default value if no match found
  }

  void appendNewIpos(
    List<IpoModel> ipoList,
    int page,
    PagingController pagingController,
    bool showLastPrice,
    bool canRequest, [
    VoidCallback? onSuccess,
  ]) {
    final List<Widget> ipoTileList = _prepareIpos(
      ipoList,
      pagingController,
      showLastPrice,
      canRequest,
      onSuccess!,
    );

    if (page == 0) {
      pagingController.itemList?.clear();
    }

    final isLastPage = ipoTileList.length < IpoConstant.ipoPaginationListLength;

    if (isLastPage) {
      pagingController.appendLastPage(ipoTileList);
    } else {
      pagingController.appendPage(ipoTileList, page + 1);
    }
  }

  List<Widget> _prepareIpos(
    List<IpoModel> ipoList,
    PagingController pagingController,
    bool showLastPrice,
    bool canRequest,
    VoidCallback onSuccess,
  ) {
    return ipoList.asMap().entries.map((ipos) {
      int index = ipos.key;

      return IpoTile(
        ipo: ipos.value,
        showLastPrice: showLastPrice,
        canRequest: canRequest,
        onSuccess: onSuccess,
        dividerTopPadding: 13,
        showDivider: index != ipoList.length - 1, // son item'in altına divider koymayı engellemek için.
      );
    }).toList();
  }

  static SymbolTypes? getSybolTypeFromGroupCode(String groupCode) {
    SymbolTypes? symbolType;
    if (['V'].contains(groupCode.toUpperCase())) {
      symbolType = SymbolTypes.warrant;
    } else if (['F', 'F1', 'F2'].contains(groupCode.toUpperCase())) {
      symbolType = SymbolTypes.etf;
    } else if (['S1', 'C'].contains(groupCode.toUpperCase())) {
      symbolType = SymbolTypes.certificate;
    } else if (['R'].contains(groupCode.toUpperCase())) {
      symbolType = SymbolTypes.right;
    } else {
      symbolType = null;
    }
    return symbolType;
  }

  static String symbolNameWithoutSuffix(String symbolName, SymbolTypes? symbolType, {String? suffix}) {
    String strippedSymbol = symbolName.split(' ')[0];
    if (getIt<AppInfoBloc>().state.symbolSuffixList.any((e) => e.nameWithSuffix == strippedSymbol)) {
      return getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((e) => e.nameWithSuffix == strippedSymbol).name;
    }
    if (strippedSymbol.contains('.HE')) {
      return strippedSymbol.replaceAll('.HE', 'H');
    }
    if (strippedSymbol.endsWith('V') && symbolType == SymbolTypes.warrant) {
      return symbolName.substring(0, symbolName.length - 1);
    }
    if (symbolType == SymbolTypes.certificate &&
        suffix != null &&
        (suffix == 'S1' || suffix == 'C') &&
        strippedSymbol.endsWith(suffix)) {
      return strippedSymbol.substring(0, strippedSymbol.length - suffix.length);
    }
    if (symbolType == SymbolTypes.etf && suffix != null && ['F1', 'F2', 'F'].contains(suffix)) {
      return strippedSymbol.substring(0, strippedSymbol.length - suffix.length);
    }
    if (symbolType == SymbolTypes.right && symbolName.endsWith('R')) {
      return '${symbolName.substring(0, symbolName.length - 1)}.$suffix';
    }
    return symbolName;
  }

  static String symbolNameAddSuffix(String symbolName, SymbolTypes? symbolType, {String? suffix}) {
    String strippedSymbol = symbolName.split(' ')[0];
    if (getIt<AppInfoBloc>().state.symbolSuffixList.any((e) => e.name == strippedSymbol)) {
      return getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((e) => e.name == strippedSymbol).nameWithSuffix;
    }
    if (strippedSymbol.contains('.HE')) {
      return strippedSymbol.replaceAll('.HE', 'H');
    }
    if (symbolType == SymbolTypes.warrant) {
      return '${symbolName}V';
    }
    if (symbolType == SymbolTypes.certificate && suffix != null && (suffix == 'S1' || suffix == 'C')) {
      return strippedSymbol + suffix;
    }
    if (symbolType == SymbolTypes.etf && suffix != null && ['F1', 'F2', 'F'].contains(suffix)) {
      return strippedSymbol + suffix;
    }
    if (symbolType == SymbolTypes.right) {
      return symbolName.replaceAll('.', '');
    }
    return symbolName;
  }

  void showErrorMessage({
    required String text,
    Function()? action,
    String? errorCode,
    required BuildContext context,
  }) {
    bool isMultiConnect = text.endsWith('900000001');
    bool isInvalid = text.endsWith('invalid_token') ||
        text.endsWith('Invalid Token') ||
        text.endsWith('Unauthorized') ||
        text.endsWith(L10n.tr('invalid_token'));
    try {
      getIt<AppInfoBloc>().add(
        ErrorAlertEvent(
          status: true,
          callback: () {
            return PBottomSheet.showError(
              showCloseButton: true,
              context,
              content: isInvalid ? L10n.tr('invalid_token') : L10n.tr(text),
              errorCode: errorCode != null && errorCode != '' ? '(${'${L10n.tr('errorCode')}: $errorCode'})' : '',
              filledButtonText: L10n.tr('tamam'),
              isDismissible: false,
              enableDrag: false,
              showFilledButton: true,
              onFilledButtonPressed: () {
                router.maybePop();
                action?.call();
                if (isInvalid || isMultiConnect) {
                  getIt<AuthBloc>().add(
                    const LogoutEvent(),
                  );
                  getIt<AvatarBloc>().add(
                    LogoutAvatarEvent(),
                  );

                  //tüm sayfaları kapatarak dashboardu açıyoruz
                  router.replaceAll([
                    DashboardRoute(
                      key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                    ),
                  ]);

                  Future.delayed(
                    const Duration(
                      milliseconds: 100,
                    ),
                    () {
                      // sonra auth routea yönlendiriyoruz
                      router.replace(
                        AuthRoute(),
                      );
                    },
                  );

                  getIt<TabBloc>().add(
                    const TabChangedEvent(
                      tabIndex: 0,
                    ),
                  );
                }

                getIt<AppInfoBloc>().add(
                  ErrorAlertEvent(
                    status: false,
                  ),
                );
              },
            );
          },
        ),
      );
    } catch (e) {
      getIt<AppInfoBloc>().add(
        ErrorAlertEvent(
          status: false,
        ),
      );
    }
  }

  static bool shouldWarnBeforeBuy({
    required OrderActionTypeEnum orderActionType,
    String marketCode = '',
    String swapType = '',
    String actionType = '',
  }) {
    if (orderActionType == OrderActionTypeEnum.buy &&
        (marketCode == 'T' || swapType == 'BRUT' || ['T', 'P'].contains(actionType))) {
      return true;
    }
    return false;
  }

  static String prepareWarnMessagesOnBuy({
    String symbolCode = '',
    String marketCode = '',
    String swapType = '',
    String actionType = '',
    String typeCode = '',
  }) {
    String messages = '';
    if (typeCode.isNotEmpty && stringToSymbolType(typeCode) == SymbolTypes.warrant) {
      messages = L10n.tr(
        'marketMakerWarning',
        args: [
          symbolCode,
        ],
      );
      return messages;
    }
    if (marketCode == 'W') {
      messages = '${L10n.tr(
        'close_monitoring_market_title',
        args: [
          symbolCode,
        ],
      )}\n\n${L10n.tr('close_monitoring_market_warning')}';
      return messages;
    }
    if (marketCode == 'S') {
      messages = '${L10n.tr(
        'premarketing_trading_title',
        args: [
          symbolCode,
        ],
      )}\n\n${L10n.tr('premarketing_trading_warning')}';
      return messages;
    }
    if (marketCode == 'T' || actionType == 'T' || actionType == 'P') {
      messages += '${L10n.tr(
        'downstreamMarketWarning',
        args: [
          symbolCode,
        ],
      )}\n';
      if (actionType != 'P') {
        messages += '\n${L10n.tr('downstreamMarketWarningDesc')}\n';
      }
    }
    if (actionType == 'T') {
      messages += '\n${L10n.tr(
        'flatPriceWarning',
        args: [
          symbolCode,
        ],
      )}\n';
    }
    if (marketCode != 'T' && swapType == 'BRUT') {
      messages += '\n${L10n.tr(
        'brutSwapWarning',
        args: [
          symbolCode,
        ],
      )}\n';
    }
    return messages;
  }

  bool canTradeAmericanMarket() {
    //müşteri dijital ve kurumsal değilse
    return UserModel.instance.customerChannel == '10-Dijital' && UserModel.instance.innerType != 'INSTITUTION';
  }

  void showBiometricAlert(
    BuildContext context,
  ) {
    PBottomSheet.showThemeDynamic(
      context,
      isDismissible: false,
      enableDrag: false,
      childBuilder: () => Column(
        children: [
          SvgPicture.asset(
            ImagesPath.info,
            width: 60,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr('enable_biometric_login'),
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
      ),
      positiveAction: PBottomSheetAction(
        text: L10n.tr('tamam'),
        action: () async {
          getIt<AppSettingsBloc>().add(
            SetGeneralSettingsEvent(
              touchFaceId: true,
            ),
          );
          getIt<LocalStorage>().write(
            LocalKeys.showBiometricLogin,
            true,
          );
          router.maybePop();
        },
      ),
      negativeAction: PBottomSheetAction(
        text: L10n.tr('vazgec'),
        action: () {
          getIt<AppSettingsBloc>().add(
            SetGeneralSettingsEvent(
              touchFaceId: false,
            ),
          );
          getIt<LocalStorage>().write(
            LocalKeys.showBiometricLogin,
            false,
          );
          router.maybePop();
        },
      ),
    );
  }

  void showConnectivityAlert({
    required BuildContext context,
    Function()? action,
  }) {
    PBottomSheet.showError(
      context,
      content: L10n.tr('no_internet'),
      showFilledButton: true,
      filledButtonText: L10n.tr('tamam'),
      onFilledButtonPressed: action ?? () => router.maybePop(),
    );
  }

  /// toLowerCase().compareTo; türkçe karakterlere göre sıralama yapmadığı için
  /// bu fonksiyonu yazıldı.
  int sortIncludeTurkishCharacter(String a, String b) {
    a = a.toLowerCase();
    b = b.toLowerCase();

    int minLength = a.length < b.length ? a.length : b.length;

    const List<String> turkishAlphabet = [
      'a',
      'b',
      'c',
      'ç',
      'd',
      'e',
      'f',
      'g',
      'ğ',
      'h',
      'ı',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'ö',
      'p',
      'r',
      's',
      'ş',
      't',
      'u',
      'ü',
      'v',
      'y',
      'z'
    ];

    for (int i = 0; i < minLength; i++) {
      String charA = a[i];
      String charB = b[i];

      int indexA = turkishAlphabet.indexOf(charA);
      int indexB = turkishAlphabet.indexOf(charB);

      if (indexA != indexB) {
        return indexA.compareTo(indexB);
      }
    }

    // Eğer ilk harfler aynıysa kısa olan önce gelir
    return a.length.compareTo(b.length);
  }

  void showCustomerServiceCallAlert(
    BuildContext context,
    String content,
  ) {
    PBottomSheet.showError(
      context,
      content: content,
      showFilledButton: true,
      showOutlinedButton: true,
      outlinedButtonText: L10n.tr('vazgeç'),
      filledButtonText: L10n.tr('ara'),
      onFilledButtonPressed: () => Utils().makePhoneCall('4447333'),
      filledButtonIconPath: ImagesPath.arrow_up_right,
    );
  }

  void makePhoneCall(String phone) async {
    router.maybePop();

    Uri url = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(url)) {
      launchUrl(url);
    }
  }

  void routeToDetail(String symbolCode, SymbolTypes symbolType) {
    if (symbolType == SymbolTypes.fund) {
      router.push(
        FundDetailRoute(fundCode: symbolCode),
      );
      return;
    }
    if (symbolType == SymbolTypes.foreign) {
      router.push(
        SymbolUsDetailRoute(symbolName: symbolCode),
      );
      return;
    }
    router.push(
      SymbolDetailRoute(
        symbol: MarketListModel(
          symbolCode: symbolCode,
          type: symbolType.dbKey,
          symbolType: symbolType.dbKey,
          updateDate: '',
        ),
      ),
    );
  }
}
