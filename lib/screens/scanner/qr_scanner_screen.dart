import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Team QR'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final String? code = barcodeCapture.barcodes.first.rawValue;

          if (code != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Scanned: $code')),
            );
          }
        },
      ),
    );
  }
}
  