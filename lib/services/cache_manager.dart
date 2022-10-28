import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerService {
  ///Checking for video cache
  static Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  ///Caches the videos if not cached
  static Future<void> cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      // print('downloaded successfully done for $url');
    });
  }
}
