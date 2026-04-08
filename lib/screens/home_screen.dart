import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blender to Flutter pipeline')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Take Blender assets, export to glTF/GLB, and run them live on mobile through Flutter\'s Fragment Shader API with custom GLSL.',
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 24),
            _bullet('Custom GLSL fragment shader'),
            _bullet('PBR-lite Schlick Fresnel'),
            _bullet('Procedural IBL diffuse + specular'),
            _bullet('glTF / GLB mesh import pipeline'),
            _bullet('Mobile GPU budget monitor'),
            const Spacer(),
            FilledButton(
              onPressed: () => context.push('/scene'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Open live scene'),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.push('/budgets'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('GPU budget panel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: Color(0xFFE6A2FF), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
