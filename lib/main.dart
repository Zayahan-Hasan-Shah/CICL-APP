import 'dart:io';

import 'package:cicl_app/src/app/initialize_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final securityContext = SecurityContext(withTrustedRoots: true);
    ByteData? pem;
    try {
      pem = await rootBundle.load('assets/cert/license.pem');
    } catch (_) {
      pem = await rootBundle.load('assets/cert/certificate.pem');
    }

    final pemBytes = pem.buffer
        .asUint8List(pem.offsetInBytes, pem.lengthInBytes);
    securityContext.setTrustedCertificatesBytes(pemBytes);
    HttpOverrides.global = _CertHttpOverrides(securityContext);
  } catch (_) {}

  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: Sizer(builder: (context, orientation, deviceType) {
      return const MyApp();
    }),
  ));
}

class _CertHttpOverrides extends HttpOverrides {
  final SecurityContext _securityContext;
  _CertHttpOverrides(this._securityContext);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(_securityContext);
  }
}
