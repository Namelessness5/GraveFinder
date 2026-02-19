import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/person_model.dart';
import '../l10n/app_localizations.dart';
import './last_mile.dart';
import '../utils/image_picker_helper.dart';
import '../utils/storage_helper.dart';

class PersonDetailScreen extends StatefulWidget {
  final PersonNode person;
  final List<PersonNode> allNodes;
  final List<String> existingLabels;
  
  // 👇 新增这两个参数
  final List<Relationship> relations; 
  final Function(Relationship) onDeleteRelation; 

  final Function() onUpdate;
  final Function(String, String, String) onAddRelation;
  final Function(String) onDeleteNode;

  const PersonDetailScreen({
    super.key,
    required this.person,
    required this.allNodes,
    required this.existingLabels,
    required this.relations, 
    required this.onDeleteRelation, 
    required this.onUpdate,
    required this.onAddRelation,
    required this.onDeleteNode,
  });

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  
  String? _selectedTargetId;
  final TextEditingController _labelController = TextEditingController();

  Future<void> _pickImage() async {
    await ImagePickerHelper.showPicker(context, (String imagePath) {
      setState(() {
        widget.person.imagePath = imagePath;
      });
      widget.onUpdate();
    });
  }

  // 2. 日期选择
  Future<void> _selectDate(BuildContext context, bool isBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(0000),
      lastDate: DateTime(9999),
    );
    if (picked != null) {
      setState(() {
        String formatted = DateFormat('yyyy-MM-dd').format(picked);
        if (isBirth) {
          widget.person.birthDate = formatted;
        } else {
          widget.person.deathDate = formatted;
        }
      });
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final otherNodes = widget.allNodes.where((n) => n.id != widget.person.id).toList();
    
    // 判断是否有图片
    bool hasImage = widget.person.imagePath != null && widget.person.imagePath!.isNotEmpty;
    String? fullPath = AppStorage.getFullPath(widget.person.imagePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailTitle(widget.person.name)),
        actions: [
          // 👇 新增：右上角的删除按钮
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: l10n.deleteNodeTooltip,
            onPressed: () {
              // 弹出防误触确认框
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.deleteConfirmTitle),
                  content: Text("${l10n.deleteConfirmContent} ${widget.person.name}"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx), // 取消，关闭弹窗
                      child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        // 1. 关掉警告弹窗
                        Navigator.pop(ctx); 
                        // 2. 执行真正的删除逻辑
                        widget.onDeleteNode(widget.person.id); 
                        // 3. 退出详情页，退回到主地图！
                        Navigator.pop(context); 
                      },
                      child: Text(l10n.confirmDelete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            // --- 第一部分：头像与基本信息 ---
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.brown[100],
                      // 只有当路径存在且文件确实存在时才显示
                      backgroundImage: (hasImage && File(fullPath!).existsSync())
                          ? FileImage(File(fullPath)) 
                          : null,
                      child: !hasImage 
                          ? const Icon(Icons.person, size: 60, color: Colors.brown) 
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 上传按钮
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(l10n.upload_photo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- 第二部分：信息编辑 ---
            TextField(
              controller: TextEditingController(text: widget.person.name),
              decoration: InputDecoration(labelText: l10n.nameinfo, border: OutlineInputBorder()),
              onChanged: (v) {
                widget.person.name = v;
                widget.onUpdate();
              },
            ),
            const SizedBox(height: 10),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text("${l10n.birthDateHint}: ${widget.person.birthDate ?? ''}"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text("${l10n.deathDateHint}: ${widget.person.deathDate ?? ''}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: TextEditingController(text: widget.person.description),
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.biography, border: OutlineInputBorder()),
              onChanged: (v) {
                widget.person.description = v;
                widget.onUpdate();
              },
            ),
            const SizedBox(height: 20),

            // 👇 新增：最后一公里入口卡片
            Card(
              color: Colors.green[50], // 用淡绿色突出“通行”的感觉
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.withOpacity(0.5)),
              ),
              child: InkWell(
                onTap: () {
                  // 跳转到路书页面 (需要 import 'last_mile_screen.dart')
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (c) => LastMileScreen(
                      person: widget.person,
                      onUpdate: widget.onUpdate,
                    ))
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.map, size: 40, color: Colors.green),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.last_mile_navigation_description1 ?? "最后一公里指引", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text(l10n.last_mile_navigation_description2 ?? "记录寻找墓地的图文路标", style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 40, thickness: 2),

            Text(l10n.connection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // 筛选出和当前人物有关的所有连线
            ...widget.relations
                .where((rel) => rel.fromId == widget.person.id || rel.toId == widget.person.id)
                .map((rel) {
                  // 判断连线方向，找出对方的名字
                  final isFromMe = rel.fromId == widget.person.id;
                  final otherPersonId = isFromMe ? rel.toId : rel.fromId;
                  
                  // 从所有节点中查找到对方那个节点，如果找不到就显示“未知”
                  final otherPerson = widget.allNodes.firstWhere(
                    (n) => n.id == otherPersonId, 
                    orElse: () => PersonNode(id: '', name: l10n.unknownPerson, position: Offset.zero)
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.brown[50],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.brown[200]!, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.link, color: Colors.brown),
                      // 直观地展示方向： [发出者] -> 关系 -> [接收者]
                      title: isFromMe 
                          ? Text("${widget.person.name}  →  ${rel.label}  →  ${otherPerson.name}")
                          : Text("${otherPerson.name}  →  ${rel.label}  →  ${widget.person.name}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.link_off, color: Colors.red),
                        tooltip: l10n.deleteConnectionTooltip,
                        onPressed: () {
                          // 点击解除按钮时的操作
                          setState(() {
                            widget.onDeleteRelation(rel); // 通知主界面删掉
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.connectionDeletedSuccessfully)),
                          );
                        },
                      ),
                    ),
                  );
                }),
                
