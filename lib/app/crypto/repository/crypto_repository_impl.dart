import 'package:piapiri_v2/app/crypto/repository/crypto_repository.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';

class CryptoRepositoryImpl extends CryptoRepository {
  @override
  Future<List<dynamic>> getCryptoCurrenciesSubItemList({required CryptoEnum market}) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<dynamic> cryptoCurrencies = await dbHelper.getCryptoCurrenciesSubItemList(market);
    return cryptoCurrencies;
  }
}
