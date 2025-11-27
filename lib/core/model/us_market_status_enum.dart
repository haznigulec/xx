import 'package:piapiri_v2/common/utils/images_path.dart';

enum UsMarketStatus {
  open('open', 'open_market', ImagesPath.sun),
  preMarket('early_trading', 'pre_market', ImagesPath.yellowCloud),
  afterMarket('late_trading', 'post_market', ImagesPath.cloud),
  closed('closed', 'close_market', ImagesPath.moon),
  weekend('', 'weekend_market', ImagesPath.moon);

  final String value;
  final String localizationKey;
  final String iconPath;
  const UsMarketStatus(
    this.value,
    this.localizationKey,
    this.iconPath,
  );
}
