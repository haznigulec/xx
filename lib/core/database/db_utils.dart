import 'dart:developer';

import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:sqflite/sqflite.dart';

class DBUtils {
  final Batch batch;

  DBUtils(this.batch);

  Future<void> updateSymbols(Database db, List<dynamic> symbols) async {
    log(DateTime.now().toString());
    log('Symbols start');
    DateTime now = DateTime.now();
    List<SymbolModel> expiredSymbols = [];

    try {
      for (var symbol in symbols) {
        final bool isExpired = (symbol['maturityDate'] != null &&
                DateTime.parse(symbol['maturityDate']).isBefore(DateTime(now.year, now.month, now.day))) ||
            (symbol['tradingEndDate'] != null &&
                DateTime.parse(symbol['tradingEndDate']).isBefore(DateTime(now.year, now.month, now.day)));
        Map<String, dynamic> data = {
          'Name': symbol['name'],
          'MarketCode': symbol['marketCode'],
          'ExchangeCode': symbol['exchangeCode'],
          'SectorCode': symbol['sectorCode'],
          'Description': symbol['description'],
          'IsinCode': symbol['isinCode'],
          'UnderlyingName': symbol['underlyingName'],
          'Status': symbol['status'],
          'Issuer': symbol['issuer'],
          'DecimalCount': symbol['decimalCount'],
          'SymbolCode': symbol['symbolCode'],
          'TradeStatus': symbol['tradeStatus'],
          'SedolCode': symbol['sedolCode'],
          'RicCode': symbol['ricCode'],
          'OptionType': symbol['optionType'],
          'MaturityDate': symbol['maturityDate'],
          'OptionClass': symbol['optionClass'],
          'StrikePrice': symbol['strikePrice'],
          'Multiplier': symbol['multiplier'],
          'Ratio': symbol['ratio'],
          'SettlementType': symbol['settlementType'],
          'TradingStartDate': symbol['tradingStartDate'],
          'SubMarketCode': symbol['subMarketCode'],
          'TradingEndDate': symbol['tradingEndDate'],
          'MarketMaker': symbol['marketMaker'],
          'MatriksSymbolId': symbol['matriksSymbolId'],
          'TypeCode': symbol['typeCode'],
          'SwapType': symbol['swapType'],
          'ActionType': symbol['actionType'],
          'TradingType': symbol['tradingType'],
          'Suffix': symbol['suffix'],
          'BistCode': symbol['bistCode'],
          'MultiSession': symbol['multiSession'] == true ? 1 : 0,
        };
        
        if (data['Status'] == 0 || isExpired) {
          batch.delete('Symbols', where: 'Name = ?', whereArgs: [data['Name']]);
          expiredSymbols.add(SymbolModel.fromMap(data));
        } else {
          batch.insert(
            'Symbols',
            data,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      log('Symbols end');
    } catch (e) {
      log('failed symbol table: $e');
    }
    if (expiredSymbols.isNotEmpty) {
      getIt<SymbolSearchBloc>().add(
        RemoveExpiredOldSearchesEvent(expiredSymbols: expiredSymbols),
      );
    }
  }

  Future<void> updateExchanges(Database db, List<dynamic> exchanges) async {
    log('Exchanges start');
    for (var item in exchanges) {
      Map<String, dynamic> data = {
        'Code': item['code'],
        'TrName': item['name'],
        'EnName': item['nameEn'] ?? '',
        'TrDescription': item['description'],
        'EnDescription': item['descriptionEn'],
        'Status': item['status'],
        'DisplayOnFilter': item['displayOnFilter'] ? 1 : 0,
        'Order': item['order'],
      };
      batch.insert(
        'Exchanges',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log('Exchanges end');
  }

  Future<void> updateSectors(Database db, List<dynamic> sectors) async {
    log('Sectors start');
    for (var sector in sectors) {
      Map<String, dynamic> data = {
        'Code': sector['code'],
        'TrName': sector['name'],
        'EnName': sector['nameEn'],
        'TrDescription': sector['description'],
        'EnDescription': sector['descriptionEn'],
        'Status': sector['status'],
      };
      batch.insert(
        'Sectors',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log('Sectors end');
  }

  Future<void> updateMarkets(Database db, List<dynamic> markets) async {
    log('Markets start');
    for (var market in markets) {
      Map<String, dynamic> data = {
        'Code': market['code'],
        'TrName': market['name'] ?? '',
        'EnName': market['nameEn'] ?? '',
        'TrDescription': market['description'] ?? '',
        'EnDescription': market['descriptionEn'] ?? '',
        'Status': market['status'],
        'Order': market['order'] ?? 1,
      };
      batch.insert(
        'Markets',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log('Markets end');
  }

  Future<void> updateSubMarkets(Database db, List<dynamic> subMarkets) async {
    log('SubMarkets start');
    for (var subMarket in subMarkets) {
      Map<String, dynamic> data = {
        'Code': subMarket['code'] ?? '',
        'MatriksSubMarketId': subMarket['matriksSubMarketId'],
        'MatriksSubMarketCode': subMarket['matriksSubMarketCode'],
        'TrDescription': subMarket['trDescription'] ?? '',
        'EnDescription': subMarket['enDescription'] ?? '',
        'Status': subMarket['status'],
        'Order': subMarket['order'] ?? 1,
      };
      batch.insert(
        'SubMarkets',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log('SubMarkets end');
  }

  Future<void> updateSymbolTypes(Database db, List<dynamic> symbolTypes) async {
    log('SymbolTypes start');
    for (var symbolType in symbolTypes) {
      Map<String, dynamic> data = {
        'Code': symbolType['code'],
        'TrName': symbolType['name'],
        'EnName': symbolType['nameEn'],
        'Status': symbolType['status'],
      };
      batch.insert(
        'SymbolType',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    log('SymbolTypes end');
  }

  Future<void> updateSymbolMembers(Database db, List<dynamic> symbolMembers) async {
    log('SymbolMembers start');
    for (var symbolMember in symbolMembers) {
      Map<String, dynamic> data = {
        'MainSymbolName': symbolMember['mainSymbolName'],
        'ChildSymbolName': symbolMember['childSymbolName'],
        'Status': symbolMember['status'],
        'Key': '${symbolMember['mainSymbolName']}${symbolMember['childSymbolName']}',
      };
      if (data['Status'] == 0) {
        batch.delete(
          'SymbolMembers',
          where: 'Key = ?',
          whereArgs: [
            '${symbolMember['mainSymbolName']}${symbolMember['childSymbolName']}',
          ],
        );
      } else {
        batch.insert(
          'SymbolMembers',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    log('SymbolMembers end');
  }

  Future<void> updateFinancialInstitutions(Database db, List<dynamic> financialInstitutions) async {
    log('FinancialInstitutions start');
    for (var institutions in financialInstitutions) {
      Map<String, dynamic> data = {
        'InstitutionCode': institutions['institutionCode'],
        'InstitutionName': institutions['institutionName'],
        'InstitutionType': institutions['institutionType'],
        'InstitutionTypeDescription': institutions['institutionTypeDescription'] ?? '',
        'InstitutionDisplayName': institutions['shortDisplayName'] ?? '',
      };
      batch.insert(
        'FinancialInstitutions',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    log('FinancialInstitutions end');
  }

  Future<void> updateFunds(Database db, List<dynamic> funds) async {
    log('Funds start');
    for (var fund in funds) {
      if (fund['isDeleted'] == true) {
        // Silinmesi gereken fon
        await db.delete(
          'Funds',
          where: 'Code = ?',
          whereArgs: [fund['code']],
        );
      } else {
        // Güncellenecek ya da eklenecek fon
        Map<String, dynamic> data = {
          'Code': fund['code'],
          'Title': fund['title'],
          'FounderCode': fund['founderCode'],
          'CustomDescription': fund['customDescription'] ?? '',
          'MainType': fund['mainType'],
          'MainTypeCode': fund['mainTypeCode'],
          'SubType': fund['subType'],
          'SubTypeCode': fund['subTypeCode'],
          'FundTitleType': fund['fundTitleType'],
          'FundTitleTypeCode': fund['fundTitleTypeCode'],
          'TefasStatus': fund['tefasStatus'] ? 1 : 0,
          'IsDeleted': 0,
        };

        batch.insert(
          'Funds',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    log('Funds end');
  }

  Future<void> commitBatch() async {
    await batch.commit(noResult: true);
    log(DateTime.now().toString());
  }
}
