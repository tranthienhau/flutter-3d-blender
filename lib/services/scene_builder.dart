// Scene builder: owns the animated state for the shader-driven scene.
//
// The Flutter Fragment Shader API doesn't do hardware vertex transforms
// like WebGL directly. For full mesh rendering you'd pair this with
// `flutter_gl` or stream vertex data into a ShaderBuilder with a
// CustomPainter. The POC uses a fragment shader over a full-screen
// quad so the whole pipeline stays in pure Flutter.

import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'gltf_loader.dart';

class Scene {
  Scene({
    required this.shader,
    required this.mesh,
    required this.startTimeMs,
  });

  final ui.FragmentShader shader;
  final GltfMeshDescriptor mesh;
  final int startTimeMs;

  double timeNow() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - startTimeMs) / 1000.0;
  }
}

class SceneBuilder {
  Future<Scene> buildButterfly() async {
    final program =
        await ui.FragmentProgram.fromAsset('shaders/butterfly.frag');
    final shader = program.fragmentShader();

    final mesh = await GltfLoader().loadButterfly();

    return Scene(
      shader: shader,
      mesh: mesh,
      startTimeMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void bindShaderUniforms(
    Scene scene, {
    required double width,
    required double height,
    required double tintR,
    required double tintG,
    required double tintB,
    required double camX,
    required double camY,
    required double camZ,
  }) {
    final s = scene.shader;
    // uSize (vec2)
    s.setFloat(0, width);
    s.setFloat(1, height);
    // uTime (float)
    s.setFloat(2, scene.timeNow());
    // uTint (vec3)
    s.setFloat(3, tintR);
    s.setFloat(4, tintG);
    s.setFloat(5, tintB);
    // uCameraPos (vec3)
    s.setFloat(6, camX);
    s.setFloat(7, camY);
    s.setFloat(8, camZ);
  }
}
