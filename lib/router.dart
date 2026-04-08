import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/budgets_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scene_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/scene', builder: (_, __) => const SceneScreen()),
      GoRoute(path: '/budgets', builder: (_, __) => const BudgetsScreen()),
    ],
  );
});
