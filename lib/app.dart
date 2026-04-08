import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

class SceneApp extends ConsumerWidget {
  const SceneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Blender 3D Pipeline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
