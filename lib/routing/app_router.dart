import 'package:go_router/go_router.dart';

import 'package:myapp/features/account/account_screen.dart';
import 'package:myapp/features/account/cards_screen.dart';
import 'package:myapp/features/account/settings_screen.dart';
import 'package:myapp/features/auth/auth_screen.dart';
import 'package:myapp/features/cart/cart_screen.dart';
import 'package:myapp/features/checkout/checkout_screen.dart';
import 'package:myapp/features/home/home_screen.dart';
import 'package:myapp/features/orders/order_details_screen.dart';
import 'package:myapp/features/orders/orders_screen.dart';
import 'package:myapp/features/store/store_screen.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/animated_nav_bar.dart';

class AppRouter {
  AppRouter(this.authProvider);

  final AuthProvider authProvider;

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AnimatedNavShell(state: state, child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'store/:storeId',
                builder: (context, state) {
                  final storeId = state.pathParameters['storeId']!;
                  return StoreScreen(storeId: storeId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: ':orderId',
                builder: (context, state) {
                  final orderId = state.pathParameters['orderId']!;
                  return OrderDetailsScreen(orderId: orderId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: 'cards',
                builder: (context, state) => const CardsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation == '/auth';

      if (!loggedIn && !isAuthRoute) {
        return '/auth';
      }

      if (loggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
  );
}
