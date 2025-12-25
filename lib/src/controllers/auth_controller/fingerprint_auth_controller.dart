
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/controllers/auth_controller/login_controller.dart';
import 'package:cicl_app/src/states/auth_state/fingerprint_auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart';

class FingerprintAuthController extends StateNotifier<FingerprintAuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final StorageService _storageService;
  final AuthController _authController;

  FingerprintAuthController({
    StorageService? storageService,
    AuthController? authController,
  }) : 
    _storageService = storageService ?? StorageService(),
    _authController = authController ?? AuthController(),
    super(const FingerprintAuthInitial());

  // Method to authenticate using fingerprint
  Future<void> authenticateWithBiometrics(BuildContext context, WidgetRef ref) async {
    state = const FingerprintAuthLoading();

    try {
      // Detailed logging for fingerprint login check
      final isFingerprintEnabled = await _storageService.isFingerprintLoginEnabled();
      final savedCredentials = await _storageService.getFingerprintCredentials();

      // Comprehensive check for fingerprint login readiness
      if (!isFingerprintEnabled) {
        state = const FingerprintAuthError(
          'Fingerprint login is not set up. Please log in with your username and password, then enable fingerprint login in the login screen.'
        );
        return;
      }

      if (savedCredentials == null) {
        state = const FingerprintAuthError(
          'Saved credentials not found. Please log in with your username and password, then set up fingerprint login again.'
        );
        return;
      }

      // Check if biometric authentication is available
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      bool isDeviceSupported = await _localAuthentication.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        state = const FingerprintAuthNotAvailable(
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
        // Perform login outside of widget context
        final loginResult = await _performLogin(
          savedCredentials['email']!, 
          savedCredentials['password']!
        );

        if (loginResult) {
          state = const FingerprintAuthSuccess('Authentication successful');
          
          // Navigate to dashboard if context is still valid
          if (context.mounted) {
            context.go('/dashboardscreen', extra: 0);
          }
        } else {
          state = const FingerprintAuthError('Login failed with saved credentials');
        }
      } else {
        state = const FingerprintAuthError('Authentication failed');
      }
    } catch (e) {
      state = const FingerprintAuthError(
        'An error occurred during authentication',
      );
    }
  }

  // Method to set up fingerprint login with password verification
  Future<void> setupFingerprintLogin(
    String email, 
    String password,
    WidgetRef ref,
  ) async {
    try {
      // Save credentials for future fingerprint login
      await _storageService.enableFingerprintLogin(email, password);

      // Clear user-specific data without removing access token
      await _storageService.clearAllData();

      state = const FingerprintAuthSuccess('Fingerprint login setup successful');
    } catch (e) {
      state = const FingerprintAuthError('Failed to set up fingerprint login');
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
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Please authenticate using your fingerprint';
    } else {
      return 'Please authenticate to log in';
    }
  }
}
