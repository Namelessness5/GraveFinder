import 'dart:io';
import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../l10n/app_localizations.dart'; 
import '../utils/image_picker_helper.dart'; 

class LastMileScreen extends StatefulWidget {
  final PersonNode person;
  final Function() onUpdate;

  const LastMileScreen({super.key, required this.person, required this.onUpdate});

  @override
  State<LastMileScreen> createState() => _LastMileScreenState();
}

class _LastMileScreenState extends State<LastMileScreen> {

  void _showAddStepDialog() {
    String newDesc = "";
    String? newImgPath;
    
    // 2. 在弹窗方法里获取翻译代理
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(l10n.addStepTitle), // 替换：添加指引步骤
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.stepDescHint, // 替换：描述提示
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (v) => newDesc = v,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  // 👇 使用封装好的工具类
                  onTap: () async {
                    await ImagePickerHelper.showPicker(context, (String path) {
                      setStateDialog(() => newImgPath = path); 
                    });
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      image: newImgPath != null 
                        ? DecorationImage(image: FileImage(File(newImgPath!)), fit: BoxFit.cover)
                        : null
                    ),
                    child: newImgPath == null 
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Icon(Icons.add_a_photo), 
                                Text(l10n.tapToTakePhoto) 
                              ]
                            )
                          )
                        : null,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)), 
              ElevatedButton(
                onPressed: () {
                  if (newDesc.isNotEmpty) {
                    setState(() {
                      widget.person.steps.add(GuideStep(description: newDesc, imagePath: newImgPath));
                    });
                    widget.onUpdate();
                    Navigator.pop(ctx);
                  }
                },
                child: Text(l10n.add),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 3. 在 build 方法里获取翻译代理
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // 替换：带参数的标题
        title: Text(l10n.routeToName(widget.person.name)),
      ),
      body: widget.person.steps.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                // 替换：空状态文本
                Text(
                  l10n.noRouteRecords, 
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
                  subtitle: step.imagePath != null 
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(step.imagePath!), height: 150, width: double.infinity, fit: BoxFit.cover),
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
        // 替换：按钮文本
        label: Text(l10n.recordNewLandmark),
        backgroundColor: Colors.brown,
      ),
    );
  }
}