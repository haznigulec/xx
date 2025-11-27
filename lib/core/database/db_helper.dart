import 'dart:async';
import 'dart:convert';

import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db.dart';
import 'package:piapiri_v2/core/database/db_utils.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:sqflite/sqflite.dart';
import 'package:talker_dio_logger/dio_logs.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DatabaseHelper {
  static const columnId = 'Id';
  static const columnName = 'Name';
  static const columnTypeId = 'TypeId';
  static const tnSymbols = 'Symbols';
  static const tnSymbolTypes = 'SymbolType';
  static const tnSectors = 'Sectors';
  static const tnMarkets = 'Markets';
  static const tnExchanges = 'Exchanges';
  static const tnSymbolMembers = 'SymbolMembers';
  static const tnSubMarkets = 'SubMarkets';
  static const tnInstitutions = 'FinancialInstitutions';
  static const tnFunds = 'Funds';

  DB dbInstance = DB.instance;

  Future<List<Map<String, dynamic>>> getExchangeList() async {
    Database db = await dbInstance.database;

    // return db.rawQuery(
    //   'SELECT * FROM $tnExchanges WHERE TrName IS NOT NULL AND DisplayOnFilter = 1 ORDER BY "Order"',
    // );
    return db.query(
      tnExchanges,
      where: "TrName IS NOT NULL AND DisplayOnFilter = 1",
      orderBy: '"Order"',
    );
  }

  Future<List<Map<String, dynamic>>> searchSymbolByExchangeCode(
    String name,
    String selectedExchangeCode,
    bool filterTradeable,
    List<String>? typeCode,
  ) async {
    Database db = await dbInstance.database;
    return db.rawQuery("""
      SELECT
        s.*,
        m.TrName as MarketDesc
      FROM $tnSymbols s 
      LEFT JOIN $tnMarkets m on s.MarketCode = m.Code
      WHERE s.Name LIKE '%$name%' 
        AND s.ExchangeCode = '$selectedExchangeCode'
        ${selectedExchangeCode == 'BISTPP' ? "AND s.MarketCode != '1'" : ""}
        ${filterTradeable ? "AND s.TradeStatus = 1" : ""}
        ${typeCode != null && typeCode.isNotEmpty ? "AND s.TypeCode IN (${typeCode.map((tc) => "'$tc'").join(',')})" : ""}
      """);
  }

  Future<List<Map<String, dynamic>>> searchSymbol(String name, bool filterTradeable, List<String>? typeCode) async {
    Database db = await dbInstance.database;
    List<String> typeFilters = [];

    // JSON'dan gelen ExchangeCode filtrelerini WHERE koşuluna ekler
    getIt<SymbolSearchBloc>().state.symbolSort.forEach((tCode, exchangeCodes) {
      if (exchangeCodes.isNotEmpty) {
        String exchangeFilter = exchangeCodes.map((e) => "'$e'").join(', ');
        typeFilters.add("(s.TypeCode = '$tCode' AND s.ExchangeCode IN ($exchangeFilter))");
      }
    });

    // Eğer JSON'da ExchangeCode filtreleri varsa, onları WHERE koşuluna ekler
    String typeExchangeFilter = typeFilters.isNotEmpty ? "AND (${typeFilters.join(' OR ')})" : "";

    // Kullanıcının verdiği typeCode listesi varsa, sadece o TypeCode'ları filtrele
    String typeCodeFilter = (typeCode != null && typeCode.isNotEmpty)
        ? "AND s.TypeCode IN (${typeCode.map((tc) => "'$tc'").join(', ')})"
        : "";

    List<Map<String, dynamic>> symbolResults = await db.rawQuery("""
    SELECT DISTINCT *
    FROM (
      SELECT DISTINCT
        s.Name,
        s.Description,
        s.TypeCode,
        s.UnderlyingName,
        s.SymbolCode,
        s.TradeStatus,
        s.ExchangeCode, 
        s.MarketCode,
        s.Issuer
      FROM $tnSymbols s 
      WHERE s.Name LIKE '%${name.turkishToLatin()}%' 
        ${filterTradeable ? "AND s.TradeStatus = 1" : ""}
        AND (s.MaturityDate >= DATE('now') OR s.MaturityDate IS NULL)
        $typeCodeFilter
        $typeExchangeFilter
      UNION ALL
      SELECT
        s.Name,
        s.Description,
        s.TypeCode,
        s.UnderlyingName,
        s.SymbolCode,
        s.TradeStatus,
        s.ExchangeCode, 
        s.MarketCode,
        s.Issuer
      FROM $tnSymbols s 
      WHERE s.Description LIKE '%${name.turkishToLatin()}%' 
        ${filterTradeable ? "AND s.TradeStatus = 1" : ""}
        AND (s.MaturityDate >= DATE('now') OR s.MaturityDate IS NULL)
        $typeCodeFilter
        $typeExchangeFilter
      ${typeCode != null && typeCode.isNotEmpty && typeCode.contains('FUND') ? """
      UNION ALL
      SELECT
        Code as Name,
        fi.InstitutionName as Description,
        'FUND' as TypeCode,
        FounderCode as UnderlyingName,
        Code as SymbolCode,
        TefasStatus as TradeStatus,
        'FUND' as ExchangeCode,
        'FUND' as MarketCode,
        fi.InstitutionName as Issuer
      FROM Funds f
      LEFT JOIN FinancialInstitutions fi ON f.FounderCode = fi.InstitutionCode
      WHERE (Code LIKE '%${name.turkishToLatin()}%' OR Title LIKE '%${name.turkishToLatin()}%')
      """ : ""}
    ) AS o
    ${getIt<SymbolSearchBloc>().state.sortingQuery};
  """);

    return symbolResults;
  }

