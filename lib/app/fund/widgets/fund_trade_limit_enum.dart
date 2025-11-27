enum FundTradeLimitEnum {
  blockageT('MF_BLOCKAGE-T'),
  blockageT1('MF_BLOCKAGE-T1'),
  blockageT2('MF_BLOCKAGE-T2');

  final String typeName;
  const FundTradeLimitEnum(this.typeName);

  static FundTradeLimitEnum fromValorDate(String valorDateStr) {
    final now = DateTime.now();
    final valorDate = DateTime.tryParse(valorDateStr);

    if (valorDate == null) {
      // Parse edilemeyen tarih varsa default T2 döner
      return FundTradeLimitEnum.blockageT2;
    }

    final diffDays = valorDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (diffDays <= 0) {
      return FundTradeLimitEnum.blockageT;
    } else if (diffDays == 1) {
      return FundTradeLimitEnum.blockageT1;
    } else {
      return FundTradeLimitEnum.blockageT2;
    }
  }
}
