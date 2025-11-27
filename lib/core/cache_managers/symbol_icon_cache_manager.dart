import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SymbolIconCacheManager extends CacheManager {
  static const key = 'fastCache';

  static final SymbolIconCacheManager _instance = SymbolIconCacheManager._internal();

  factory SymbolIconCacheManager() => _instance;

  SymbolIconCacheManager._internal()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 30),
            maxNrOfCacheObjects: 500,
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
        );
}
