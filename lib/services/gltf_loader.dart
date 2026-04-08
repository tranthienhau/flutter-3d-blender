// glTF / GLB loader stub.
//
// In production this would parse buffers, accessors, and images from
// rootBundle.load('assets/models/butterfly.glb') and feed the vertex data
// into the Flutter Fragment Shader pipeline or into a dedicated GPU mesh
// renderer (like flutter_gl or three_dart).
//
// The POC uses a descriptive SceneDescriptor that the SceneBuilder turns
// into a renderable structure.

class GltfMeshDescriptor {
  const GltfMeshDescriptor({
    required this.name,
    required this.triangleCount,
    required this.textureBytes,
    required this.drawCalls,
    required this.hasSkeleton,
  });

  final String name;
  final int triangleCount;
  final int textureBytes;
  final int drawCalls;
  final bool hasSkeleton;
}

class GltfLoader {
  Future<GltfMeshDescriptor> loadButterfly() async {
    // Placeholder: real code would:
    //
    //   final bytes = await rootBundle.load('assets/models/butterfly.glb');
    //   final doc = parseGlb(bytes.buffer.asUint8List());
    //   return convertToSceneDescriptor(doc);
    //
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const GltfMeshDescriptor(
      name: 'butterfly.glb',
      triangleCount: 42_180,
      textureBytes: 4 * 1024 * 1024, // 4 MB of compressed BC7 textures
      drawCalls: 3,
      hasSkeleton: true,
    );
  }
}
