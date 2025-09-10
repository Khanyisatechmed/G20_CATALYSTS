import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARViewerScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ARViewerScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final modelUrl = product['modelUrl'] ?? 'assets/models/ZuluHat.glb';
    final iosModelUrl = product['iosModelUrl'] ?? 'assets/models/ZuluHat.usdz';

    return Scaffold(
      appBar: AppBar(
        title: Text(product['title'] ?? '3D Model'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ModelViewer(
                src: modelUrl,
                iosSrc: iosModelUrl,
                alt: product['title'] ?? '3D Model',
                ar: true,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(product['title'] ?? '3D Model'),
                    content: Text(
                        'Created by ${product['artisan'] ?? 'Local Artisan'}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Info'),
            ),
          ),
        ],
      ),
    );
  }
}
