import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetChecker {
  static Future<bool> hasInternet(BuildContext context) async {
    final result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showNoInternetDialog(context);
      return false;
    }
    return true;
  }

  static void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text(
          "Please check your internet connection and try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
