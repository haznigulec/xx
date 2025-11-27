import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class LocalStorageImpl extends LocalStorage {
  late final Box _box;
  late final FlutterSecureStorage _storage;

  LocalStorageImpl(Box hiveBox) {
    _storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
    );
    _box = hiveBox;
  }

  @override
  dynamic readSecure(String key) {
    return _storage.read(key: key);
  }

  @override
  void writeSecure(String key, dynamic value) {
    _storage.write(key: key, value: value);
  }

  @override
  Future writeSecureAsync(String key, dynamic value) {
    return _storage.write(key: key, value: value);
  }

  @override
  void deleteSecure(String key) {
    _storage.delete(key: key);
  }

  @override
  Future deleteSecureAsync(String key) {
    return _storage.delete(key: key);
  }

  @override
  void deleteAllSecure() {
    _storage.deleteAll();
  }

  @override
  dynamic read(String key) {
    return _box.get(key);
  }

  @override
  void write(String key, dynamic value) {
    _box.put(key, value);
  }

  @override
  void delete(String key) {
    _box.delete(key);
  }

  @override
  void deleteAll(List<String> keys) {
    _box.deleteAll(keys);
  }

  @override
  Future writeAsync(String key, dynamic value) {
    return _box.put(key, value);
  }

  @override
  Future deleteAsync(String key) {
    return _box.delete(key);
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
