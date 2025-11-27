import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:p_core/constants/country_codes_map.dart';
import 'package:p_core/extensions/object_extensions.dart';

/// A single country code item.
///
/// Contains a [name], [code], and [dialCode].
///
/// [CountryCode]s are immutable and can be copied using [copyWith] and
/// which are basically from [List] of [Map<String, String>] that are
/// converted using the [CountryCode.fromMap] method.
///
@immutable
class CountryCode {
  const CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
  });

  /// Converts the country code from map to the actual item.
  factory CountryCode.fromMap(Map<String, dynamic> map) {
    return CountryCode(
      name: map['name'] as String? ?? 'United Arab Emirates',
      code: map['code'] as String? ?? 'UAE',
      dialCode: map['dial_code'] as String? ?? '+971',
    );
  }

  /// The name of the country.
  ///
  /// Cannot be empty.
  final String name;

  /// The 2 character ISO code of the country.
  ///
  /// Based from: https://countrycode.org/
  final String code;

  /// The country dial code.
  ///
  /// By convention, international telephone numbers are
  /// represented by prefixing the country code with a plus sign (+).
  ///
  /// This properties return [String] value like this:
  /// `+1` for US.
  ///
  /// For more info: https://en.wikipedia.org/wiki/List_of_country_calling_codes
  final String dialCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CountryCode && other.name == name && other.code == code && other.dialCode == dialCode;
  }

  @override
  int get hashCode => name.hashCode ^ code.hashCode ^ dialCode.hashCode;

  /// Returns a copy of this [CountryCode] with the given values updated.
  CountryCode copyWith({
    String? name,
    String? code,
    String? dialCode,
  }) {
    return CountryCode(
      name: name ?? this.name,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  static bool isValidCountryCode(String code) {
    return countryCodes.firstWhereOrNull((countryCode) => countryCode.code == code)?.let((_) => true) ?? false;
  }

  static List<CountryCode> get countryCodes {
    final list = bzCountryCodes.map(CountryCode.fromMap).toList();
    return list;
  }

  /// eg: countryCode: 'AE'
  static CountryCode? getCountryCode(String countryCode) {
    return countryCodes.firstWhereOrNull((code) => code.code == countryCode);
  }

  /// eg: countryCodes: ['AE', 'US']
  static List<CountryCode> filterCountryCodes(List<String> filterCodes) {
    final list = countryCodes;
    list.retainWhere(
      (code) => filterCodes.firstWhereOrNull((filterCode) => code.code == filterCode)?.isNotEmpty ?? false,
    );
    return list;
  }
}
