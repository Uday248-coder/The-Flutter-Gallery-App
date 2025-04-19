// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/gallery_model.dart';
import '../widgets/image_grid.dart';
import '../widgets/album_selector.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load albums when screen initializes
    Future.delayed(Duration.zero, () {
      Provider.of<GalleryModel>(context, listen: false).loadAlbums();
    });
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      // Save the image to gallery
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(await File(pickedFile.path).readAsBytes());
      
      // Refresh gallery to show the new image
      final galleryModel = Provider.of<GalleryModel>(context, listen: false);
      galleryModel.loadAlbums();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo_album),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AlbumSelector(),
              );
            },
          ),
        ],
      ),
      body: Consumer<GalleryModel>(
        builder: (context, galleryModel, child) {
          if (galleryModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (galleryModel.images.isEmpty) {
            return const Center(child: Text('No images found'));
          }
          
          return ImageGrid(images: galleryModel.images);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}