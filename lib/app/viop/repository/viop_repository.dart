import 'package:piapiri_v2/core/model/symbol_model.dart';

abstract class ViopRepository {

  Future<List<SymbolModel>> getViopByFilters({
    required String? filter,
    required String? underlyingName,
    required String? maturityDate,
    required String? transactionType,
    required String? subMarketCode,
  });

  Future<List<String>> getUnderlyingList();

  Future<List<String>> getMaturityListByUnderlying(String underlyingCode);

  Future<List<String>> getMaturityListBySubMarketCode(String subMarketCode);
}
