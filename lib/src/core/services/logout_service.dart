import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../storage/storage_service.dart';
import '../../routing/routes_names.dart';

class LogoutService {
  final StorageService _storageService;

  LogoutService(this._storageService);

  Future<void> logout(BuildContext context) async {
    try {
      // Clear all stored data
      await _storageService.clearAllData();

      // Additional cleanup steps
      await _performAdditionalCleanup();

      // Navigate to login screen
      if (!context.mounted) return;
      context.go(RoutesNames.loginScreen);
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
      // Fallback navigation in case of error
      if (!context.mounted) return;
      context.go(RoutesNames.loginScreen);
    }
  }

  Future<void> _performAdditionalCleanup() async {
    // Add any additional cleanup logic here
    // For example, cancelling ongoing network requests, 
    // clearing local caches, resetting app state, etc.
    try {
      // Example: Clear any cached data or reset app-specific states
      // You can add more specific cleanup methods as needed
    } catch (e) {
      if (kDebugMode) {
        print('Additional cleanup error: $e');
      }
    }
  }
}





