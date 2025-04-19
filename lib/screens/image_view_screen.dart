// lib/screens/image_view_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../models/gallery_model.dart';
import 'dart:typed_data';


class ImageViewScreen extends StatefulWidget {
  final List<AssetEntity> images;
  final int initialIndex;
  
  const ImageViewScreen({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late PageController _pageController;
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image ${_currentIndex + 1} of ${widget.images.length}'),
        actions: [
          IconButton(
            icon: Consumer<GalleryModel>(
              builder: (context, model, child) {
                return Icon(
                  model.isFavorite(widget.images[_currentIndex]) 
                    ? Icons.favorite 
                    : Icons.favorite_border,
                  color: model.isFavorite(widget.images[_currentIndex]) 
                    ? Colors.red 
                    : null,
                );
              },
            ),
            onPressed: () {
              final model = Provider.of<GalleryModel>(context, listen: false);
              model.toggleFavorite(widget.images[_currentIndex]);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              // final file = await widget.images[_currentIndex].file;
              // TODO: Implement sharing functionality
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: FutureBuilder<Uint8List?>(
                future: widget.images[index].originBytes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && 
                      snapshot.data != null) {
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.contain,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}