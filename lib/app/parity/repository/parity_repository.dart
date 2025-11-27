abstract class ParityRepository {
  Future<List> paritySubItemList({
    required String exchangeCode,
    required List<String> marketCodes,
  });
}
