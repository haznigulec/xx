enum SummaryTypeEnum {
  allExtract(5), // Tüm Özet
  cashSummary(3), // Nakit Özet
  securitiesSummary(0), // Menkul Özet
  viopSummary(4); // VIOP Özet

  const SummaryTypeEnum(this.value);
  final int value;
}
