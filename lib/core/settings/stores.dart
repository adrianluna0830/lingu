import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

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

abstract class PersistedSignal<T> extends FlutterSignal<T>
    with PersistedSignalMixin<T> {
  PersistedSignal(
    super.internalValue, {
    super.autoDispose,
    super.debugLabel,
    required this.key,
    required this.store,
  });

  @override
  final String key;

  @override
  final SignalsKeyValueStore store;
}

mixin PersistedSignalMixin<T> on Signal<T> {
  String get key;
  SignalsKeyValueStore get store;

  bool loaded = false;

  Future<void> init() async {
    try {
      final val = await load();
      super.value = val;
    } catch (e) {
      debugPrint('Error loading persisted signal: $e');
    } finally {
      loaded = true;
    }
  }

  @override
  T get value {
    if (!loaded) init().ignore();
    return super.value;
  }

  @override
  set value(T value) {
    super.value = value;
    save(value).ignore();
  }

  Future<T> load() async {
    final val = await store.getItem(key);
    if (val == null) return value;
    return decode(val);
  }

  Future<void> save(T value) async {
    final str = encode(value);
    await store.setItem(key, str);
  }

  T decode(String value) => jsonDecode(value);

  String encode(T value) => jsonEncode(value);
}

class PersistedNullableEnumSignal<T extends Enum> extends PersistedSignal<T?>
    with ValueListenableSignalMixin<T?> {
  PersistedNullableEnumSignal({
    required super.key,
    required this.values,
    required super.store,
  }) : super(null);

  final List<T> values;

  @override
  T? decode(String value) {
    if (value == 'null') return null;
    return values.firstWhere((e) => e.name == value);
  }

  @override
  String encode(T? value) => value?.name ?? 'null';
}

class PersistedNullableStringSignal extends PersistedSignal<String?>
    with ValueListenableSignalMixin<String?> {
  PersistedNullableStringSignal(
    super.internalValue, {
    required super.key,
    required super.store,
  });

  @override
  String? decode(String value) => value == 'null' ? null : value;

  @override
  String encode(String? value) => value ?? 'null';
}

class PersistedBoolSignal extends PersistedSignal<bool>
    with ValueListenableSignalMixin<bool> {
  PersistedBoolSignal(
    super.internalValue, {
    required super.key,
    required super.store,
  });

  @override
  bool decode(String value) => value == 'true';

  @override
  String encode(bool value) => value.toString();
}

class PersistedDoubleSignal extends PersistedSignal<double>
    with ValueListenableSignalMixin<double> {
  PersistedDoubleSignal(
    super.internalValue, {
    required super.key,
    required super.store,
  });

  @override
  double decode(String value) => double.tryParse(value) ?? 0.0;

  @override
  String encode(double value) => value.toString();
}

class TargetLanguageCEFRSignal<T extends Enum> extends Signal<T?>
    with ValueListenableSignalMixin<T?> {
  final Signal<Enum?> languageSignal;
  final SignalsKeyValueStore store;
  final List<T> cefrValues;
  EffectCleanup? _cleanup;

  TargetLanguageCEFRSignal(
    this.languageSignal, {
    required this.store,
    required this.cefrValues,
  }) : super(null);

  Future<void> init() async {
    _cleanup?.call();

    await _loadForLocale(languageSignal.peek());

    _cleanup = effect(() {
      final locale = languageSignal.value;
      _loadForLocale(locale);
    });

    onDispose(() => _cleanup?.call());
  }

  Future<void> reload() async {
    await _loadForLocale(languageSignal.peek());
  }

  Future<void> _loadForLocale(Enum? locale) async {
    if (locale == null) {
      super.value = null;
      return;
    }
    final key = 'cefr_${locale.name}';
    final val = await store.getItem(key);
    
    // Si el idioma cambió mientras esperábamos la base de datos, abortamos.
    if (languageSignal.peek() != locale) return;

    if (val == null || val == 'null') {
      super.value = null;
    } else {
      super.value = cefrValues.firstWhere(
        (e) => e.name == val,
        orElse: () => cefrValues.first,
      );
    }
  }

  @override
  set value(T? val) {
    super.value = val;
    final locale = languageSignal.peek();
    if (locale != null) {
      final key = 'cefr_${locale.name}';
      store.setItem(key, val?.name ?? 'null');
    }
  }
}
