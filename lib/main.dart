import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/features/splash/splash_screen.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/routing/app_router.dart';
import 'package:myapp/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;
  bool _showSplash = true;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _appRouter = AppRouter(authProvider);
    _startSplashCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YaComer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: _appRouter.router,
      builder: (context, child) {
        final content = Stack(
          children: [
            if (child != null) Positioned.fill(child: child),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _showSplash
                  ? const SplashScreen(key: ValueKey('splash'))
                  : const SizedBox.shrink(key: ValueKey('content')),
            ),
          ],
        );

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 450),
          opacity: _hasInitialized ? 1 : 0,
          child: content,
        );
      },
    );
  }

  void _startSplashCountdown() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasInitialized && mounted) {
        setState(() => _hasInitialized = true);
      }
      await Future<void>.delayed(const Duration(milliseconds: 2400));
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }
}
