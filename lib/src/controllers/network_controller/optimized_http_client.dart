import 'dart:async';

import 'package:http/http.dart' as http;

class OptimizedHttpClient {
  static Future<http.Response> post({
    required Uri url, 
    Map<String, String>? headers,
    Object? body,
    int maxRetries = 2,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await http.post(
          url,
          headers: headers,
          body: body,
        ).timeout(timeout);

        if (response.statusCode == 200) {
          return response;
        }

        // Handle specific error codes if needed
        if (response.statusCode >= 500) {
          continue; // Retry on server errors
        }

        break; // Don't retry for client errors
      } on TimeoutException {
        if (attempt == maxRetries - 1) rethrow;
      } catch (e) {
        if (attempt == maxRetries - 1) rethrow;
      }
    }

    throw Exception('Failed to complete request');
  }
}