import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_3d_blender/providers/perf_provider.dart';
import 'package:flutter_3d_blender/screens/budgets_screen.dart';
import 'package:flutter_3d_blender/screens/home_screen.dart';
import 'package:flutter_3d_blender/screens/scene_screen.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE6A2FF),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF070A18),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF070A18),
      elevation: 0,
    ),
  );

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: child,
      ),
    );
  }

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot(name);
  }

  testWidgets('01 home pipeline overview', (tester) async {
    await tester.pumpWidget(wrap(const HomeScreen()));
    await tester.pumpAndSettle();
    await shoot(tester, '01-home');
  });

  testWidgets('02 live shader scene', (tester) async {
    await tester.pumpWidget(wrap(const SceneScreen()));
    // The scene boots a shader + ticker animation. Use fixed pumps
    // (not pumpAndSettle, which hangs on the always-on ticker).
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    await shoot(tester, '02-live-scene');
  });

  testWidgets('03 gpu budget panel', (tester) async {
    // Seed a realistic in-budget snapshot so the panel shows real data.
    final seeded = PerfNotifier()
      ..update(const PerfSnapshot(
        fps: 60,
        triangles: 42180,
        drawCalls: 3,
        textureBytes: 4 * 1024 * 1024,
      ));
    await tester.pumpWidget(
      wrap(
        const BudgetsScreen(),
        overrides: [
          perfProvider.overrideWith((ref) => seeded),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await shoot(tester, '03-gpu-budgets');
  });
}
