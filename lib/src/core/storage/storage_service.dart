import 'package:cicl_app/src/models/family_model/family_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const _userame = 'user_name';
  static const _accesstoken = 'access_token';
  static const _tokenExpiry = 'token_expiry';
  static const _familyNames = 'family_names';
  static const _cardNumber = 'card_number';
  static const _claimSeqNos = 'claim_seq_nos';
  static const _isMarried = "is_married";

  // New constants for fingerprint login
  static const _fingerprintEmail = 'fingerprint_email';
  static const _fingerprintPassword = 'fingerprint_password';
  static const _fingerprintEnabled = 'fingerprint_enabled';

  Future<void> saveIsMarried(String married) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_isMarried, married);
    } catch (_) {}
  }

  Future<String?> getIsMarried() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final married = prefs.getString(_isMarried);
      if (married == null || married.isEmpty) {}
      return married;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userame, name);
    } catch (_) {}
  }

  Future<String?> getName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_userame);

      if (name == null || name.isEmpty) {}

      return name;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accesstoken, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accesstoken);
  }

  Future<void> saveClaimSeqNos(List<String> claimSeqNos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_claimSeqNos, claimSeqNos);
  }

  Future<List<String>> getClaimSeqNos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_claimSeqNos) ?? [];
  }

  Future<void> saveFamilyNames(List<String> familyNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_familyNames, familyNames);
  }

  Future<void> saveUserAndFamilyNames({
    required String userName,
    required List<FamilyModel> familyNames,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userame, userName);
    await prefs.setStringList(
      _familyNames,
      familyNames.map((e) => e.name).toList(),
    );
  }

  Future<List<String>> getFamilyNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_familyNames) ?? [];
  }

  // Ensure card number is always saved with validation
  Future<void> saveCardNumber(String? cardNumber) async {
    try {
      if (cardNumber == null || cardNumber.isEmpty) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_cardNumber, cardNumber);

      // Verify the saved card number
      final savedCardNumber = prefs.getString(_cardNumber);
      if (savedCardNumber != cardNumber) {}
    } catch (_) {}
  }

  Future<String?> getCardNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardNumber = prefs.getString(_cardNumber);

      if (cardNumber == null || cardNumber.isEmpty) {}

      return cardNumber;
    } catch (e) {
      return null;
    }
  }

  // Save JWT token with expiry
  Future<void> saveJwtToken({
    required String token,
    required String username,
    required String married,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // Try to use JWT's own exp claim for expiry.
    // If token is not a standard JWT / has no exp, do NOT invent an expiry.
    DateTime? expiryDate;
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payloadBase64 = base64Url.normalize(parts[1]);
        final payloadString = utf8.decode(base64Url.decode(payloadBase64));
        final payload = jsonDecode(payloadString);

        if (payload is Map && payload['exp'] is int) {
          // exp is in seconds since epoch
          expiryDate = DateTime.fromMillisecondsSinceEpoch(
            payload['exp'] * 1000,
          );
        }
      }
    } catch (e) {
      // If parsing fails, keep expiryDate as null.
      expiryDate = null;
    }

    await prefs.setString(_accesstoken, token);
    await prefs.setString(_userame, username);
    await prefs.setString(_isMarried, married);

    if (expiryDate != null) {
      await prefs.setString(_tokenExpiry, expiryDate.toIso8601String());
    } else {
      await prefs.remove(_tokenExpiry);
    }
  }

  // Check if token is valid
  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if token exists
    final token = prefs.getString(_accesstoken);
    if (token == null) return false;

    // Check token expiry if it exists.
    // If no expiry is stored (non-JWT tokens), treat it as present/usable.
    final expiryString = prefs.getString(_tokenExpiry);
    if (expiryString == null) return true;

    final expiryDate = DateTime.parse(expiryString);
    return expiryDate.isAfter(DateTime.now());
  }

  // Get current token
  Future<String?> getCurrentToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accesstoken);
  }

  // Get remaining token validity
  Future<Duration?> getTokenRemainingValidity() async {
    final prefs = await SharedPreferences.getInstance();

    final expiryString = prefs.getString(_tokenExpiry);
    if (expiryString == null) return null;

    final expiryDate = DateTime.parse(expiryString);
    final now = DateTime.now();

    return expiryDate.isAfter(now) ? expiryDate.difference(now) : null;
  }

  // Refresh token (extend validity)
  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if current token exists
    final currentToken = prefs.getString(_accesstoken);
    if (currentToken == null) return;

    // Extend expiry by 60 days
    final newExpiryDate = DateTime.now().add(const Duration(days: 60));
    await prefs.setString(_tokenExpiry, newExpiryDate.toIso8601String());
  }

  // Fingerprint Login Methods
  Future<void> enableFingerprintLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ensure both email and password are valid
      if (email.isEmpty || password.isEmpty) {
        return;
      }

      // Basic obfuscation (NOT secure encryption - for production, use more robust encryption)
      final encodedEmail = base64Encode(utf8.encode(email));
      final encodedPassword = base64Encode(utf8.encode(password));

      // Explicitly set all required keys
      await prefs.setString(_fingerprintEmail, encodedEmail);
      await prefs.setString(_fingerprintPassword, encodedPassword);
      await prefs.setBool(_fingerprintEnabled, true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disableFingerprintLogin() async {
    try {
      // final prefs = await SharedPreferences.getInstance();

      // await prefs.remove(_fingerprintEmail);
      // await prefs.remove(_fingerprintPassword);
      // await prefs.remove(_fingerprintEnabled);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isFingerprintLoginEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check multiple conditions
      final isEnabledFlag = prefs.getBool(_fingerprintEnabled) ?? false;
      final hasEmail = prefs.getString(_fingerprintEmail) != null;
      final hasPassword = prefs.getString(_fingerprintPassword) != null;

      final isEnabled = isEnabledFlag && hasEmail && hasPassword;

      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>?> getFingerprintCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encodedEmail = prefs.getString(_fingerprintEmail);
      final encodedPassword = prefs.getString(_fingerprintPassword);

      if (encodedEmail == null || encodedPassword == null) {
        return null;
      }

      // Decode credentials with additional error handling
      String? email;
      String? password;

      try {
        email = utf8.decode(base64Decode(encodedEmail));
        password = utf8.decode(base64Decode(encodedPassword));
      } catch (e) {
        return null;
      }

      // Validate decoded credentials
      if (email.isEmpty || password.isEmpty) {
        return null;
      }

      return {'email': email, 'password': password};
    } catch (e) {
      return null;
    }
  }

  // Enhanced method to clear specific local storage data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove specific keys related to user session
      await prefs.remove(_familyNames);

      // Preserve fingerprint login credentials
      final fingerprintEmail = prefs.getString(_fingerprintEmail);
      final fingerprintEnabled = prefs.getBool(_fingerprintEnabled);

      // Remove user-specific tokens and names
      // await prefs.remove(_userame);
      // await prefs.remove(_accesstoken);
      // await prefs.remove(_tokenExpiry);
    } catch (e) {
      rethrow;
    }
  }

  // Method to completely reset all data
  Future<void> fullLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Preserve fingerprint login credentials
      final fingerprintEmail = prefs.getString(_fingerprintEmail);
      final fingerprintPassword = prefs.getString(_fingerprintPassword);
      final fingerprintEnabled = prefs.getBool(_fingerprintEnabled);

      // Clear ALL preferences
      await prefs.clear();

      // Restore fingerprint login credentials if they exist
      if (fingerprintEmail != null &&
          fingerprintPassword != null &&
          fingerprintEnabled == true) {
        await prefs.setString(_fingerprintEmail, fingerprintEmail);
        await prefs.setString(_fingerprintPassword, fingerprintPassword);
        await prefs.setBool(_fingerprintEnabled, true);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Optional: Method to verify if user is logged out
  Future<bool> isLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userame) == null &&
        prefs.getString(_accesstoken) == null;
  }
}
