import 'dart:io';
import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../l10n/app_localizations.dart'; 
import '../utils/image_picker_helper.dart'; 
import '../utils/storage_helper.dart'; //

class LastMileScreen extends StatefulWidget {
  final PersonNode person;
  final Function() onUpdate;

  const LastMileScreen({super.key, required this.person, required this.onUpdate});

  @override
  State<LastMileScreen> createState() => _LastMileScreenState();
}

class _LastMileScreenState extends State<LastMileScreen> {

  // --- 新增：全屏查看大图的页面 ---
  void _showFullScreenImage(BuildContext context, String imagePath, String tag) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white), // 返回按钮变白
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0, // 允许放大 4 倍
            // Hero 动画组件，让图片过渡更丝滑
            child: Hero(
              tag: tag, 
              child: Image.file(File(imagePath)),
            ),
          ),
        ),
      );
    }));
  }

  void _showAddStepDialog() {
    String newDesc = "";
    String? newImgFileName; // 存的是文件名
    
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          // 👇 获取用于预览的完整路径
          String? previewPath = AppStorage.getFullPath(newImgFileName);

          return AlertDialog(
            title: Text(l10n.addStepTitle ?? "添加指引步骤"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.stepDescHint ?? "描述 (例如: 看到大松树左转)",
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (v) => newDesc = v,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    await ImagePickerHelper.showPicker(context, (String fileName) {
                      setStateDialog(() => newImgFileName = fileName); 
                    });
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      // 👇 修复 1：弹窗预览时使用完整的 previewPath
                      image: previewPath != null && File(previewPath).existsSync()
                        ? DecorationImage(image: FileImage(File(previewPath)), fit: BoxFit.cover)
                        : null
                    ),
                    child: previewPath == null 
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                const Icon(Icons.add_a_photo), 
                                Text(l10n.tapToTakePhoto ?? "拍照或选择图片") 
                              ]
                            )
                          )
                        : null,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel ?? "取消")), 
              ElevatedButton(
                onPressed: () {
                  if (newDesc.isNotEmpty) {
                    setState(() {
                      widget.person.steps.add(GuideStep(description: newDesc, imagePath: newImgFileName));
                    });
                    widget.onUpdate();
                    Navigator.pop(ctx);
                  }
                },
                child: Text(l10n.add ?? "添加"),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routeToName != null ? l10n.routeToName(widget.person.name) : "前往 ${widget.person.name} 的路线"),
      ),
      body: widget.person.steps.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  l10n.noRouteRecords ?? "还没有记录路线\n点击右下角开始记录", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(color: Colors.grey[600], fontSize: 16)
                ),
              ],
            ),
          )
        : ReorderableListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: widget.person.steps.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = widget.person.steps.removeAt(oldIndex);
                widget.person.steps.insert(newIndex, item);
              });
              widget.onUpdate();
            },
            itemBuilder: (context, index) {
              final step = widget.person.steps[index];
              // 👇 修复 2：将 JSON 中存的文件名转换为实际的硬盘绝对路径
              final String? fullImagePath = AppStorage.getFullPath(step.imagePath);
              final bool imageExists = fullImagePath != null && File(fullImagePath).existsSync();

              return Card(
                key: ValueKey(step),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown,
                    child: Text("${index + 1}", style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(step.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                  // 👇 修复 3：添加图片点击事件与 Hero 动画
                  subtitle: imageExists
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => _showFullScreenImage(context, fullImagePath, "hero_img_$index"),
                            child: Hero(
                              tag: "hero_img_$index", // 必须保证 tag 唯一
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(fullImagePath), 
                                  height: 150, 
                                  width: double.infinity, 
                                  fit: BoxFit.cover
                                ),
                              ),
                            ),
                          ),
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        widget.person.steps.removeAt(index);
                      });
                      widget.onUpdate();
                    },
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStepDialog,
        icon: const Icon(Icons.add_location_alt),
        label: Text(l10n.recordNewLandmark ?? "记录新路标"),
        backgroundColor: Colors.brown,
      ),
    );
  }
}