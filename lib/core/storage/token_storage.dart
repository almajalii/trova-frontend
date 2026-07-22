import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps flutter_secure_storage for auth token persistence.
/// Uses the OS keychain/keystore instead of SharedPreferences, since a JWT
/// shouldn't sit in plain-text local storage.
class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _pushNotificationsEnabledKey = 'push_notifications_enabled';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> setBiometricEnabled(bool enabled) =>
      _storage.write(key: _biometricEnabledKey, value: enabled.toString());

  Future<bool> isBiometricEnabled() async =>
      (await _storage.read(key: _biometricEnabledKey)) == 'true';

  Future<void> setPushNotificationsEnabled(bool enabled) =>
      _storage.write(key: _pushNotificationsEnabledKey, value: enabled.toString());

  // Defaults to enabled (matches the Settings screen's toggle default) when
  // nothing has been stored yet, rather than defaulting new users to off.
  Future<bool> isPushNotificationsEnabled() async =>
      (await _storage.read(key: _pushNotificationsEnabledKey)) != 'false';
}
