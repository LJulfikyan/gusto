import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimatedNavShell extends StatelessWidget {
  const AnimatedNavShell({super.key, required this.child, required this.state});

  final Widget child;
  final GoRouterState state;

  static const List<_NavItemData> _items = <_NavItemData>[
    _NavItemData(
      route: '/',
      label: 'Inicio',
      icon: Icons.home_rounded,
      color: Color(0xFFEF6C39),
    ),
    _NavItemData(
      route: '/orders',
      label: 'Pedidos',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF2EC4B6),
    ),
    _NavItemData(
      route: '/cart',
      label: 'Carrito',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFFFBF69),
    ),
    _NavItemData(
      route: '/account',
      label: 'Cuenta',
      icon: Icons.person_rounded,
      color: Color(0xFF8D43FF),
    ),
  ];

  static const double _navPadding = 0;

  int _indexForLocation(String location) {
    if (location.startsWith('/orders')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/account')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = state.matchedLocation;
    if (location == '/auth') {
      return child;
    }

    final currentIndex = _indexForLocation(location);
    final activeIndex = currentIndex.clamp(0, _items.length - 1);

    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: _navPadding),
              child: child,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _AnimatedNavBar(
              items: _items,
              currentIndex: activeIndex,
              onItemSelected: (index) {
                final route = _items[index].route;
                final current = state.matchedLocation;
                if (route != current) {
                  GoRouter.of(context).go(route);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedNavBar extends StatelessWidget {
  const _AnimatedNavBar({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final List<_NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const double barHeight = 84;

  Alignment _alignmentForIndex(int index) {
    if (items.length <= 1) return Alignment.center;
    final step = 2 / (items.length - 1);
    return Alignment(-1 + (index * step), 0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final activeColor = items[currentIndex].color;
              return Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeOutCubic,
                    alignment: _alignmentForIndex(currentIndex),
                    child: Container(
                      width: constraints.maxWidth / items.length,
                      height: barHeight,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 360),
                        curve: Curves.easeOutCubic,
                        width: 66,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              activeColor.withValues(alpha: 0.28),
                              activeColor.withValues(alpha: 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final selected = index == currentIndex;
                      return Expanded(
                        child: _NavButton(
                          data: data,
                          selected: selected,
                          onTap: () => onItemSelected(index),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: selected ? 1 : 0, end: selected ? 1 : 0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final iconColor = Color.lerp(
            colorScheme.onSurfaceVariant,
            data.color,
            value,
          )!;
          final textOpacity = value;
          final scale = 0.92 + (0.16 * value);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: scale,
                child: Icon(data.icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 4),
              AnimatedSlide(
                duration: const Duration(milliseconds: 360),
                offset: Offset(0, selected ? 0 : 0.3),
                curve: Curves.easeOut,
                child: Opacity(
                  opacity: textOpacity,
                  child: Text(
                    data.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.route,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String route;
  final String label;
  final IconData icon;
  final Color color;
}
