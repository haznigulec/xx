class FundBriefModel {
  final String title;
  final dynamic value;
  final bool isShowInfoIcon;
  final String? tooltipText;

  FundBriefModel({
    required this.title,
    required this.value,
    this.isShowInfoIcon = false,
    this.tooltipText,
  });
}
