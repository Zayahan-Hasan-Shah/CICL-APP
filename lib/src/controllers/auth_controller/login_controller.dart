import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
  AuthController() : super(AuthInitial());

  Future<UserModel?> login(
    String username,
    String password,
    WidgetRef ref,
  ) async {
    log("AuthController → Login started for $username");
    state = AuthLoading();

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
          state = AuthError(message);
          return null;
        } else {
          // success response (user object)
          final user = UserModel.fromJson(data);
          log("AuthController → Login success: ${user.name}");
          await StorageService().saveAccessToken(user.accessToken);
          await StorageService().saveName(user.name);
          await StorageService().saveCardNumber(user.cardNumber);

          // Fetch family members
          final familyController = ref.read(
            familyMemberControllerProvider.notifier,
          );

          // Fetch claim controller
          final claimController = ref.read(claimControllerProvider.notifier);

          // calling family controller
          await familyController.fetchFamilyMembers();
          // calling claim controller
          await claimController.fetchClaims(page: 0, pageSize: 10);

          // Get family names from state
          final familyState = ref.read(familyMemberControllerProvider);
          final familyNames = familyState.family.map((e) => e.name).toList();

          // Save both user + family names together
          await StorageService().saveUserAndFamilyNames(
            userName: user.name,
            familyNames: familyNames,
          );
          state = AuthSuccess(user);
          return user;
        }
      }
    } on SocketException catch (e) {
      log("AuthController → Network error: $e");
      state = AuthError("No Internet connection. Please check your network.");
      return null;
    } on TimeoutException catch (e) {
      log("AuthController → Request timed out: $e");
      state = AuthError("The request timed out. Please try again.");
      return null;
    } on FormatException catch (e) {
      log("AuthController → Response format error: $e");
      state = AuthError("Invalid response format from the server.");
      return null;
    } on HttpException catch (e) {
      log("AuthController → HTTP error: $e");
      state = AuthError("Server returned an invalid response.");
      return null;
    } catch (e, stackTrace) {
      log("AuthController → Unexpected exception: $e");
      log("AuthController → Stack trace: $stackTrace");
      state = AuthError("An unexpected error occurred. Please try again.");
      return null;
    }
  }
}
