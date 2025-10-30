import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/details/presentation/details_screen.dart';
import '../features/apply/presentation/apply_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/offer/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailsScreen(offerId: id);
      },
    ),
    GoRoute(
      path: '/apply/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ApplyScreen(offerId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Erreur')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64),
          const SizedBox(height: 16),
          Text('Page non trouvée: ${state.uri}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/search'),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    ),
  ),
);
