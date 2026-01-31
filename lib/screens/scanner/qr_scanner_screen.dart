import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

import 'team_details_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {

  static const Color gold = Color(0xFFD4AF37);

  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _heightAnimation = Tween<double>(begin: 4, end: 260).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// HANDLE QR SCAN
  Future<void> _onQrScanned(String teamId) async {
    if (_hasScanned) return;
    _hasScanned = true;

    try {
      final response = await http.post(
        Uri.parse("http://192.168.29.72:8000/get-team-details"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"team_id": teamId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeamDetailsScreen(
              teamData: data["team"],
            ),
          ),
        ).then((_) {
          _hasScanned = false;
        });
      } else {
        _hasScanned = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Team not found")),
        );
      }
    } catch (e) {
      _hasScanned = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backend connection failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          /// TITLE
          Text(
            'SCAN THE QR',
            style: TextStyle(
              color: gold,
              fontSize: 20,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          /// CAMERA OPENING ANIMATION
          Center(
            child: AnimatedBuilder(
              animation: _heightAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 260,
                    height: _heightAnimation.value,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: gold, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: gold.withOpacity(0.4),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: !_controller.isCompleted
                        ? const SizedBox()
                        : Stack(
                            children: [
                              _CameraView(onScanned: _onQrScanned),
                              const _GoldScanLine(),
                              const _CornerBrackets(),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// CAMERA VIEW
class _CameraView extends StatelessWidget {
  final void Function(String code) onScanned;

  const _CameraView({required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      fit: BoxFit.cover,
      onDetect: (capture) {
        if (capture.barcodes.isEmpty) return;

        final code = capture.barcodes.first.rawValue;
        if (code != null && code.isNotEmpty) {
          onScanned(code);
        }
      },
    );
  }
}

/// GOLD SCAN LINE
class _GoldScanLine extends StatefulWidget {
  const _GoldScanLine();

  @override
  State<_GoldScanLine> createState() => _GoldScanLineState();
}

class _GoldScanLineState extends State<_GoldScanLine>
    with SingleTickerProviderStateMixin {

  static const Color gold = Color(0xFFD4AF37);

  late AnimationController _controller;
  late Animation<double> _pos;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pos = Tween<double>(begin: 10, end: 240).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pos,
      builder: (context, child) {
        return Positioned(
          top: _pos.value,
          left: 20,
          right: 20,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  gold,
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: gold,
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// SCI-FI CORNER BRACKETS
class _CornerBrackets extends StatelessWidget {
  static const Color gold = Color(0xFFD4AF37);

  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _corner(top: 8, left: 8),
        _corner(top: 8, right: 8),
        _corner(bottom: 8, left: 8),
        _corner(bottom: 8, right: 8),
      ],
    );
  }

  Widget _corner({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border(
            top: top != null ? BorderSide(color: gold, width: 2) : BorderSide.none,
            left: left != null ? BorderSide(color: gold, width: 2) : BorderSide.none,
            right: right != null ? BorderSide(color: gold, width: 2) : BorderSide.none,
            bottom: bottom != null ? BorderSide(color: gold, width: 2) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
