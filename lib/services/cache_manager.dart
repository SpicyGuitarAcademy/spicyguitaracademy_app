import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<File> cacheManager(String url) async {
  return await new DefaultCacheManager().getSingleFile(url);
}

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 14),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      // fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}
