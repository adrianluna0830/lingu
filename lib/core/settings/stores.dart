import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

@singleton
class SecureStore implements SignalsKeyValueStore {
  SecureStore() : _storage = const FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getItem(String key) => _storage.read(key: key);

  @override
  Future<void> removeItem(String key) => _storage.delete(key: key);

  @override
  Future<void> setItem(String key, String value) =>
      _storage.write(key: key, value: value);
}

@singleton
class SharedPreferencesStore implements SignalsKeyValueStore {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<String?> getItem(String key) async => (await _init()).getString(key);

  @override
  Future<void> removeItem(String key) async => (await _init()).remove(key);

  @override
  Future<void> setItem(String key, String value) async =>
      (await _init()).setString(key, value);
}

class PersistedNullableEnumSignal<T extends Enum> extends PersistedSignal<T?> {
  PersistedNullableEnumSignal(
    String key,
    this.values, {
    required SignalsKeyValueStore store,
  }) : super(null, key: key, store: store);

  final List<T> values;

  @override
  T? decode(String value) {
    if (value == 'null') return null;
    return values.firstWhere((e) => e.name == value);
  }

  @override
  String encode(T? value) => value?.name ?? 'null';
}
