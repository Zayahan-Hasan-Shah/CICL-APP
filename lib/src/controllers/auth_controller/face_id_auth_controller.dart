import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/controllers/auth_controller/login_controller.dart';
import 'package:cicl_app/src/states/auth_state/face_id_auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart';

class FaceIdAuthController extends StateNotifier<FaceIdAuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final StorageService _storageService;
  final AuthController _authController;

  FaceIdAuthController({
    StorageService? storageService,
    AuthController? authController,
  }) : 
    _storageService = storageService ?? StorageService(),
    _authController = authController ?? AuthController(),
    super(const FaceIdAuthInitial());

  // Method to authenticate using Face ID
  Future<void> authenticateWithBiometrics(BuildContext context, WidgetRef ref) async {
    state = const FaceIdAuthLoading();

    try {
      // Detailed logging for Face ID login check
      final isFaceIdEnabled = await _storageService.isFaceIdLoginEnabled();
      final savedCredentials = await _storageService.getFaceIdCredentials();

      // Comprehensive check for Face ID login readiness
      if (!isFaceIdEnabled) {
        state = const FaceIdAuthError(
          'Face ID login is not set up. Please log in with your username and password, then enable Face ID login in the login screen.'
        );
        return;
      }

      if (savedCredentials == null) {
        state = const FaceIdAuthError(
          'Saved credentials not found. Please log in with your username and password, then set up Face ID login again.'
        );
        return;
      }

      // Check if biometric authentication is available
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      bool isDeviceSupported = await _localAuthentication.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        state = const FaceIdAuthNotAvailable(
          'Biometric authentication not available on this device',
        );
        return;
      }

      // Get available biometric types
      final List<BiometricType> availableBiometrics = await _localAuthentication
          .getAvailableBiometrics();

      // Determine authentication message based on available biometrics
      String authMessage = _getAuthenticationMessage(availableBiometrics);

      // Authenticate
      bool authenticated = await _localAuthentication.authenticate(
        localizedReason: authMessage,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Perform login
        final loginResult = await _performLogin(
          savedCredentials['email']!, 
          savedCredentials['password']!
        );

        if (loginResult) {
          state = const FaceIdAuthSuccess('Authentication successful');
          
          // Navigate to dashboard if context is still valid
          if (context.mounted) {
            context.go('/dashboardscreen', extra: 0);
          }
        } else {
          state = const FaceIdAuthError('Login failed with saved credentials');
        }
      } else {
        state = const FaceIdAuthError('Authentication failed');
      }
    } catch (e) {
      state = const FaceIdAuthError(
        'An error occurred during authentication',
      );
    }
  }

  // Method to set up Face ID login with password verification
  Future<void> setupFaceIdLogin(
    String email, 
    String password,
    WidgetRef ref,
  ) async {
    try {
      // Save credentials for future Face ID login
      await _storageService.enableFaceIdLogin(email, password);

      // Clear user-specific data without removing access token
      await _storageService.clearAllData();

      state = const FaceIdAuthSuccess('Face ID login setup successful');
    } catch (e) {
      state = const FaceIdAuthError('Failed to set up Face ID login');
    }
  }

  // Separate method to perform login without widget context
  Future<bool> _performLogin(String email, String password) async {
    try {
      final response = await _authController.loginWithoutRef(email, password);
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Helper method to generate appropriate authentication message
  String _getAuthenticationMessage(List<BiometricType> availableBiometrics) {
    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Please authenticate using Face ID';
    } else {
      return 'Please authenticate to log in';
    }
  }
}
