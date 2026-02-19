import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import '../utils/storage_helper.dart'; // storage helper for getting the path
import '../l10n/app_localizations.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  // 辅助方法：点击复制内容到剪贴板
  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${l10n.copyToClipboardLabel} $label")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前的存储目录
    final l10n = AppLocalizations.of(context)!;
    final String storagePath = AppStorage.rootDir;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.infoScreenTitle), // "关于 归途地图"
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. 软件图标和版本号区域
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                // 如果你有 Logo，可以把这里换成 Image.asset
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.map, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "${l10n.versionLabel}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Divider(),

          // 2. 数据存储路径
          ListTile(
            leading: const Icon(Icons.folder_special, color: Colors.brown),
            title: Text(l10n.storagePathLabel),
            subtitle: Text(storagePath),
            trailing: const Icon(Icons.copy, size: 20, color: Colors.grey),
            onTap: () => _copyToClipboard(context, storagePath, l10n.storagePathLabel),
          ),
          const Divider(),

          // 3. 联系开发者
          ListTile(
            leading: const Icon(Icons.email, color: Colors.brown),
            title: Text(l10n.contactDeveloperLabel), 
            subtitle: Text(l10n.developerEmail), 
            trailing: const Icon(Icons.copy, size: 20, color: Colors.grey),
            onTap: () => _copyToClipboard(context, l10n.developerEmail, l10n.contactDeveloperLabel),
          ),
          const Divider(),

          // 4. 软件简介/寄语
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${l10n.copyrightNotice}\n\n${l10n.softwareDescription}",
              style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}