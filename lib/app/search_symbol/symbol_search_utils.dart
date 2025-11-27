import 'dart:convert';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/parity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class SymbolSearchUtils {
  static void goSymbolDetail({List<SymbolSearchFilterEnum>? filterList}) {
    router.push(
      SymbolSearchRoute(
        selectedFilter: SymbolSearchFilterEnum.all,
        filterList: filterList,
        onTapSymbol: (symbolModelList) {
          SymbolTypes symbolType = stringToSymbolType(symbolModelList.first.typeCode);
          if (symbolType == SymbolTypes.foreign) {
            router.push(
              SymbolUsDetailRoute(
                symbolName: symbolModelList.first.name,
              ),
            );
          } else if (symbolType == SymbolTypes.fund) {
            router.push(
              FundDetailRoute(
                fundCode: symbolModelList.first.name,
              ),
            );
          } else {
            router.push(
              SymbolDetailRoute(
                symbol: MarketListModel(
                  symbolCode: symbolModelList.first.name,
                  type: symbolModelList.first.typeCode,
                  description: symbolModelList.first.description,
                  underlying: symbolModelList.first.underlyingName,
                  updateDate: '',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// sembol aramada secilen sembolun tipine gore al sat ekranina yoneldiriri
  static void goCreateSymbol(
    MarketListModel marketListModel,
    OrderActionTypeEnum action,
    SymbolTypes currentSymbolType,
    String currentRouteName,
  ) {
    SymbolTypes symbolType = stringToSymbolType(marketListModel.type);

    if (symbolType == SymbolTypes.fund && currentSymbolType != SymbolTypes.fund) {
      router.popUntilRouteWithName(currentRouteName);
      router.replace(
        FundDetailRoute(
          fundCode: marketListModel.symbolCode,
        ),
      );
      return;
    }
    if ((symbolType == SymbolTypes.future || symbolType == SymbolTypes.option) &&
        currentSymbolType != SymbolTypes.future) {
      router.popUntilRouteWithName(currentRouteName);
      router.replace(
        CreateOptionOrderRoute(
          symbol: marketListModel,
          action: action,
        ),
      );
      return;
    }
    if (symbolType == SymbolTypes.foreign && currentSymbolType != SymbolTypes.foreign) {
      List<dynamic> disableTradeSymbols =
          jsonDecode(remoteConfig.getValue('disabledTradeSymbols').asString())['disabled_trade_symbols'] as List;
      if (Utils().canTradeAmericanMarket() &&
          UserModel.instance.alpacaAccountStatus &&
          !disableTradeSymbols.contains(marketListModel.symbolCode)) {
        router.popUntilRouteWithName(currentRouteName);
        router.replace(
          CreateUsOrderRoute(
            symbol: marketListModel.symbolCode,
            action: action,
          ),
        );
      } else {
        router.popUntilRouteWithName(currentRouteName);
        router.replace(
          SymbolUsDetailRoute(
            symbolName: marketListModel.symbolCode,
          ),
        );
      }
      return;
    }
    if ([
          SymbolTypes.equity,
          SymbolTypes.warrant,
          SymbolTypes.right,
          SymbolTypes.commodity,
          SymbolTypes.certificate,
        ].contains(symbolType) &&
        currentSymbolType != SymbolTypes.equity) {
      router.popUntilRouteWithName(currentRouteName);
      router.replace(
        CreateOrderRoute(
          symbol: marketListModel,
          action: action,
        ),
      );
      return;
    }
  }

  static bool isPreciousMetal(SymbolModel symbol) {
    final ex = symbol.exchangeCode;
    final mk = symbol.marketCode;
    final name = symbol.name.toUpperCase();

    final isForexPrecious =
        ex == ParityEnum.preciousMetals.exchangeCode && ParityEnum.preciousMetals.marketCode.contains(mk);
    final isTcmAltin = ex == ParityEnum.tcmbRates.exchangeCode &&
        ParityEnum.tcmbRates.marketCode.contains(mk) &&
        name.contains('ALTIN');

    return isForexPrecious || isTcmAltin;
  }
}
