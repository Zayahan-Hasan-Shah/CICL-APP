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
      await _storageService.clearAllData();
      if (!context.mounted) return;
      context.go(RoutesNames.loginScreen);
    } catch (e) {
      if (kDebugMode) print('Logout error: $e');
    }
  }
}