Future<List<Map<String, dynamic>>> fundSearchSymbol(
    String name,
    String? founderCode,
  ) async {
    final Database db = await dbInstance.database;

    const String baseQuery = """
    SELECT
      Code as Name,
      fi.InstitutionName as Description,
      'FUND' as TypeCode,
      FounderCode as UnderlyingName,
      Code as SymbolCode,
      TefasStatus as TradeStatus,
      Title as MarketDesc,
      999 as ExchangeOrder,
      fi.InstitutionName as Issuer
    FROM Funds f
    LEFT JOIN FinancialInstitutions fi ON f.FounderCode = fi.InstitutionCode
  """;

    final List<String> whereClauses = [];
    final List<dynamic> args = [];

    // FounderCode filtresi
    if (founderCode != null && founderCode.isNotEmpty) {
      whereClauses.add("f.FounderCode = ?");
      args.add(founderCode);
    }

    final String trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      final String search = trimmedName.turkishToLatin();
      whereClauses.add("(f.Code LIKE ? OR f.Title LIKE ?)");
      args.addAll(['%$search%', '%$search%']);
    }

    String finalQuery = whereClauses.isEmpty ? baseQuery : '$baseQuery WHERE ${whereClauses.join(" AND ")}';

    // ✅ En ilgililer üstte olacak şekilde sıralama
    if (trimmedName.isNotEmpty) {
      finalQuery += """
      ORDER BY
        CASE 
          WHEN f.Code = ? THEN 0
          WHEN f.Code LIKE ? THEN 1
          WHEN f.Title LIKE ? THEN 2
          ELSE 3
        END,
        f.Code ASC
    """;
      args.addAll([trimmedName, '%$trimmedName%', '%$trimmedName%']);
  }

    return db.rawQuery(finalQuery, args);
  }
  Future<List<Map<String, dynamic>>> getWarrantDropDownList() async {
    Database db = await dbInstance.database;
    return db.query(
      tnSymbols,
      where: 'UnderlyingName IS NOT NULL',
    );
  }

  Future<List<Map<String, dynamic>>> getWarrantSubItemList(
    String underlyingId,
  ) async {
    Database db = await dbInstance.database;
    return db.query(
      tnSymbols,
      where: 'UnderlyingName = $underlyingId',
    );
  }

  Future<String> getListDropDownList(FilterCategoryItemModel symbol) async {
    Database db = await dbInstance.database;
    List<Map<String, dynamic>> list = [];
    switch (symbol.type) {
      case "1":
        list = await db.query(
          tnSymbols,
          columns: [
            'Name',
          ],
          where: 'Name = "${symbol.value}"',
        );
        return list[0]['Name'];
      case "2":
        list = await db.query(
          tnSymbolTypes,
          columns: [
            'Code',
          ],
          where: 'TrName = "${symbol.value}"',
        );
        return list[0]['Code'];
      case "3":
      case "4":
        list = await db.query(
          tnMarkets,
          columns: [
            'Code',
          ],
          where: 'TrName = "${symbol.value}"',
        );
        return list[0]['Code'];
    }
    return '';
  }

  Future<List<Map<String, dynamic>>> getListSubItemList(
    FilterCategoryItemModel symbol,
    String name,
  ) async {
    Database db = await dbInstance.database;
    List<Map<String, dynamic>> allList = [];
    switch (symbol.type) {
      case "1":
        return db.rawQuery(
          '''
            SELECT
              s.Name,
              s.TypeCode,
              s.UnderlyingName,
              s.MarketCode,
              s.Description,
              s.SwapType,
              s.ActionType,
              s.Issuer
            FROM $tnSymbols s
            WHERE s.Name in (SELECT ChildSymbolName FROM $tnSymbolMembers WHERE MainSymbolName='$name')
            ORDER BY s.Name
          ''',
        );
      case "2":
        return db.query(
          tnSymbols,
          columns: [
            'Name',
            'TypeCode',
            'UnderlyingName',
            'MarketCode',
            'SwapType',
            'ActionType',
          ],
          where: 'TypeCode = "$name"',
          orderBy: 'Name',
        );
      case "3":
        return db.query(
          tnSymbols,
          columns: [
            'Name',
            'TypeCode',
            'UnderlyingName',
            'MarketCode',
            'Description',
            'SwapType',
            'ActionType',
          ],
          where: 'MarketCode = "$name" AND TypeCode = "${SymbolTypes.equity.dbKey}" AND ExchangeCode = "BISTPP"',
          orderBy: 'Name',
        );
      case "4":
        return db.query(
          tnSymbols,
          columns: [
            'Name',
            'TypeCode',
            'UnderlyingName',
            'MarketCode',
            'Description',
            'SwapType',
            'ActionType',
          ],
          where:
              'MarketCode = "$name" AND ExchangeCode = "BISTPP" AND (TypeCode = "${SymbolTypes.equity.dbKey}" OR TypeCode = "${SymbolTypes.etf.dbKey}")',
          orderBy: 'Name',
        );
    }
    return allList;
  }

  Future<List<Map<String, dynamic>>> getIndexListSubItemList(
    FilterCategoryItemModel symbol,
  ) async {
    Database db = await dbInstance.database;
    String query = 'TypeCode = ? AND ExchangeCode = ?';
    List<String> whereArgs = ['INDEX', symbol.value];
    if (symbol.value == 'BISTEX') {
      query = 'TypeCode = ? AND ExchangeCode IN (?, ?)';
      whereArgs.add("BISTPPPLUS");
    }
    return db.query(
      tnSymbols,
      columns: [
        'Name',
        'TypeCode',
        'UnderlyingName',
        'MarketCode',
        'Description',
        'SwapType',
        'ActionType',
      ],
      where: query,
      whereArgs: whereArgs,
      orderBy: 'Name',
    );
  }

  Future<List<Map<String, dynamic>>> getCertificatesList() async {
    Database db = await dbInstance.database;
    String marketCode = 'K';
    String exchangeCode = 'BISTPP';
    String typeCode = 'EQUITY';

    return db.query(
      tnSymbols,
      where: 'ExchangeCode = "$exchangeCode" and MarketCode = "$marketCode" and TypeCode = "$typeCode"',
    );
  }

  //Piyasalar -> Kripto Paralar sayfası subItemlerı için
  Future<List> getCryptoCurrenciesSubItemList(CryptoEnum market) async {
    Database db = await dbInstance.database;
    return await db.query(
      tnSymbols,
      where: "TypeCode = ? AND MarketCode = ?",
      whereArgs: [SymbolTypes.crypto.dbKey, market.marketCode],
      orderBy: "Name",
    );
  }

  //Piyasalar -> SGMK sayfası subItemlerı için
  Future<List> getSGMKSubItemList() async {
    Database db = await dbInstance.database;
    return db.rawQuery(
      "SELECT s.Name, s.TypeCode, s.UnderlyingName, s.MarketCode, s.SwapType, s.ActionType FROM $tnSymbols s where s.ExchangeCode='BAPPLUS' and s.MarketCode='A'",
    );
  }

  //Piyasalar -> Kur/Parite Paralar sayfası subItemlerı için
  Future<List> getCurrencySubItemList(String exchangeCode, List<String> marketCodes) async {
    Database db = await dbInstance.database;
    String tnSymbols = "Symbols"; // Tablo adı
    String placeholders = List.filled(marketCodes.length, '?').join(', ');

    return await db.query(
      tnSymbols,
      where: "TypeCode = ? AND ExchangeCode = ? AND MarketCode IN ($placeholders)",
      whereArgs: [SymbolTypes.parity.dbKey, exchangeCode, ...marketCodes],
      orderBy: "Name",
    );
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> symbolDetails(name) async {
    Database db = await dbInstance.database;

    return db.rawQuery(
      """SELECT
          s.Name,
          s.Description,
          m.TrName as MarketDesc,
          s.UnderlyingName,
          s.Multiplier
        FROM $tnSymbols s
        LEFT JOIN $tnMarkets m on s.MarketCode=m.Code 
        WHERE s.Name='$name'
      """,
    );
  }

  Future<List<Map<String, dynamic>>> getDetailsOfSymbols(
    List<dynamic> symbolList,
  ) async {
    Database db = await dbInstance.database;
    List<String> quotedSymbols = symbolList.map((e) => '\'$e\'').toList();
    List<Map<String, dynamic>> detailsOfSymbols = await db.rawQuery('''
          SELECT 
            Distinct(s.Name),
            s.Description,
            m.TrName as MarketDesc,
            s.TypeCode,
            s.UnderlyingName,
            s.MarketCode,
            s.OptionClass,
            s.SwapType,
            s.ActionType,
            s.SubMarketCode,
            s.MaturityDate,
            s.Issuer,
            s.DecimalCount
          FROM $tnSymbols s
          LEFT JOIN $tnMarkets m ON s.MarketCode = m.Code
          WHERE s.Name in (${quotedSymbols.join(', ')})
          ORDER BY s.Name ASC
        ''');
    List<Map<String, dynamic>> sortedDetailsOfSymbols = [];
    for (String symbol in symbolList) {
      for (Map<String, dynamic> detail in detailsOfSymbols) {
        if (detail["Name"] == symbol) {
          sortedDetailsOfSymbols.add(detail);
          break;
        }
      }
    }
    return sortedDetailsOfSymbols;
  }

  //Sembolun hisse olup olmadığını kontrol etmek için kullanılır.
  Future<bool> symbolTypeControl(String symbolName) async {
    Database db = await dbInstance.database;
    List<Map<String, dynamic>> allList = [];

    allList = await db.rawQuery(
      "SELECT s.TypeCode FROM $tnSymbols s where s.Name='$symbolName'",
    );

    if (allList.isNotEmpty) {
      if (allList[0]["TypeCode"].toString() == "EQUITY" ||
          allList[0]["TypeCode"].toString() == "WARRANT" ||
          allList[0]["TypeCode"].toString() == "FUTURE") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getDetailsOfSymbol(
    String symbol,
  ) async {
    Database db = await dbInstance.database;
    return db.rawQuery('''
          SELECT 
            s.Name,
            s.Description,
            m.TrName as MarketDesc,
            s.TypeCode,
            s.MarketCode,
            s.ExchangeCode,
            s.SwapType,
            s.ActionType,
            s.MaturityDate,
            s.UnderlyingName,
            s.Multiplier,
            s.SubMarketCode,
            s.DecimalCount,
            s.OptionClass,
            s.OptionType,
            s.Issuer,
            s.SectorCode,
            s.TradeStatus
          FROM $tnSymbols s
          LEFT JOIN $tnMarkets m ON s.MarketCode = m.Code
          WHERE s.Name = '$symbol'
        ''');
  }

  Future<List<Map<String, dynamic>>> getMarketMakersDropDownList() async {
    Database db = await dbInstance.database;
    return db.rawQuery('''
    SELECT
      DISTINCT s.MarketMaker,
      f.InstitutionName,
      f.InstitutionDisplayName
    FROM Symbols s
      LEFT JOIN FinancialInstitutions f 
      ON s.MarketMaker = f.InstitutionCode
    WHERE s.TypeCode = 'WARRANT'
      AND s.TradingEndDate >= DATE('now')
      AND s.MarketMaker IS NOT NULL
      AND f.InstitutionName IS NOT NULL
      AND f.InstitutionDisplayName IS NOT NULL
  ''');
  }

  Future<List<dynamic>?> getUnderlyindAssetDropDownList(
    String selectedMarketMaker,
  ) async {
    Database db = await dbInstance.database;
    String query = '''
      SELECT DISTINCT * FROM $tnSymbols
      WHERE Name IN (
        SELECT DISTINCT UnderlyingName
        FROM Symbols
        WHERE (
          (TypeCode = ? AND TradingEndDate >= DATE('now') AND UnderlyingName NOT NULL)
          OR
          (TypeCode = ? AND ExchangeCode = ? AND MarketCode = ?)
        )
    ''';

// Eğer MarketMaker dolu ise koşulu ekle
    List<String> args = ['WARRANT', 'EQUITY', 'BISTPP', 'K'];

    if (selectedMarketMaker.isNotEmpty) {
      query += ' AND MarketMaker = ?';
      args.add(selectedMarketMaker);
    }

    query += ')'; // Subquery kapat

    return await db.rawQuery(query, args);
  }

  Future<bool> updateRecords(dynamic data) async {
    Database db = await dbInstance.database;
    DBUtils dbUtils = DBUtils(db.batch());
    if (data['symbolList'].isNotEmpty) {
      await dbUtils.updateSymbols(db, data['symbolList']);
    }
    if (data['exchangeList'].isNotEmpty) {
      await dbUtils.updateExchanges(db, data['exchangeList']);
    }
    if (data['sectorList'].isNotEmpty) {
      await dbUtils.updateSectors(db, data['sectorList']);
    }
    if (data['marketList'].isNotEmpty) {
      await dbUtils.updateMarkets(db, data['marketList']);
    }
    if (data['symbolTypeList'].isNotEmpty) {
      await dbUtils.updateSymbolTypes(db, data['symbolTypeList']);
    }
    if (data['symbolMemberList'].isNotEmpty) {
      await dbUtils.updateSymbolMembers(db, data['symbolMemberList']);
    }
    if (data['subMarketList'].isNotEmpty) {
      await dbUtils.updateSubMarkets(db, data['subMarketList']);
    }
    if (data['financialInstutionList'].isNotEmpty) {
      await dbUtils.updateFinancialInstitutions(db, data['financialInstutionList']);
    }
    if (data['fundList'].isNotEmpty) {
      await dbUtils.updateFunds(db, data['fundList']);
    }
    await dbUtils.commitBatch();
    return true;
  }

  Future<List<Map<String, dynamic>>> getInstitutions() async {
    final db = await dbInstance.database;
    return db.query(
      tnInstitutions,
      where:
          '(InstitutionType = ? OR InstitutionType = ?) AND InstitutionDisplayName IS NOT NULL AND InstitutionDisplayName != ?',
      whereArgs: [16, 5, ''],
      orderBy: 'InstitutionName',
    );
  }

  Future<List<Map<String, dynamic>>> getSubTypes(String founder, String mainType, String tefasStatus) async {
    Database db = await dbInstance.database;
    List<String> whereClasuses = [
      'FounderCode = \'$founder\'',
    ];
    if (tefasStatus != 'ALL') {
      whereClasuses.add('TefasStatus = \'$tefasStatus\'');
    }
    if (mainType != 'ALL') {
      whereClasuses.add('MainTypeCode = \'$mainType\'');
    }
    return db.query(
      tnFunds,
      columns: [
        'DISTINCT SubTypeCode',
        'SubType',
      ],
      where: whereClasuses.join(' AND '),
    );
  }

  Future<List<Map<String, dynamic>>> getFundTitleTypes(
    String founder,
    String mainType,
    String tefasStatus,
    String subType,
  ) async {
    Database db = await dbInstance.database;
    List<String> whereClasuses = [
      'FounderCode = \'$founder\'',
    ];
    if (subType != 'ALL') {
      whereClasuses.add('SubTypeCode = \'$subType\'');
    }
    if (tefasStatus != 'ALL') {
      whereClasuses.add('TefasStatus = \'$tefasStatus\'');
    }
    if (mainType != 'ALL') {
      whereClasuses.add('MainTypeCode = \'$mainType\'');
    }
    return db.query(
      tnFunds,
      columns: [
        'DISTINCT FundTitleTypeCode',
        'FundTitleType',
      ],
      where: whereClasuses.join(' AND '),
    );
  }

  Future<List<Map<String, dynamic>>> getFunds(FundFilterModel fundFilter) async {
    Database db = await dbInstance.database;
    List<String> whereClasuses = [
      'FounderCode = \'${fundFilter.institution}\'',
    ];
    if (fundFilter.subType != 'ALL') {
      whereClasuses.add('SubTypeCode = \'${fundFilter.subType}\'');
    }
    if (fundFilter.tefasType != 'ALL') {
      whereClasuses.add('TefasStatus = \'${fundFilter.tefasType}\'');
    }
    if (fundFilter.fundType != 'ALL') {
      whereClasuses.add('MainTypeCode = \'${fundFilter.fundType}\'');
    }
    return db.query(
      tnFunds,
      where: whereClasuses.join(' AND '),
    );
  }

  Future<List<Map<String, dynamic>>> getTypeOfSymbol(String name) async {
    Database db = await dbInstance.database;

    return db.query(
      tnSymbols,
      columns: [
        'Name',
        'TypeCode',
        'MarketCode',
        'SwapType',
        'ActionType',
      ],
      where: 'Name = ?',
      whereArgs: [
        name,
      ],
    );
  }

  Future<String?> getSymbolNameIfExists(String symbolName) async {
    Database db = await dbInstance.database;

    final result = await db.query(
      tnSymbols,
      columns: [
        'Name',
      ],
      where: 'Name = ?',
      whereArgs: [symbolName],
    );

    if (result.isNotEmpty) {
      return result.first['Name'] as String;
    }
    return null;
  }

  //getMultipliersByContract

  Future<List<Map<String, dynamic>>> getMultipliersByContract(String contract) async {
    Database db = await dbInstance.database;
    return db.rawQuery(
      '''
        SELECT
          Multiplier
        FROM
          Symbols
        WHERE
          Name = '$contract'
      ''',
    );
  }

  Future<void> dbLog(
    LogLevel level,
    TalkerLog talkerLog,
  ) async {
    Database db = await dbInstance.database;
    Map<String, String> message = {};
    if (talkerLog is DioRequestLog) {
      message = {
        'Type': 'REQUEST',
        'Method': talkerLog.requestOptions.method.toString(),
        'URI': talkerLog.requestOptions.uri.toString(),
        'Data': talkerLog.requestOptions.data.toString(),
        'Headers': talkerLog.requestOptions.headers.toString(),
      };
    } else if (talkerLog is DioErrorLog) {
      message = {
        'Type': 'ERROR',
        'Method': talkerLog.dioException.requestOptions.method.toString(),
        'URI': talkerLog.dioException.requestOptions.uri.toString(),
        'Exception': talkerLog.exception.toString(),
      };
    } else if (talkerLog is TalkerRouteLog) {
      message = {
        'Type': 'ROUTE',
        'Method': talkerLog.generateTextMessage(),
      };
    } else {
      message = {
        'Type': 'RESPONSE',
        'Method': (talkerLog as DioResponseLog).response.requestOptions.method.toString(),
        'URI': talkerLog.response.requestOptions.uri.toString(),
        'Headers': talkerLog.response.headers.toString(),
      };
    }
    message['Version'] = getIt<AppInfo>().appVersion;
    message['Flavor'] = AppConfig.instance.flavor.name;
    await db.insert('Logs', {
      'Level': level.toString(),
      'Log': jsonEncode(message),
      'Timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> cleanLogs() async {
    Database db = await dbInstance.database;
    await db.delete(
      'Logs',
      where: 'Timestamp < ?',
      whereArgs: [
        DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    Database db = await dbInstance.database;
    return db.query(
      'Logs',
      orderBy: 'Timestamp DESC',
      limit: 100,
    );
  }

  Future<String> getFundFounderCode(String code) async {
    Database db = await dbInstance.database;
    List<Map<String, dynamic>> allList = [];

    allList = await db.query(
      tnFunds,
      columns: [
        'FounderCode',
      ],
      where: 'Code = ?',
      whereArgs: [
        code,
      ],
    );

    return allList.isEmpty ? '' : allList[0]["FounderCode"];
  }

  Future<List<Map<String, dynamic>>> getSuffix(String name) async {
    Database db = await dbInstance.database;

    return db.query(
      tnSymbols,
      columns: [
        'Suffix',
      ],
      where: 'Name = ?',
      whereArgs: [
        name,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getSuffixByBistCodeForTypeCode(
    String name,
    String typeCode,
  ) async {
    Database db = await dbInstance.database;

    return db.query(
      tnSymbols,
      columns: [
        'Suffix',
      ],
      where: 'BistCode = ? AND TypeCode = ?',
      whereArgs: [
        name,
        typeCode,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteDetails(List<String> symbolList) async {
    Database db = await dbInstance.database;
    List<String> quotedSymbols = symbolList.map((e) => '"$e"').toList();

    List<Map<String, Object?>> result = await db.query(
      tnSymbols,
      columns: ['Description', 'Name', 'UnderlyingName', 'TypeCode', 'BistCode'],
      where: 'Name in (${quotedSymbols.join(', ')})',
    );

    return result;
  }

  /// Pozisyojn listesinden gelen sembollerin underlyinglerini cekmek icin kullandigimizdb sorgusudur.
  /// ORN: [{'Name': 'AKBNK', 'Suffix': 'E'}, {'Name': 'Garan', 'Suffix': 'F'}]
  Future<List<Map<String, dynamic>>> getDetailsOfPosition(List<Map<String, String>> symbolList) async {
    Database db = await dbInstance.database;
    List<String> conditions = [];
    List<String> whereArgs = [];

    for (Map<String, String> item in symbolList) {
      if (item['Name'] == null || item['Name'] == '') continue;

      conditions.add('(BistCode = ? AND Suffix = ?)');
      whereArgs.add(item['Name']!);
      whereArgs.add(item['Suffix'] ?? '');
    }
    String whereClause = conditions.join(' OR ');

    List<Map<String, Object?>> result = await db.query(
      tnSymbols,
      columns: [
        'Description',
        'Name',
        'UnderlyingName',
        'TypeCode',
        'BistCode',
      ],
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getFundDetail(String symbol) async {
    Database db = await dbInstance.database;

    List<Map<String, Object?>> result = await db.query(
      tnFunds,
      columns: [
        'Code',
        'Title',
        'FounderCode',
      ],
      where: 'Code = ?',
      whereArgs: [
        symbol,
      ],
    );
    return result;
  }

  Future<bool> hasSymbolInDB(String symbol) async {
    Database db = await dbInstance.database;

    var response = await db.query(
      tnSymbols,
      columns: [
        'Name',
      ],
      where: 'Name = ?',
      whereArgs: [
        symbol,
      ],
    );
    return response.isNotEmpty == true;
  }

  Future<List<Map<String, dynamic>>> getEtfSymbolName(String name) async {
    Database db = await dbInstance.database;
    return db.query(
      tnSymbols,
      columns: [
        'Name',
      ],
      where: 'Name LIKE ? AND TypeCode = ? AND Status = ?',
      whereArgs: ['$name%', SymbolTypes.etf.dbKey, 1],
    );
  }

  Future<List<Map<String, dynamic>>> getViopUnderlyingList(SymbolSearchFilterEnum? filter, String? maturityDate) async {
    Database db = await dbInstance.database;
    String query = '';
    List<String> whereArgs = [];
    if (filter != null) {
      query += 'TypeCode = ? ';
      whereArgs.add(filter.dbKeys!.first);
    } else {
      query += 'TypeCode IN (?, ?) ';
      whereArgs.add(SymbolSearchFilterEnum.future.dbKeys!.first);
      whereArgs.add(SymbolSearchFilterEnum.option.dbKeys!.first);
    }

    if (maturityDate != null) {
      DateTime startDate = DateTimeUtils.mmmmyyToDateTime(maturityDate);
      DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
      query += 'AND MaturityDate BETWEEN ? AND ? ';
      whereArgs.add(DateTimeUtils.serverDate(startDate));
      whereArgs.add(DateTimeUtils.serverDate(endDate));
    }
    query += 'AND Status = 1 AND UnderlyingName IS NOT NULL ORDER BY UnderlyingName ASC';

    return db.query(
      tnSymbols,
      where: query,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> getMaturityByUnderlying(SymbolSearchFilterEnum? filter, String? underlying) async {
    Database db = await dbInstance.database;
    String query = '(MaturityDate >= DATE("now") OR MaturityDate IS NULL) AND Status = 1 ';
    List<String> whereArgs = [];
    if (filter != null) {
      query += 'AND TypeCode = ? ';
      whereArgs.add(filter.dbKeys!.first);
    } else {
      query += 'AND TypeCode IN (?, ?) ';
      whereArgs.add(SymbolSearchFilterEnum.future.dbKeys!.first);
      whereArgs.add(SymbolSearchFilterEnum.option.dbKeys!.first);
    }

    if (underlying != null) {
      query += 'AND UnderlyingName = ?';
      whereArgs.add(underlying);
    }
    return db.query(
      tnSymbols,
      columns: ['MaturityDate'],
      where: query,
      whereArgs: whereArgs,
    );
  }

  /// Viop piyasasında belirli bir alt piyasa koduna ait vade tarihlerini getirir
  Future<List<Map<String, dynamic>>> getMaturityBySubMarketCode(
      SymbolSearchFilterEnum? filter, String? subMarketCode) async {
    Database db = await dbInstance.database;
    String query = '(MaturityDate >= DATE("now") OR MaturityDate IS NULL) AND Status = 1 ';
    List<String> whereArgs = [];
    if (filter != null) {
      query += 'AND TypeCode = ? ';
      whereArgs.add(filter.dbKeys!.first);
    } else {
      query += 'AND TypeCode IN (?, ?) ';
      whereArgs.add(SymbolSearchFilterEnum.future.dbKeys!.first);
      whereArgs.add(SymbolSearchFilterEnum.option.dbKeys!.first);
    }

    if (subMarketCode != null) {
      query += 'AND SubMarketCode = ?';
      whereArgs.add(subMarketCode);
    }
    return db.query(
      tnSymbols,
      columns: ['MaturityDate'],
      where: query,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> getViopByFilters(
    String? filter,
    String? underlyingName,
    String? maturityDate,
    String? transactionType,
    String? subMarketCode, {
    bool onlyTradeable = false,
  }) async {
    Database db = await dbInstance.database;
    String query = '';
    List<String> whereArgs = [];
    if (filter != null) {
      query += 'TypeCode = ? ';
      whereArgs.add(filter);
    } else {
      query += 'TypeCode IN (?, ?) ';
      whereArgs.add(SymbolSearchFilterEnum.future.dbKeys!.first);
      whereArgs.add(SymbolSearchFilterEnum.option.dbKeys!.first);
    }
    if (underlyingName != null) {
      query += 'AND UnderlyingName = ? ';
      whereArgs.add(underlyingName);
    }
    if (subMarketCode != null) {
      query += 'AND SubMarketCode = ? ';
      whereArgs.add(subMarketCode);
    }
    if (maturityDate != null) {
      DateTime startDate = DateTimeUtils.mmmmyyToDateTime(maturityDate);
      DateTime endDate = DateTime(startDate.year, startDate.month + 1, 0);
      query += 'AND MaturityDate BETWEEN ? AND ? ';
      whereArgs.add(DateTimeUtils.serverDate(startDate));
      whereArgs.add(DateTimeUtils.serverDate(endDate));
    }
    if (transactionType != null) {
      query += 'AND OptionClass = ? ';
      whereArgs.add(transactionType);
    }
    if (onlyTradeable) {
      query += 'AND TradeStatus = 1 ';
    }
    query += 'AND Status = 1 AND (MaturityDate >= DATE("now") OR MaturityDate IS NULL)';
    return db.query(
      tnSymbols,
      where: query,
      whereArgs: whereArgs,
    );
  }

  /// Sektor kodlarini doner
  Future<List<String>> getSectorCodes() async {
    Database db = await dbInstance.database;
    return db.query(tnSectors, columns: ['Code']).then((value) => value.map((e) => e['Code'].toString()).toList());
  }

  /// Verilen sektor kodlarina ait hisseleri doner
  Future<List<Map<String, dynamic>>> getEquityBySectors(List<String> sectorList) async {
    Database db = await dbInstance.database;
    String query = 'TypeCode IN (?, ? , ?) AND SectorCode IN (${List.filled(sectorList.length, '?').join(', ')})';
    List<String> whereArgs = ['EQUITY', 'RIGHT', 'ETF', ...sectorList];
    return db.query(
      tnSymbols,
      where: query,
      whereArgs: whereArgs,
      orderBy: 'Name',
    );
  }

  Future<bool> underlyingNameExists(String name) async {
    final Database db = await dbInstance.database;

    final result = await db.query(
      tnSymbols,
      columns: [
        'UnderlyingName',
      ],
      where: 'TypeCode = ? AND UnderlyingName = ?',
      whereArgs: [
        'WARRANT',
        name,
      ],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<String?> getDescription(String name) async {
    final Database db = await dbInstance.database;

    final result = await db.query(
      tnSymbols,
      columns: [
        'Description',
      ],
      where: 'Name = ?',
      whereArgs: [
        name,
      ],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['Description'] as String?;
    }
    return null;
  }
  
  Future<bool?> getViopMultiSession(String name) async {
    final Database db = await dbInstance.database;

    final result = await db.query(
      tnSymbols,
      columns: [
        'MultiSession',
      ],
      where: 'Name = ?',
      whereArgs: [
        name,
      ],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['MultiSession'] == 1;
    }
    return null;
  }

}
