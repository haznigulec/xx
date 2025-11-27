import 'package:piapiri_v2/app/viop/repository/viop_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';

class ViopRepositoryImpl extends ViopRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<SymbolModel>> getViopByFilters({
    required String? filter,
    required String? underlyingName,
    required String? maturityDate,
    required String? transactionType,
    required String? subMarketCode,
  }) async {
    List<Map<String, dynamic>> symbols =
        await dbHelper.getViopByFilters(
      filter,
      subMarketCode == null ? underlyingName : null,
      maturityDate,
      transactionType,
      subMarketCode,
    );
    List<SymbolModel> symbolModelList = symbols.map((e) => SymbolModel.fromMap(e)).toList();
    symbolModelList.sort((a, b) => a.name.compareTo(b.name));
    return symbolModelList;
  }



  @override
  Future<List<String>> getUnderlyingList() async {
    List<Map<String, dynamic>> underlyingList = await dbHelper.getViopUnderlyingList(null, null);
    return underlyingList.map((e) => e['UnderlyingName'].toString()).toSet().toList();
  }

  @override
  Future<List<String>> getMaturityListByUnderlying(String underlyingCode) async {
    dynamic maturitys = await dbHelper.getMaturityByUnderlying(null, underlyingCode);
    List<String> dateList = List<String>.from(maturitys.map((e) => e['MaturityDate'])).toList();
    return DateTimeUtils.getViopMaturity(dateList);
  }

  @override
  Future<List<String>> getMaturityListBySubMarketCode(String subMarketCode) async {
    dynamic maturitys = await dbHelper.getMaturityBySubMarketCode(null, subMarketCode);
    List<String> dateList = List<String>.from(maturitys.map((e) => e['MaturityDate'])).toList();
    return DateTimeUtils.getViopMaturity(dateList);
  }

}
