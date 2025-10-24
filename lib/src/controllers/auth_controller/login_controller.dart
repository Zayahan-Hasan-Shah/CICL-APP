import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cicl_app/src/controllers/exception_controller/exception_controller.dart';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/user_model/user_model.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_provider.dart';
import 'package:cicl_app/src/providers/family_provider/family_provider.dart';
import 'package:cicl_app/src/states/auth_state/login_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthController extends StateNotifier<AuthState> {
  final StorageService _storageService;

  AuthController({StorageService? storageService})
    : _storageService = storageService ?? StorageService(),
      super(AuthInitial());

  // Check if user is already logged in with a valid token
  Future<bool> checkExistingLogin() async {
    return await _storageService.isTokenValid();
  }

  // Method to login without requiring WidgetRef
  Future<UserModel?> loginWithoutRef(String username, String password) async {
    log("AuthController → Login started for $username");

    try {
      log("*** API URL : ${ApiUrl.loginUrl} ***");
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      log("AuthController → Response code: ${response.statusCode}");
      log("AuthController → Raw body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("code")) {
          // error response
          final message = data["message"] ?? "Invalid credentials";
          log("AuthController → Login failed: $message");
          return null;
        } else {
          // success response (user object)
          final user = UserModel.fromJson(data);
          log("AuthController → Login success: ${user.name}");

          // Save JWT token with 60-day validity
          await _storageService.saveJwtToken(
            token: user.accessToken,
            username: user.name,
          );

          // Save additional user details
          log("Card NO:  ${user.cardNumber}");
          await _storageService.saveCardNumber(user.cardNumber);

          return user;
        }
      }
    } on SocketException catch (e) {
      log("AuthController → Network error: $e");
      return null;
    } on TimeoutException catch (e) {
      log("AuthController → Request timed out: $e");
      return null;
    } on FormatException catch (e) {
      log("AuthController → Response format error: $e");
      return null;
    } on HttpException catch (e) {
      log("AuthController → HTTP error: $e");
      return null;
    } catch (e, stackTrace) {
      log("AuthController → Unexpected exception: $e");
      log("AuthController → Stack trace: $stackTrace");
      return null;
    }

    return null;
  }

  Future<UserModel?> login(
    String username,
    String password,
    WidgetRef ref,
  ) async {
    log("AuthController → Login started for $username");
    state = AuthLoading();

    try {
      final user = await _performLoginApi(username, password);
      if (user != null) {
        // Save critical user data immediately
        await _saveEssentialUserData(user);
        // Trigger background data fetching without awaiting
        _fetchAdditionalDataAsync(ref, user);

        state = AuthSuccess(user);
        return user;
      } else {
        // Explicitly handle null user (invalid credentials)
        state = AuthError("Invalid credentials. Please try again.");
      }
    } catch (e, stackTrace) {
      // Detailed error handling
      log("AuthController → Login error: $e");
      log("AuthController → Stack trace: $stackTrace");
      
      if (e is NetworkException) {
        state = AuthError(e.message);
      } else {
        state = AuthError("An unexpected error occurred. Please try again.");
      }
    }

    return null;
  }

  Future<UserModel?> _performLoginApi(String username, String password) async {
    log("AuthController → Login started for $username");

    try {
      log("*** API URL : ${ApiUrl.loginUrl} ***");
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      log("AuthController → Response code: ${response.statusCode}");
      log("AuthController → Raw body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("code")) {
          // error response
          final message = data["message"] ?? "Invalid credentials";
          log("AuthController → Login failed: $message");
          return null;
        } else {
          // success response (user object)
          final user = UserModel.fromJson(data);
          log("AuthController → Login success: ${user.name}");

          return user;
        }
      }
    } on SocketException catch (e) {
      log("AuthController → Network error: $e");
      throw NetworkException(
        "No Internet connection. Please check your network.",
      );
    } on TimeoutException catch (e) {
      log("AuthController → Request timed out: $e");
      throw NetworkException("The request timed out. Please try again.");
    } on FormatException catch (e) {
      log("AuthController → Response format error: $e");
      throw NetworkException("Invalid response format from the server.");
    } on HttpException catch (e) {
      log("AuthController → HTTP error: $e");
      throw NetworkException("Server returned an invalid response.");
    } catch (e, stackTrace) {
      log("AuthController → Unexpected exception: $e");
      log("AuthController → Stack trace: $stackTrace");
      throw UnexpectedException(
        "An unexpected error occurred. Please try again.",
      );
    }

    return null;
  }

  Future<void> _saveEssentialUserData(UserModel user) async {
    await Future.wait([
      _storageService.saveJwtToken(
        token: user.accessToken,
        username: user.name,
      ),
      _storageService.saveCardNumber(user.cardNumber),
      _storageService.saveName(user.name),
    ]);
  }

  void _fetchAdditionalDataAsync(WidgetRef ref, UserModel user) {
    // Use Future.microtask to run these in the background
    Future.microtask(() async {
      try {
        // These calls won't block the login process
        await ref
            .read(familyMemberControllerProvider.notifier)
            .fetchFamilyMembers();
        await ref
            .read(claimControllerProvider.notifier)
            .fetchClaims(page: 0, pageSize: 10);

        // Save additional data after fetching
        final familyState = ref.read(familyMemberControllerProvider);
        final familyNames = familyState.family.map((e) => e.name).toList();

        await _storageService.saveUserAndFamilyNames(
          userName: user.name,
          familyNames: familyNames,
        );
      } catch (e) {
        log("Background data fetch error: $e");
        // Silently handle errors to not disrupt user experience
      }
    });
  }
}
