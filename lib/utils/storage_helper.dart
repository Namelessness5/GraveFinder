import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AppStorage {
  static late String rootDir;      // 统一根目录
  static late String imagesDir;    // 专属图片文件夹
  static late String dataFilePath; // 你的 JSON 文件路径

  // 1. 在 App 启动时调用，初始化所有路径
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    rootDir = dir.path;
    dataFilePath = '$rootDir/map_data.json';

    // 创建图片专属目录
    final imgDir = Directory('$rootDir/images');
    if (!await imgDir.exists()) {
      await imgDir.create(recursive: true);
    }
    imagesDir = imgDir.path;
  }

  // 2. 把缓存图片拷贝到我们的安全目录，并返回单纯的“文件名”
  static Future<String> saveImageToAppDir(String tempPath) async {
    final extension = p.extension(tempPath); // 获取 .jpg 或 .png
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension'; // 用时间戳做文件名
    final newPath = '$imagesDir/$fileName';
    
    await File(tempPath).copy(newPath); // 核心：复制文件过去
    return fileName; // 只返回文件名，供 JSON 存储
  }

  // 3. UI 渲染时，把文件名还原成绝对路径
  static String? getFullPath(String? fileName) {
    if (fileName == null || fileName.isEmpty) return null;
    // 兼容老数据：如果你的老数据存了全路径，直接返回
    if (fileName.contains('/') || fileName.contains('\\')) return fileName; 
    return '$imagesDir/$fileName';
  }
}