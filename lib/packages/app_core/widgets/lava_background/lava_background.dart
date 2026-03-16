import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-screen animated deep-space background.
/// Renders a dark gradient + gently twinkling stars.
///
/// Usage:
/// ```dart
/// Stack(
///   fit: StackFit.expand,
///   children: [
///     const LavaBackground(),
///     // your content
///   ],
/// )
/// ```
class LavaBackground extends StatefulWidget {
  const LavaBackground({super.key});

  @override
  State<LavaBackground> createState() => _LavaBackgroundState();
}

class _LavaBackgroundState extends State<LavaBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _SpacePainter(_ctrl.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _SpacePainter extends CustomPainter {
  _SpacePainter(this.t);
  final double t;

  // [xFrac, yFrac, radius, twinkleFreq, twinklePhase, driftAmt, driftFreq, driftPhase]
  //
  // Twinkle:  alpha = 0.5 + 0.5 * sin(t * twinkleFreq * 2π + twinklePhase * 2π)
  //           → pure sin, range 0..1, seamlessly loops dim→bright→dim every cycle.
  //
  // Drift:    offset = driftAmt * sin(t * driftFreq * 2π + driftPhase * 2π)
  //           → star returns to exact anchor every cycle, zero snap.
  //           X and Y use the same offset but opposite signs → gentle diagonal sway.
  static const List<List<double>> _stars = [
    [0.05, 0.08, 1.6, 0.55, 0.00, 0.006, 0.30, 0.00],
    [0.18, 0.03, 1.0, 0.45, 0.20, 0.005, 0.25, 0.13],
    [0.32, 0.12, 2.0, 0.65, 0.45, 0.007, 0.35, 0.27],
    [0.55, 0.05, 1.2, 0.35, 0.60, 0.005, 0.28, 0.40],
    [0.72, 0.09, 1.8, 0.75, 0.10, 0.006, 0.32, 0.53],
    [0.88, 0.04, 1.0, 0.50, 0.75, 0.004, 0.22, 0.67],
    [0.93, 0.18, 1.5, 0.40, 0.30, 0.006, 0.27, 0.80],
    [0.10, 0.22, 1.0, 0.60, 0.55, 0.005, 0.33, 0.07],
    [0.28, 0.28, 2.2, 0.30, 0.80, 0.007, 0.20, 0.20],
    [0.48, 0.20, 1.0, 0.70, 0.15, 0.005, 0.38, 0.33],
    [0.65, 0.25, 1.5, 0.55, 0.40, 0.006, 0.29, 0.47],
    [0.82, 0.30, 1.2, 0.45, 0.65, 0.005, 0.24, 0.60],
    [0.03, 0.45, 1.8, 0.65, 0.90, 0.007, 0.36, 0.73],
    [0.15, 0.55, 1.0, 0.35, 0.25, 0.004, 0.21, 0.87],
    [0.35, 0.50, 1.5, 0.50, 0.50, 0.006, 0.31, 0.03],
    [0.58, 0.48, 2.0, 0.60, 0.70, 0.007, 0.26, 0.17],
    [0.78, 0.52, 1.2, 0.40, 0.05, 0.005, 0.34, 0.30],
    [0.92, 0.42, 1.0, 0.75, 0.35, 0.005, 0.23, 0.43],
    [0.08, 0.72, 1.5, 0.55, 0.60, 0.006, 0.30, 0.57],
    [0.22, 0.68, 2.0, 0.45, 0.85, 0.007, 0.37, 0.70],
    [0.42, 0.75, 1.0, 0.65, 0.20, 0.004, 0.25, 0.83],
    [0.62, 0.70, 1.8, 0.35, 0.45, 0.006, 0.32, 0.97],
    [0.80, 0.68, 1.2, 0.50, 0.95, 0.005, 0.28, 0.10],
    [0.96, 0.60, 1.5, 0.70, 0.30, 0.006, 0.22, 0.23],
    [0.12, 0.88, 1.0, 0.40, 0.55, 0.005, 0.35, 0.37],
    [0.30, 0.92, 1.5, 0.60, 0.75, 0.006, 0.29, 0.50],
    [0.52, 0.85, 2.0, 0.55, 0.10, 0.007, 0.33, 0.63],
    [0.70, 0.90, 1.2, 0.30, 0.40, 0.005, 0.20, 0.77],
    [0.85, 0.82, 1.8, 0.65, 0.65, 0.006, 0.36, 0.90],
    [0.97, 0.78, 1.0, 0.45, 0.88, 0.004, 0.24, 0.05],
    [0.44, 0.36, 1.5, 0.75, 0.50, 0.006, 0.31, 0.18],
    [0.90, 0.35, 1.0, 0.50, 0.15, 0.005, 0.27, 0.32],
    [0.25, 0.42, 1.2, 0.35, 0.72, 0.005, 0.23, 0.45],
    [0.67, 0.58, 1.8, 0.60, 0.33, 0.007, 0.34, 0.58],
    [0.38, 0.65, 1.0, 0.40, 0.90, 0.004, 0.26, 0.72],
    [0.74, 0.40, 2.0, 0.55, 0.18, 0.007, 0.30, 0.85],
    [0.16, 0.80, 1.5, 0.70, 0.60, 0.006, 0.38, 0.98],
    [0.50, 0.95, 1.2, 0.45, 0.42, 0.005, 0.22, 0.12],
    [0.88, 0.88, 1.6, 0.65, 0.78, 0.006, 0.29, 0.25],
    [0.06, 0.35, 1.0, 0.35, 0.05, 0.005, 0.33, 0.38],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // ── 1. Deep space gradient ────────────────────────────────────────────
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.0, -0.4),
          radius: 1.3,
          colors: [
            Color(0xFF12103A), // indigo centre
            Color(0xFF0A0820), // deep navy mid
            Color(0xFF050412), // near-black edge
          ],
          stops: [0.0, 0.55, 1.0],
        ).createShader(Offset.zero & size),
    );

    // ── 2. Subtle colour nebula patches (static, two soft blobs) ─────────
    _drawNebulaBlob(canvas, size, size.width * 0.25, size.height * 0.30,
        size.shortestSide * 0.55, const Color(0x18803DFF));
    _drawNebulaBlob(canvas, size, size.width * 0.78, size.height * 0.65,
        size.shortestSide * 0.48, const Color(0x140060BE));

    // ── 3. Twinkling stars ────────────────────────────────────────────────
    for (final s in _stars) {
      final baseX      = s[0];
      final baseY      = s[1];
      final sr         = s[2];
      final tFreq      = s[3];
      final tPhase     = s[4];
      final driftAmt   = s[5];
      final driftFreq  = s[6];
      final driftPhase = s[7];

      // Seamless twinkle: sin oscillates -1..1, centred at 0.5 → range 0..1
      // No normalisation needed — sin(x) at loop boundaries matches perfectly.
      final twinkle = 0.5 + 0.5 * math.sin(t * tFreq * math.pi * 2 + tPhase * math.pi * 2);

      // Gentle drift — X and Y use offset phases so movement is diagonal/elliptical
      final drift = driftAmt * math.sin(t * driftFreq * math.pi * 2 + driftPhase * math.pi * 2);
      final sx = size.width  * (baseX + drift);
      final sy = size.height * (baseY - drift * 0.6); // slight Y component

      canvas.drawCircle(
        Offset(sx, sy),
        sr,
        Paint()
          ..color = Colors.white.withValues(alpha: twinkle.clamp(0.0, 1.0))
          ..maskFilter = sr >= 1.8
              ? const MaskFilter.blur(BlurStyle.normal, 1.5)
              : null,
      );
    }

    // ── 4. Vignette ───────────────────────────────────────────────────────
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.60),
          ],
          stops: const [0.50, 1.0],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawNebulaBlob(Canvas canvas, Size size,
      double cx, double cy, double radius, Color color) {
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(
            center: Offset(cx, cy), radius: radius))
        ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(_SpacePainter old) => old.t != t;
}
