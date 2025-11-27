import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/theme_enum.dart';
import 'package:piapiri_v2/core/model/timeout_enum.dart';

class GeneralSettings extends Equatable {
  final ThemeEnum theme;
  final LanguageEnum language;
  final TimeoutEnum timeout;
  final bool keepScreenOpen;
  final bool touchFaceId;

  const GeneralSettings({
    this.theme = ThemeEnum.light,
    this.language = LanguageEnum.turkish,
    this.timeout = TimeoutEnum.fourH,
    this.keepScreenOpen = true,
    this.touchFaceId = false,
  });

  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      theme: ThemeEnum.values.firstWhere((e) => e.value == json['theme']),
      language: LanguageEnum.values.firstWhere((e) => e.value == json['language']),
      timeout: TimeoutEnum.values.firstWhere((e) => e.value == json['timeout']),
      keepScreenOpen: json['keepScreenOpen'],
      touchFaceId: json['touchFaceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.value,
      'language': language.value,
      'timeout': timeout.value,
      'keepScreenOpen': keepScreenOpen,
      'touchFaceId': touchFaceId,
    };
  }

  @override
  List<Object?> get props => [
        theme,
        language,
        timeout,
        keepScreenOpen,
        touchFaceId,
      ];

  GeneralSettings copyWith({
    ThemeEnum? theme,
    LanguageEnum? language,
    TimeoutEnum? timeout,
    bool? keepScreenOpen,
    bool? touchFaceId,
    List<String>? showCases,
  }) {
    return GeneralSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      timeout: timeout ?? this.timeout,
      keepScreenOpen: keepScreenOpen ?? this.keepScreenOpen,
      touchFaceId: touchFaceId ?? this.touchFaceId,
    );
  }
}
