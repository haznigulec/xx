import 'package:piapiri_v2/core/model/crypto_enum.dart';

abstract class CryptoRepository {
  Future<List> getCryptoCurrenciesSubItemList({
    required CryptoEnum market,
  });
}
