import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _userame = 'user_name';
  static const _accesstoken = 'access_token';
  static const _familyNames = 'family_names';
  static const _cardNumber = 'card_number';
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userame, name);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userame);
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

  Future<void> saveCardNumber(String cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cardNumber, cardNo);
  }

  Future<String?> getCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cardNumber);
  }

  // New method to clear all local storage data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userame);
    await prefs.remove(_accesstoken);
    await prefs.remove(_familyNames);
    await prefs.remove(_cardNumber);
  }
}
