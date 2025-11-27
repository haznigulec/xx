import 'package:piapiri_v2/common/utils/images_path.dart';

enum ThemeEnum {
  light('light', 'light_theme', ImagesPath.light),
  dark('dark', 'dark_theme', ImagesPath.dark),
  deviceSettings('device', 'device_settings', ImagesPath.system);

  final String value;
  final String localizationKey;
  final String iconPath;
  const ThemeEnum(
    this.value,
    this.localizationKey,
    this.iconPath,
  );
}
