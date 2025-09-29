import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:myapp/widgets/brand_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _logoController;
  late final AnimationController _haloController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();

    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _logoScale = Tween<double>(begin: 0.68, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.15, 1, curve: Curves.easeOutExpo),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _haloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: _OrbitalPainter(
                  progress: _backgroundController.value,
                  colorScheme: colorScheme,
                ),
              );
            },
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_logoController, _haloController]),
                    builder: (context, child) {
                      final haloValue = _haloController.value;

                      return SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _HaloRing(
                              size: 160 + (haloValue * 24),
                              strokeOpacity: 0.18 * (1 - haloValue * 0.35),
                            ),
                            _HaloGlow(
                              size: 140 + (haloValue * 16),
                              glowOpacity: 0.28 * (1 - haloValue * 0.4),
                              colors: [
                                Colors.white.withValues(alpha: 0.18),
                                Colors.transparent,
                              ],
                            ),
                            FadeTransition(
                              opacity: _logoOpacity,
                              child: Transform.rotate(
                                angle: _logoRotation.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: child,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'yaComer.brand.mark',
                      child: const BrandLogo(size: 140, borderRadius: 32, showShadow: false),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Conectando locales con sus fans',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'YaComer sincroniza pedidos mientras cada comercio gestiona su entrega.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.78),
                          height: 1.35,
                        ),
                  ),
                  const SizedBox(height: 44),
                  const _ProgressDots(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HaloRing extends StatelessWidget {
  const _HaloRing({
    required this.size,
    required this.strokeOpacity,
  });

  final double size;
  final double strokeOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white.withValues(alpha: strokeOpacity.clamp(0.0, 1.0)),
        ),
      ),
    );
  }
}

class _HaloGlow extends StatelessWidget {
  const _HaloGlow({
    required this.size,
    required this.glowOpacity,
    required this.colors,
  });

  final double size;
  final double glowOpacity;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors.first.withValues(alpha: glowOpacity.clamp(0.0, 1.0)),
            colors.last,
          ],
        ),
      ),
    );
  }
}

class _ProgressDots extends StatefulWidget {
  const _ProgressDots();

  @override
  State<_ProgressDots> createState() => _ProgressDotsState();
}

class _ProgressDotsState extends State<_ProgressDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    return SizedBox(
      width: 72,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final progress = (_controller.value + index * 0.2) % 1;
              final scale = 0.6 + (math.sin(progress * 2 * math.pi) + 1) * 0.2;
              final opacity = 0.45 + (math.sin(progress * 2 * math.pi) + 1) * 0.27;
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _OrbitalPainter extends CustomPainter {
  _OrbitalPainter({
    required this.progress,
    required this.colorScheme,
  });

  final double progress;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide * 0.55;

    final arcColors = [
      colorScheme.onPrimary.withValues(alpha: 0.2),
      colorScheme.secondary.withValues(alpha: 0.22),
      colorScheme.tertiary.withValues(alpha: 0.18),
    ];

    for (var i = 0; i < arcColors.length; i++) {
      final radius = maxRadius - (i * 46);
      if (radius <= 0) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 - i.toDouble()
        ..color = arcColors[i]
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      final start = progress * 2 * math.pi + (i * math.pi / 3);
      final sweep = math.pi * (1.4 - i * 0.22);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }

    final orbitPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 4; i++) {
      final angle = (progress + i * 0.25) * 2 * math.pi;
      final orbitRadius = maxRadius - 40 - (i * 24);
      if (orbitRadius <= 0) continue;
      final dx = center.dx + orbitRadius * math.cos(angle);
      final dy = center.dy + orbitRadius * math.sin(angle);
      final pulse = (math.sin(angle + progress * 2 * math.pi) + 1) / 2;
      orbitPaint.color = Colors.white.withValues(alpha: 0.05 + pulse * 0.08);
      canvas.drawCircle(Offset(dx, dy), 12 - i * 1.6, orbitPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitalPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colorScheme != colorScheme;
  }
}
