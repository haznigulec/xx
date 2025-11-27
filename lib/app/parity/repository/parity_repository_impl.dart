import 'package:piapiri_v2/app/parity/repository/parity_repository.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';

class ParityRepositoryImpl extends ParityRepository {
  @override
  Future<List<dynamic>> paritySubItemList({
    required String exchangeCode,
    required List<String> marketCodes,
  }) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<dynamic> parityItems = await dbHelper.getCurrencySubItemList(exchangeCode, marketCodes);
    return parityItems;
  }
}
