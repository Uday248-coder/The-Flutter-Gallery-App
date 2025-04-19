// lib/widgets/image_grid.dart
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../screens/image_view_screen.dart';
import 'dart:typed_data';


class ImageGrid extends StatelessWidget {
  final List<AssetEntity> images;
  
  const ImageGrid({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewScreen(
                  images: images,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: FutureBuilder<Uint8List?>(
            future: images[index].thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && 
                  snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}