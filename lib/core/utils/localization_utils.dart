import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class L10n {
  static String resolve(String key, {bool logging = true}) {
    LanguageState state = getIt<LanguageBloc>().state;
    String? resource = state.keys[state.languageCode]?[key];
    if (resource == null) {
      if (logging) {
        talker.warning('Localization key [$key] not found');
      }
      return key;
    }
    return resource;
  }

  static String replaceLinks(String res, {bool logging = true}) {
    final RegExp linkKeyMatcher = RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))');
    final RegExp linkKeyPrefixMatcher = RegExp(r'^@(?:\.([a-z]+))?:');
    final RegExp bracketsMatcher = RegExp('[()]');
    final modifiers = <String, String Function(String?)>{
      'upper': (String? val) => val!.toUpperCase(),
      'lower': (String? val) => val!.toLowerCase(),
      'capitalize': (String? val) => '${val![0].toUpperCase()}${val.substring(1)}',
    };
    final matches = linkKeyMatcher.allMatches(res);
    var result = res;

    for (final match in matches) {
      final link = match[0]!;
      final linkPrefixMatches = linkKeyPrefixMatcher.allMatches(link);
      final linkPrefix = linkPrefixMatches.first[0]!;
      final formatterName = linkPrefixMatches.first[1];

      // Remove the leading @:, @.case: and the brackets
      final linkPlaceholder = link.replaceAll(linkPrefix, '').replaceAll(bracketsMatcher, '');

      var translated = resolve(linkPlaceholder);

      if (formatterName != null) {
        if (modifiers.containsKey(formatterName)) {
          translated = modifiers[formatterName]!(translated);
        } else {
          if (logging) {
            talker.warning('Undefined modifier $formatterName, available modifiers: ${modifiers.keys.toString()}');
          }
        }
      }

      result = translated.isEmpty ? result : result.replaceAll(link, translated);
    }

    return result;
  }

  static String replaceArgs(String res, List<String>? args) {
    final RegExp replaceArgRegex = RegExp('{}');
    if (args == null || args.isEmpty) return res;
    for (var str in args) {
      res = res.replaceFirst(replaceArgRegex, str);
    }
    return res;
  }

  static String replaceNamedArgs(String res, Map<String, String>? args) {
    if (args == null || args.isEmpty) return res;
    args.forEach((String key, String value) => res = res.replaceAll(RegExp('{$key}'), value));
    return res;
  }

  static String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    String res = resolve(
      key,
      logging: false,
    );

    res = replaceLinks(res);

    res = replaceNamedArgs(res, namedArgs);

    return replaceArgs(res, args);
  }
}
