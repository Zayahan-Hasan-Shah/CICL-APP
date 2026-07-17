import 'dart:io';

import 'package:cicl_app/src/app/initialize_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final securityContext = SecurityContext(withTrustedRoots: true);
    ByteData? certData;
    try {
      certData = await rootBundle.load('assets/cert/certificate.der');
    } catch (_) {
      try {
        certData = await rootBundle.load('assets/cert/license.pem');
      } catch (_) {
        certData = await rootBundle.load('assets/cert/certificate.pem');
      }
    }

    final certBytes = certData.buffer
        .asUint8List(certData.offsetInBytes, certData.lengthInBytes);
    securityContext.setTrustedCertificatesBytes(certBytes);
    HttpOverrides.global = _CertHttpOverrides(securityContext);
  } catch (_) {}


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
