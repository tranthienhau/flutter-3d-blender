import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/perf_provider.dart';

const _fpsTarget = 60;
const _maxTriangles = 150_000;
const _maxDrawCalls = 60;
const _maxTextureMB = 32;

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perf = ref.watch(perfProvider);
    final texMB = perf.textureBytes / (1024 * 1024);

    return Scaffold(
      appBar: AppBar(title: const Text('GPU budgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _row('FPS (target $_fpsTarget)', perf.fps.toStringAsFixed(0),
                perf.fps >= _fpsTarget * 0.9),
            _row('Triangles (max $_maxTriangles)', perf.triangles.toString(),
                perf.triangles <= _maxTriangles),
            _row('Draw calls (max $_maxDrawCalls)',
                perf.drawCalls.toString(), perf.drawCalls <= _maxDrawCalls),
            _row('Texture memory (max ${_maxTextureMB}MB)',
                '${texMB.toStringAsFixed(1)} MB', texMB <= _maxTextureMB),
            const SizedBox(height: 24),
            const Text(
              'If a metric regresses, the 3D artist can rebake textures, reduce vertex count, or split the mesh across fewer draw calls without leaving Blender.',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, bool ok) {
    final color = ok ? const Color(0xFF4CD080) : const Color(0xFFF26565);
    return Card(
      color: const Color(0xFF141A2E),
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Colors.white)),
        trailing: Text(value,
            style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
