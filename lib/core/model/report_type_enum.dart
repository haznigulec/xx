enum ReportTypeEnum {
  anaysis(1, 'piyasa_incelemeleri_analiz'),
  report(2, 'piyasa_incelemeleri_rapor'),
  podcast(3, 'piyasa_incelemeleri_podcast'),
  video(4, 'piyasa_incelemeleri_video');

  const ReportTypeEnum(this.id, this.value);
  final int id;
  final String value;
}

ReportTypeEnum intToReportTypeEnum(int id) {
  switch (id) {
    case 1:
      return ReportTypeEnum.anaysis;
    case 2:
      return ReportTypeEnum.report;
    case 3:
      return ReportTypeEnum.podcast;
    case 4:
      return ReportTypeEnum.video;
    default:
      return ReportTypeEnum.video;
  }
}
