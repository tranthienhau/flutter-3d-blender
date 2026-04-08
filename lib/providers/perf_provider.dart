import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerfSnapshot {
  const PerfSnapshot({
    required this.fps,
    required this.triangles,
    required this.drawCalls,
    required this.textureBytes,
  });

  final double fps;
  final int triangles;
  final int drawCalls;
  final int textureBytes;

  static const zero =
      PerfSnapshot(fps: 0, triangles: 0, drawCalls: 0, textureBytes: 0);
}

class PerfNotifier extends StateNotifier<PerfSnapshot> {
  PerfNotifier() : super(PerfSnapshot.zero);

  void update(PerfSnapshot snap) {
    state = snap;
  }
}

final perfProvider =
    StateNotifierProvider<PerfNotifier, PerfSnapshot>((ref) => PerfNotifier());
