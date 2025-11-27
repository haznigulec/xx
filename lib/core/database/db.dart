import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future _initializeDatabase() async {
    Database piapiriDatabase;
    final String dbPath = await getDatabasesPath();
    talker.verbose('DB PATH: $dbPath');
    final String path = join(dbPath, 'piapiri.db');
    final bool exist = await databaseExists(path);

    if (exist) {
      talker.critical('Database already exists');
      if (getIt<LocalStorage>().read('first_open') == null ||
          getIt<LocalStorage>().read('app_version') != getIt<AppInfo>().appVersion) {
        getIt<LocalStorage>().delete('latest_update_date');
        await deleteDatabase(path);
        talker.critical('Database removed');
        await _createDb(path);
      }
    } else {
      await _createDb(path);
    }
    piapiriDatabase = await openDatabase(path);
    return piapiriDatabase;
  }

  _createDb(String path) async {
    talker.critical('Database does not exist, creating a copy from assets');
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets/database", "piapiri.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
    talker.critical('Wrote data');
    getIt<LocalStorage>().write('app_version', getIt<AppInfo>().appVersion);
  }
}
