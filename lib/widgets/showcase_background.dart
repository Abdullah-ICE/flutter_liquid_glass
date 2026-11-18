import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Background preset options so refraction, blur, dispersion, and adaptivity
/// are immediately visible even offline.
enum ShowcaseBackdropStyle {
  vibrantMesh,
  geometricGrid,
  photoNetwork,
}

/// High-contrast procedural / network background designed to make glass
/// refraction, chromatic dispersion, and blur easy to inspect.
class ShowcaseBackground extends StatelessWidget {
  final ShowcaseBackdropStyle style;
  final bool darkTheme;

  const ShowcaseBackground({
    super.key,
    this.style = ShowcaseBackdropStyle.vibrantMesh,
    this.darkTheme = true,
  });

  static const String _networkPhotoUrl =
      'https://raw.githubusercontent.com/AhmeedGamil/liquid_glass_easy_assets'
      '/main/blending.jpg';

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      ShowcaseBackdropStyle.vibrantMesh => _VibrantMeshBackdrop(dark: darkTheme),
      ShowcaseBackdropStyle.geometricGrid =>
        _GeometricGridBackdrop(dark: darkTheme),
      ShowcaseBackdropStyle.photoNetwork => Stack(
          fit: StackFit.expand,
          children: [
            _VibrantMeshBackdrop(dark: darkTheme),
            Image.network(
              _networkPhotoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: darkTheme
                      ? const [Color(0x33000000), Color(0x66000000)]
                      : const [Color(0x22FFFFFF), Color(0x44FFFFFF)],
                ),
              ),
            ),
          ],
        ),
    };
  }
}

class _VibrantMeshBackdrop extends StatelessWidget {
  final bool dark;
  const _VibrantMeshBackdrop({required this.dark});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VibrantMeshPainter(dark: dark),
      child: const SizedBox.expand(),
    );
  }
}

class _VibrantMeshPainter extends CustomPainter {
  final bool dark;
  const _VibrantMeshPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect full = Offset.zero & size;
    final Paint bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? const [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF064E3B)]
            : const [Color(0xFFE0F2FE), Color(0xFFFCE7F3), Color(0xFFFEF3C7)],
      ).createShader(full);
    canvas.drawRect(full, bg);

    // Glowing color orbs for strong refraction & dispersion reads
    final List<(Offset, double, Color)> orbs = dark
        ? [
            (Offset(size.width * 0.18, size.height * 0.18), size.width * 0.42, const Color(0xCCEC4899)),
            (Offset(size.width * 0.82, size.height * 0.25), size.width * 0.45, const Color(0xCC38BDF8)),
            (Offset(size.width * 0.50, size.height * 0.52), size.width * 0.40, const Color(0xCCF59E0B)),
            (Offset(size.width * 0.20, size.height * 0.80), size.width * 0.46, const Color(0xCC10B981)),
            (Offset(size.width * 0.85, size.height * 0.78), size.width * 0.44, const Color(0xCC8B5CF6)),
          ]
        : [
            (Offset(size.width * 0.18, size.height * 0.18), size.width * 0.42, const Color(0xCCF472B6)),
            (Offset(size.width * 0.82, size.height * 0.25), size.width * 0.45, const Color(0xCC0EA5E9)),
            (Offset(size.width * 0.50, size.height * 0.52), size.width * 0.40, const Color(0xCCFBBF24)),
            (Offset(size.width * 0.20, size.height * 0.80), size.width * 0.46, const Color(0xCC34D399)),
            (Offset(size.width * 0.85, size.height * 0.78), size.width * 0.44, const Color(0xCCA78BFA)),
          ];

    for (final (center, radius, color) in orbs) {
      final Paint p = Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, p);
    }

    // Crisp diagonal stripes & rings so bending at glass edges is unmistakable
    final Paint stripePaint = Paint()
      ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.10)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double step = 36;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.55, size.height),
        stripePaint,
      );
    }

    final Paint ringPaint = Paint()
      ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final Offset center = size.center(Offset.zero);
    for (double r = 40; r < math.max(size.width, size.height); r += 55) {
      canvas.drawCircle(center, r, ringPaint);
    }
  }

  @override
  bool shouldRepaint(_VibrantMeshPainter oldDelegate) =>
      oldDelegate.dark != dark;
}

class _GeometricGridBackdrop extends StatelessWidget {
  final bool dark;
  const _GeometricGridBackdrop({required this.dark});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GeometricGridPainter(dark: dark),
      child: const SizedBox.expand(),
    );
  }
}

class _GeometricGridPainter extends CustomPainter {
  final bool dark;
  const _GeometricGridPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = dark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
    );

    const double cell = 32;
    final List<Color> accents = const [
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF0EA5E9),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ];

    // Colorful horizontal bands
    for (int i = 0; i < accents.length; i++) {
      final double y = (size.height / accents.length) * i;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, 18),
        Paint()..color = accents[i].withValues(alpha: dark ? 0.55 : 0.45),
      );
    }

    // Crisp checkerboard grid lines
    final Paint gridPaint = Paint()
      ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.16)
      ..strokeWidth = 1.2;

    for (double x = 0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // High-contrast dots at intersections
    final Paint dotPaint = Paint()
      ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.35);
    for (double x = 0; x <= size.width; x += cell * 2) {
      for (double y = 0; y <= size.height; y += cell * 2) {
        canvas.drawCircle(Offset(x, y), 3.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_GeometricGridPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
