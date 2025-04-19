// lib/models/gallery_model.dart
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryModel extends ChangeNotifier {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _images = [];
  bool _isLoading = false;
  final Set<String> _favorites = {};
  
  List<AssetPathEntity> get albums => _albums;
  List<AssetEntity> get images => _images;
  bool get isLoading => _isLoading;
  Set<String> get favorites => _favorites;
  
  bool isFavorite(AssetEntity image) {
    return _favorites.contains(image.id);
  }
  
  void toggleFavorite(AssetEntity image) {
    if (_favorites.contains(image.id)) {
      _favorites.remove(image.id);
    } else {
      _favorites.add(image.id);
    }
    notifyListeners();
  }
  
  List<AssetEntity> get favoriteImages {
    return _images.where((image) => _favorites.contains(image.id)).toList();
  }

  Future<void> loadAlbums() async {
    _isLoading = true;
    notifyListeners();

    // Request permission
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      // Load all albums
      _albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      
      if (_albums.isNotEmpty) {
        await loadImagesFromAlbum(_albums.first);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadImagesFromAlbum(AssetPathEntity album, {int page = 0, int pageSize = 60}) async {
    _isLoading = true;
    notifyListeners();

    // Load images from selected album
    List<AssetEntity> images = await album.getAssetListPaged(
      page: page,
      size: pageSize,
    );
    
    _images = images;
    
    _isLoading = false;
    notifyListeners();
  }
}