            // 如果没有任何关系，显示一句提示
            if (widget.relations.where((rel) => rel.fromId == widget.person.id || rel.toId == widget.person.id).isEmpty)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(l10n.noConnectionsTip, style: TextStyle(color: Colors.grey)),
              ),
              
            const SizedBox(height: 20),

            // --- 第三部分：添加关系 (修复版) ---
            Text(l10n.addRelationship, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 检查：如果只有自己一个人，无法建立关系
            if (otherNodes.isEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.orange[100],
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(child: Text(l10n.error_adding_connection_without_others ?? "需要先在主地图添加其他人物，才能在这里建立关系。")),
                  ],
                ),
              )
            else
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: l10n.selectTarget,
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: _selectedTargetId,
                    items: otherNodes.map((n) => DropdownMenuItem(
                      value: n.id, 
                      child: Text(n.name)
                    )).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedTargetId = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  
                  Autocomplete<String>(
                    optionsBuilder: (textValue) {
                      if (textValue.text.isEmpty) return widget.existingLabels;
                      return widget.existingLabels.where((label) => label.contains(textValue.text));
                    },
                    onSelected: (val) => _labelController.text = val,
                    fieldViewBuilder: (ctx, ctrl, focusNode, onSubmitted) {
                      // 这里的 controller 必须传给 Autocomplete 内部使用
                      // 但为了获取值，我们这里做一个简单的同步
                      ctrl.addListener(() {
                        _labelController.text = ctrl.text;
                      });
                      return TextField(
                        controller: ctrl,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: l10n.relationshipLabel,
                          hintText: l10n.relationshipLabelHint,
                          border: const OutlineInputBorder(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.link),
                      label: Text(l10n.saveAndConnect),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // 1. 验证输入
                        if (_selectedTargetId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.input_select_target ?? "请选择一个目标人物")));
                          return;
                        }
                        if (_labelController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.input_relationship_label ?? "请输入关系名称")));
                          return;
                        }

                        // 2. 执行添加
                        widget.onAddRelation(widget.person.id, _selectedTargetId!, _labelController.text);
                        
                        // 3. 反馈并返回
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.build_connection_success ?? "关系添加成功")));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            // 底部留白，防止被键盘遮挡
            const SizedBox(height: 300), 
          ],
        ),
      ),
    );
  }
}