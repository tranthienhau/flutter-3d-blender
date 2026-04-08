import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/perf_provider.dart';
import '../services/scene_builder.dart';

class SceneScreen extends ConsumerStatefulWidget {
  const SceneScreen({super.key});

  @override
  ConsumerState<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends ConsumerState<SceneScreen>
    with SingleTickerProviderStateMixin {
  Scene? _scene;
  late final Ticker _ticker;
  int _frames = 0;
  int _lastFpsTs = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _boot();
  }

  Future<void> _boot() async {
    final scene = await SceneBuilder().buildButterfly();
    if (!mounted) return;
    setState(() => _scene = scene);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _frames += 1;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastFpsTs >= 500) {
      final fps = _frames / ((now - _lastFpsTs) / 1000.0);
      _frames = 0;
      _lastFpsTs = now;
      final mesh = _scene?.mesh;
      if (mesh != null) {
        ref.read(perfProvider.notifier).update(PerfSnapshot(
              fps: fps,
              triangles: mesh.triangleCount,
              drawCalls: mesh.drawCalls,
              textureBytes: mesh.textureBytes,
            ));
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perf = ref.watch(perfProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Live scene')),
      body: _scene == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ShaderPainter(_scene!),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _overlay(perf),
                ),
              ],
            ),
    );
  }

  Widget _overlay(PerfSnapshot perf) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _stat('FPS', perf.fps.toStringAsFixed(0)),
          _stat('TRIS', perf.triangles.toString()),
          _stat('DC', perf.drawCalls.toString()),
          _stat('TEX', '${(perf.textureBytes / (1024 * 1024)).toStringAsFixed(1)}M'),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.scene);
  final Scene scene;

  @override
  void paint(Canvas canvas, Size size) {
    SceneBuilder().bindShaderUniforms(
      scene,
      width: size.width,
      height: size.height,
      tintR: 0.85,
      tintG: 0.55,
      tintB: 0.95,
      camX: 0,
      camY: 0,
      camZ: 3,
    );
    final paint = Paint()..shader = scene.shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) => true;
}
