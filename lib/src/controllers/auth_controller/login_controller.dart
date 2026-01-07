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
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      log("Auth Response");
      log("response body : ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("code")) {
          return null;
        } else {
          // success response (user object)
          final user = UserModel.fromJson(data);

          // Save JWT token with 60-day validity
          await _storageService.saveJwtToken(
            token: user.accessToken,
            username: user.name,
          );

          // Save additional user details
          await _storageService.saveCardNumber(user.cardNumber);

          return user;
        }
      }
    } on SocketException catch (_) {
      return null;
    } on TimeoutException catch (_) {
      return null;
    } on FormatException catch (_) {
      return null;
    } on HttpException catch (_) {
      return null;
    } catch (e) {
      return null;
    }

    return null;
  }

  Future<UserModel?> login(
    String username,
    String password,
    WidgetRef ref,
  ) async {
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
    } catch (e) {
      // Detailed error handling

      if (e is NetworkException) {
        state = AuthError(e.message);
      } else {
        state = AuthError("An unexpected error occurred. Please try again.");
      }
    }

    return null;
  }

  Future<UserModel?> _performLoginApi(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      log("AAAAAAa");
      log("response : ${response.body}");
      log("status : ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("code")) {
          return null;
        } else {
          // success response (user object)
          final user = UserModel.fromJson(data);

          return user;
        }
      }
    } on SocketException catch (_) {
      throw NetworkException(
        "No Internet connection. Please check your network.",
      );
    } on TimeoutException catch (_) {
      throw NetworkException("The request timed out. Please try again.");
    } on FormatException catch (_) {
      throw NetworkException("Invalid response format from the server.");
    } on HttpException catch (_) {
      throw NetworkException("Server returned an invalid response.");
    } catch (e) {
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
      _storageService.saveAccessToken(user.accessToken),
      _storageService.saveCardNumber(user.cardNumber),
      _storageService.saveName(user.name),
    ]);
  }

  void _fetchAdditionalDataAsync(WidgetRef ref, UserModel user) {
    // Use Future.microtask to run these in the background
    Future.microtask(() async {
      try {
        // Capture providers before potential widget unmounting
        final familyProvider = ref.read(
          familyMemberControllerProvider.notifier,
        );
        final claimProvider = ref.read(claimControllerProvider.notifier);

        // These calls won't block the login process
        unawaited(familyProvider.fetchFamilyMembers());
        unawaited(claimProvider.fetchClaims(page: 0, pageSize: 10));

        // Save additional data after fetching
        final familyState = ref.read(familyMemberControllerProvider);
        final familyNames = familyState.family;

        await _storageService.saveUserAndFamilyNames(
          userName: user.name,
          familyNames: familyNames,
        );
      } catch (e) {
        // Silently handle errors to not disrupt user experience
      }
    });
  }

  Future<void> initializeUserSession(WidgetRef ref) async {
    try {
      final tokenValid = await _storageService.isTokenValid();
      if (!tokenValid) return;

      // Trigger your dependent providers to fetch fresh data
      final familyProvider = ref.read(familyMemberControllerProvider.notifier);
      final claimProvider = ref.read(claimControllerProvider.notifier);

      // Await the data fetching to ensure it completes
      await familyProvider.fetchFamilyMembers();
      await claimProvider.fetchClaims(page: 0, pageSize: 10);
    } catch (_) {}
  }
}
