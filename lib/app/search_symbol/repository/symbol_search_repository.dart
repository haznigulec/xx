import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';

abstract class SymbolSearchRepository {
  Future<List<SymbolModel>> searchSymbol({
    required String symbolName,
    required String exchangeCode,
    required bool isFund,
    String? founderCode,
    required List<String>? filterDbKeys,
  });

  Future<List<SymbolModel>> searchUsSymbol({
    required String symbolName,
    required int count,
  });

  Future<List<SymbolModel>> getOldSearches();

  void setOldSearches({
    required List<SymbolModel> symbolModelList,
  });

  Future<List<Map<String, dynamic>>> getExchangeList();

  Future<List<String>> getUnderlyingList(SymbolSearchFilterEnum filter, String? maturity);

  Future<List<String>> getMaturityListByUnderlying(SymbolSearchFilterEnum filter, String? underlying);

  Future<List<SymbolModel>> getViopByFilters({
    required String filter,
    required String? underlyingName,
    required String? maturityDate,
    required String? transactionType,
  });

  Future<ApiResponse> getPositionList({
    required String selectedAccount,
  });

  Future<ApiResponse> getViopPositionList();

  Future<ApiResponse> getUsPositionList();

  Future<Map<String, dynamic>> getSymbolsDetail({
    required List<Map<String, String>> symbolNames,
  });

}
