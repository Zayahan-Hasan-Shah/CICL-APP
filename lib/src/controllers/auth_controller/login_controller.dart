import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cicl_app/src/controllers/exception_controller/exception_controller.dart';
import 'package:cicl_app/src/core/constants/api_url.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/models/user_model/user_model.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_provider.dart';
import 'package:cicl_app/src/providers/family_provider/family_provider.dart';
import 'package:cicl_app/src/providers/service_provider/servvice_provider.dart';
import 'package:cicl_app/src/states/auth_state/login_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthController extends StateNotifier<AuthState> {
  final StorageService _storageService;

  AuthController({StorageService? storageService})
    : _storageService = storageService ?? StorageService(),
      super(AuthInitial());

  Future<bool> checkExistingLogin() async {
    return await _storageService.isTokenValid();
  }

  Future<UserModel?> loginWithoutRef(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {
          "Content-Type": "application/json",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey("code")) {
          return null;
        } else {
          final user = UserModel.fromJson(data);
          await _storageService.saveJwtToken(
            token: user.accessToken,
            username: user.name,
            married: user.married,
          );
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
        await _saveEssentialUserData(user);
        _fetchAdditionalDataAsync(ref, user);
        state = AuthSuccess(user);
        return user;
      } else {
        state = AuthError("Invalid credentials. Please try again.");
      }
    } catch (e) {
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
        headers: {
          "Content-Type": "application/json",
          "User-Agent": "CICL-Mobile-App/1.0",
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey("code")) {
          return null;
        } else {
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
        "An unexpected error occurred. Please try again. ($e)",
      );
    }
    return null;
  }

  Future<void> _saveEssentialUserData(UserModel user) async {
    await Future.wait([
      _storageService.saveJwtToken(
        token: user.accessToken,
        username: user.name,
        married: user.married,
      ),
      _storageService.saveAccessToken(user.accessToken),
      _storageService.saveCardNumber(user.cardNumber),
      _storageService.saveName(user.name),
    ]);
  }

  void _fetchAdditionalDataAsync(WidgetRef ref, UserModel user) {
    Future.microtask(() async {
      try {
        final familyProvider = ref.read(
          familyMemberControllerProvider.notifier,
        );
        final claimProvider = ref.read(claimControllerProvider.notifier);
        final serviceProvider = ref.read(serviceControllerProvider.notifier);

        // Wait for all data to fetch before proceeding
        await Future.wait([
          familyProvider.fetchFamilyMembers(),
          claimProvider.fetchClaims(page: 0, pageSize: 10),
          serviceProvider.fetchService(),
        ]);

        final familyState = ref.read(familyMemberControllerProvider);
        final familyNames = familyState.family;

        await _storageService.saveUserAndFamilyNames(
          userName: user.name,
          familyMembers: familyNames,
        );
      } catch (e) {}
    });
  }

  Future<void> initializeUserSession(WidgetRef ref) async {
    try {
      final tokenValid = await _storageService.isTokenValid();
      if (!tokenValid) return;

      final familyProvider = ref.read(familyMemberControllerProvider.notifier);
      final claimProvider = ref.read(claimControllerProvider.notifier);

      await familyProvider.fetchFamilyMembers();
      await claimProvider.fetchClaims(page: 0, pageSize: 10);
    } catch (_) {}
  }
}