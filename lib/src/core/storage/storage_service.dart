import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';

class StorageService {
  static const _userame = 'user_name';
  static const _accesstoken = 'access_token';
  static const _tokenExpiry = 'token_expiry';
  static const _familyNames = 'family_names';
  static const _cardNumber = 'card_number';
  
  // New constants for fingerprint login
  static const _fingerprintEmail = 'fingerprint_email';
  static const _fingerprintPassword = 'fingerprint_password';
  static const _fingerprintEnabled = 'fingerprint_enabled';

  Future<void> saveName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userame, name);
      log('Saved user name: $name');
    } catch (e) {
      log('Error saving user name: $e', error: e);
    }
  }

  Future<String?> getName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_userame);
      
      if (name == null || name.isEmpty) {
        log('No user name found in storage');
      }
      
      return name;
    } catch (e) {
      log('Error retrieving user name: $e', error: e);
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

  Future<void> saveFamilyNames(List<String> familyNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_familyNames, familyNames);
  }

  Future<List<String>> getFamilyNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_familyNames) ?? [];
  }

  Future<void> saveUserAndFamilyNames({
    required String userName,
    required List<String> familyNames,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userame, userName);
    await prefs.setStringList(_familyNames, familyNames);
  }

  // Ensure card number is always saved with validation
  Future<void> saveCardNumber(String? cardNumber) async {
    try {
      if (cardNumber == null || cardNumber.isEmpty) {
        log('Attempted to save empty card number');
        return;
      }

      log('Attempting to save card number: $cardNumber');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cardNumber, cardNumber);
      log('Saved card number: $cardNumber');

      // Verify the saved card number
      final savedCardNumber = await prefs.getString(_cardNumber);
      log('Verification - Retrieved card number: $savedCardNumber');
      if (savedCardNumber != cardNumber) {
        log('WARNING: Saved card number does not match input card number');
      }
    } catch (e) {
      log('Error saving card number: $e', error: e);
    }
  }

  Future<String?> getCardNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardNumber = await prefs.getString(_cardNumber);
      
      if (cardNumber == null || cardNumber.isEmpty) {
        log('No card number found in storage');
      }
      
      return cardNumber;
    } catch (e) {
      log('Error retrieving card number: $e', error: e);
      return null;
    }
  }

  // Save JWT token with expiry
  Future<void> saveJwtToken({
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Calculate expiry date (60 days from now)
    final expiryDate = DateTime.now().add(const Duration(days: 60));

    await prefs.setString(_accesstoken, token);
    await prefs.setString(_userame, username);
    await prefs.setString(_tokenExpiry, expiryDate.toIso8601String());
  }

  // Check if token is valid
  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if token exists
    final token = prefs.getString(_accesstoken);
    if (token == null) return false;

    // Check token expiry
    final expiryString = prefs.getString(_tokenExpiry);
    if (expiryString == null) return false;

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

    return expiryDate.isAfter(now) 
      ? expiryDate.difference(now) 
      : null;
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
        log('Cannot enable fingerprint login with empty credentials');
        return;
      }

      // Basic obfuscation (NOT secure encryption - for production, use more robust encryption)
      final encodedEmail = base64Encode(utf8.encode(email));
      final encodedPassword = base64Encode(utf8.encode(password));
      
      // Explicitly set all required keys
      await prefs.setString(_fingerprintEmail, encodedEmail);
      await prefs.setString(_fingerprintPassword, encodedPassword);
      await prefs.setBool(_fingerprintEnabled, true);

      // Verify the values were set
      final storedEmail = prefs.getString(_fingerprintEmail);
      final storedPassword = prefs.getString(_fingerprintPassword);
      final storedEnabled = prefs.getBool(_fingerprintEnabled);

      log('Fingerprint login enable attempt:');
      log('Email stored: ${storedEmail != null}');
      log('Password stored: ${storedPassword != null}');
      log('Enabled flag: $storedEnabled');

      if (storedEmail == null || storedPassword == null || storedEnabled != true) {
        log('Failed to completely store fingerprint login credentials');
        throw Exception('Credential storage failed');
      }

      log('Fingerprint login enabled for email: $email');
    } catch (e) {
      log('Error enabling fingerprint login: $e', error: e);
      rethrow;
    }
  }

  Future<void> disableFingerprintLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_fingerprintEmail);
      await prefs.remove(_fingerprintPassword);
      await prefs.remove(_fingerprintEnabled);

      log('Fingerprint login disabled');
    } catch (e) {
      log('Error disabling fingerprint login: $e', error: e);
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
      
      log('Comprehensive fingerprint login status check:');
      log('Enabled Flag: $isEnabledFlag');
      log('Email Stored: $hasEmail');
      log('Password Stored: $hasPassword');
      log('Overall Enabled: $isEnabled');

      // Additional detailed logging
      if (!isEnabled) {
        log('Fingerprint Login Disabled Reason:');
        if (!isEnabledFlag) log('- Enabled flag is false');
        if (!hasEmail) log('- No email stored');
        if (!hasPassword) log('- No password stored');
      }

      return isEnabled;
    } catch (e) {
      log('Error checking fingerprint login status: $e', error: e);
      return false;
    }
  }

  Future<Map<String, String>?> getFingerprintCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final encodedEmail = prefs.getString(_fingerprintEmail);
      final encodedPassword = prefs.getString(_fingerprintPassword);
      
      if (encodedEmail == null || encodedPassword == null) {
        log('No saved fingerprint credentials found');
        return null;
      }
      
      // Decode credentials with additional error handling
      String? email;
      String? password;

      try {
        email = utf8.decode(base64Decode(encodedEmail));
        password = utf8.decode(base64Decode(encodedPassword));
      } catch (e) {
        log('Error decoding credentials: $e');
        return null;
      }

      // Validate decoded credentials
      if (email.isEmpty || password.isEmpty) {
        log('Decoded credentials are empty');
        return null;
      }
      
      log('Fingerprint credentials retrieved successfully');
      return {
        'email': email,
        'password': password,
      };
    } catch (e) {
      log('Error retrieving fingerprint credentials: $e', error: e);
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
      final fingerprintPassword = prefs.getString(_fingerprintPassword);
      final fingerprintEnabled = prefs.getBool(_fingerprintEnabled);

      // Remove user-specific tokens and names
      await prefs.remove(_userame);
      await prefs.remove(_accesstoken);
      await prefs.remove(_tokenExpiry);

      log('Partial local storage data cleared');
      log('Preserved Fingerprint Credentials: ${fingerprintEmail != null}, Enabled: $fingerprintEnabled');
    } catch (e) {
      log('Error clearing local storage: $e', error: e);
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

        log('Restored Fingerprint Login Credentials');
      }

      log('Complete local storage data cleared');
    } catch (e) {
      log('Error during full logout: $e', error: e);
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
