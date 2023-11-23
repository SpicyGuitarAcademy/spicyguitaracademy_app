import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<File> getCachedFile(String url) async {
  return await new DefaultCacheManager().getSingleFile(url);
}

Future downloadFile(String url) async {
  try {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString('resource_$baseUrl/$url') == null) {
      prefs.setString('resource_$baseUrl/$url', url);
      return await new DefaultCacheManager().downloadFile('$baseUrl/$url');
    } else {
      throw new Exception('Lesson already downloaded');
    }
  } catch (e) {
    throw e;
  }
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
