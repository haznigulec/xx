class FilterCategoryModel {
  final String categoryLocalization;
  final List<FilterCategoryItemModel> items;

  const FilterCategoryModel({
    required this.categoryLocalization,
    required this.items,
  });
}

class FilterCategoryItemModel {
  final String value;
  final String localization;
  final String type;

  const FilterCategoryItemModel({
    required this.localization,
    required this.value,
    required this.type,
  });
}
