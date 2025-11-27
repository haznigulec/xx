enum FavoriteSortingEnum {
  alphabetic('ALPHABETIC', 'a_to_z'),
  reverseAlphabetic('REVERSE_ALPHABETIC', 'z_to_a'),
  custom('CUSTOM', 'custom_sort');

  final String value;
  final String localization;
  const FavoriteSortingEnum(
    this.value,
    this.localization,
  );
}
