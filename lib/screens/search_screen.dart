// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gallery_model.dart';
import '../widgets/image_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  
  @override
  Widget build(BuildContext context) {
    final galleryModel = Provider.of<GalleryModel>(context);
    
    // Filter images based on search query (e.g., by date)
    final filteredImages = galleryModel.images.where((image) {
      final date = image.createDateTime;
      return date.toString().contains(_query);
    }).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by date...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: _query.isEmpty
        ? const Center(child: Text('Enter a search term'))
        : ImageGrid(images: filteredImages),
    );
  }
}