import 'dart:developer';

import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/states/auth_state/fingerprint_auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class FingerprintAuthController extends StateNotifier<FingerprintAuthState> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final StorageService _storageService = StorageService();

  FingerprintAuthController() : super(FingerprintAuthInitial());

  Future<void> authenticateWithBiometrics() async {
    state = FingerprintAuthLoading();

    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      bool isDeviceSupported = await _localAuthentication.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        state = FingerprintAuthNotAvailable(
          'Biometric authentication not available on this device',
        );
        return;
      }

      // Get available biometric types
      final List<BiometricType> availableBiometrics = await _localAuthentication
          .getAvailableBiometrics();

      // Log available biometric types for debugging
      log('Available Biometric Types: $availableBiometrics');

      // Request biometric permission
      var status = await Permission.sensors.request();
      if (!status.isGranted) {
        state = FingerprintAuthError('Biometric permission denied');
        return;
      }

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
        // Retrieve stored credentials or perform login logic
        final storedUsername = await _storageService.getName();

        if (storedUsername != null) {
          state = FingerprintAuthSuccess('Authentication successful');
          // Here you would typically call your login method
          log('Biometric login successful for user: $storedUsername');
        } else {
          state = FingerprintAuthError('No stored user found');
        }
      } else {
        state = FingerprintAuthError('Authentication failed');
      }
    } catch (e) {
      log('Biometric authentication error: $e');
      state = FingerprintAuthError('An error occurred during authentication');
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
