// lib/widgets/album_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gallery_model.dart';

class AlbumSelector extends StatelessWidget {
  const AlbumSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryModel = Provider.of<GalleryModel>(context);
    
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Album',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: galleryModel.albums.length,
              itemBuilder: (context, index) {
                final album = galleryModel.albums[index];
                return ListTile(
                  title: Text(album.name),
                  subtitle: FutureBuilder<int>(
                    future: album.assetCountAsync,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data != null 
                          ? '${snapshot.data} items' 
                          : 'Loading...'
                      );
                    },
                  ),
                  onTap: () {
                    galleryModel.loadImagesFromAlbum(album);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}