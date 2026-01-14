import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class OptimizedHttpClient {
  static http.Client? _client;
  static HttpClient? _rawHttpClient;

  /// Get a singleton HTTP client that bypasses SSL certificate verification
  static http.Client getClient() {
    if (_client == null) {
      _rawHttpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      _client = IOClient(_rawHttpClient!);
    }
    return _client!;
  }

  /// Send a MultipartRequest with SSL bypass
  static Future<http.Response> sendMultipartRequest(http.MultipartRequest request) async {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    
    try {
      final streamedResponse = await ioClient.send(request);
      return await http.Response.fromStream(streamedResponse);
    } finally {
      ioClient.close();
    }
  }

  static Future<http.Response> post({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
    int maxRetries = 2,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final client = getClient();

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await client.post(
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