
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/auth/auth_screen.dart';
import 'package:myapp/src/features/home/home_screen.dart';
import 'package:myapp/src/features/store/store_screen.dart';
import 'package:myapp/src/features/cart/cart_screen.dart';
import 'package:myapp/src/features/checkout/checkout_screen.dart';
import 'package:myapp/src/features/orders/orders_screen.dart';
import 'package:myapp/src/features/orders/order_details_screen.dart';
import 'package:myapp/src/features/account/account_screen.dart';
import 'package:myapp/src/features/account/settings_screen.dart';
import 'package:myapp/src/features/account/cards_screen.dart';
import 'package:myapp/src/providers/auth_provider.dart';


class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'store/:storeId',
            builder: (BuildContext context, GoRouterState state) {
              final storeId = state.pathParameters['storeId']!;
              return StoreScreen(storeId: storeId);
            },
          ),
        ],
      ),
       GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (BuildContext context, GoRouterState state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (BuildContext context, GoRouterState state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (BuildContext context, GoRouterState state) => const OrdersScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: ':orderId',
            builder: (BuildContext context, GoRouterState state) {
              final orderId = state.pathParameters['orderId']!;
              return OrderDetailsScreen(orderId: orderId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) => const AccountScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'settings',
            builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
          ),
           GoRoute(
            path: 'cards',
            builder: (BuildContext context, GoRouterState state) => const CardsScreen(),
          ),
        ],
      ),
    ],
     redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authProvider.isLoggedIn;
        final bool isLoggingIn = state.matchedLocation == '/auth';

        if (!loggedIn && !isLoggingIn) {
          return '/auth';
        }

        if (loggedIn && isLoggingIn) {
          return '/';
        }

        return null;
      },
  );
}
