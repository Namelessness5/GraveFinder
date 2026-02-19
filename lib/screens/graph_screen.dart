import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/line_painter.dart'; 
import '../models/person_model.dart';
import 'detail_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/storage_helper.dart';
import 'info_screen.dart';

class MainGraphScreen extends StatefulWidget {
  final VoidCallback onToggleLang;
  const MainGraphScreen({super.key, required this.onToggleLang});

  @override
  State<MainGraphScreen> createState() => _MainGraphScreenState();
}

class _MainGraphScreenState extends State<MainGraphScreen> {
  final GlobalKey _stackKey = GlobalKey();

  // 不仅能存盘，还能强行刷新界面
  void _updateAndSave() {
    setState(() {});
    _saveData();
  }
  Map<String, PersonNode> nodes = {};
  List<Relationship> relations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- 数据存储逻辑 ---

  Future<void> _saveData() async {
    final file = File(AppStorage.dataFilePath);

    final data = {
      'nodes': nodes.values.map((e) => e.toMap()).toList(),
      'relations': relations.map((e) => {'from': e.fromId, 'to': e.toId, 'label': e.label}).toList(),
    };

    await file.writeAsString(jsonEncode(data));
  }

  Future<void> _loadData() async {
    try {
      final file = File(AppStorage.dataFilePath);
      
      if (!await file.exists()) {
        _generateDefaultNodes();
        return;
      }

      final data = jsonDecode(await file.readAsString());
      setState(() {
        // 使用 fromMap 工厂方法更安全
        nodes = { for (var item in data['nodes']) item['id'] : PersonNode.fromMap(item) };
        relations = (data['relations'] as List).map((e) => Relationship(e['from'], e['to'], e['label'] ?? "")).toList();
      });
    } catch (e) {
      _generateDefaultNodes();
    }
  }

  void _generateDefaultNodes() {
    // 注意：初始化的默认数据通常保持中文即可，或者根据需要修改
    setState(() {
      nodes = {
        "1": PersonNode(id: "1", name: "我", position: const Offset(200, 400)),
      };
    });
  }

  // --- 界面构建 ---

  @override
  Widget build(BuildContext context) {
    // 2. 获取多语言代理
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle), // 3. 使用多语言标题
        actions: [
           IconButton(onPressed: widget.onToggleLang, icon: const Icon(Icons.language)),
           IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const InfoScreen()),
              );
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(1000),
        minScale: 0.5,
        maxScale: 2.0,
        child: Container(
          width: 3000, // 画布够大
          height: 3000,
          color: Colors.grey[50],
          child: Stack(
            key: _stackKey,
            children: [
              CustomPaint(
                painter: LinePainter(nodes, relations),
                size: Size.infinite,
              ),
              ...nodes.values.map((node) => _buildDraggableNode(node)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPersonDialog(),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  // --- 弹窗逻辑 ---

  void _showAddPersonDialog() {
    final l10n = AppLocalizations.of(context)!; // 获取 l10n
    String newName = "";
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addPersonTitle), // "添加新人物"
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.nameLabel, // "姓名"
            hintText: l10n.nameHint,   // "请输入..."
          ),
          onChanged: (v) => newName = v,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel), // "取消"
          ),
          TextButton(
            onPressed: () {
              if (newName.isNotEmpty) {
                _addNewPerson(newName);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.confirm), // "确定"
          ),
        ],
      ),
    );
  }

  void _addNewPerson(String name) {
    setState(() {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      nodes[id] = PersonNode(
        id: id,
        name: name,
        position: const Offset(150, 400), // 默认位置
      );
      _saveData();
    });
  }

  void _deleteNode(String id) {
    setState(() {
      nodes.remove(id);
      relations.removeWhere((rel) => rel.fromId == id || rel.toId == id);
      _saveData();
    });
  }
  // ---专门用于解除某一条连线的方法 ---
  void _deleteRelationship(Relationship rel) {
    setState(() {
      relations.remove(rel);
      _saveData();
    });
  }

  void _addNewRelationship(String from, String to, String label) {
    setState(() {
      relations.add(Relationship(from, to, label));
      _saveData();
    });
  }

  List<String> _getExistingLabels() {
    return relations.map((e) => e.label).toSet().toList();
  }

  Widget _buildDraggableNode(PersonNode node) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => PersonDetailScreen(
                person: node,
                allNodes: nodes.values.toList(),
                existingLabels: _getExistingLabels(),
                relations: relations, // 把所有连线数据传过去
                onUpdate: _updateAndSave, 
                onAddRelation: _addNewRelationship,
                onDeleteNode: _deleteNode,
                onDeleteRelation: _deleteRelationship, // 解除连线的方法
              ),
            ),
          );
        },
        // onSecondaryTap: () => _deleteNode(node.id), 
        child: LongPressDraggable<String>(
          data: node.id,
          feedback: Material(
            color: Colors.transparent,
            child: _nodeUI(node, isDragging: true),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _nodeUI(node),
          ),
          onDragEnd: (details) {
            // 👇 使用 _stackKey 来获取真正准确的内部坐标，忽略外层缩放影响
            final RenderBox renderBox = _stackKey.currentContext!.findRenderObject() as RenderBox;
            final localOffset = renderBox.globalToLocal(details.offset);
            
            setState(() {
              node.position = localOffset;
            });
            _saveData(); 
          },
          child: _nodeUI(node),
        ),
      ),
    );
  }

  Widget _nodeUI(PersonNode node, {bool isDragging = false}) {
    // 提取年份（如果填写了的话，例如 "1950-05-20" 提取出 "1950"）
    String birthYear = node.birthDate?.split('-').first ?? "?";
    String deathYear = node.deathDate?.split('-').first ?? "?";
    bool hasLifeSpan = node.birthDate != null || node.deathDate != null;
    String? fullPath = AppStorage.getFullPath(node.imagePath);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 110, // 固定宽度，让排版更整齐
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: isDragging ? Colors.brown[100] : Colors.orange[50], // 拖动时加深，平时用暖白/宣纸色
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDragging ? Colors.brown[400]! : Colors.brown[200]!, 
          width: isDragging ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDragging ? 0.2 : 0.08), // 拖动时阴影变重，产生“浮起”效果
            blurRadius: isDragging ? 12 : 6,
            offset: Offset(0, isDragging ? 6 : 3), // 阴影向下偏移
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 高度由内容撑开
        children: [
          // 1. 头像区 (带轻微边框的圆头像)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.brown[300]!, width: 2),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: (fullPath != null && File(fullPath).existsSync())
                  ? FileImage(File(fullPath))
                  : null,
              child: (fullPath == null || !File(fullPath).existsSync())
                  ? Icon(Icons.person, color: Colors.brown[200], size: 30)
                  : null,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            node.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // 名字太长显示省略号
          ),
          
          // 3. 生卒年份区 (小字号辅助信息)
          if (hasLifeSpan) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "$birthYear - $deathYear",
                style: TextStyle(fontSize: 10, color: Colors.brown[600]),
              ),
            ),
          ],
          
          // 4. 状态角标区 (例如：是否有最后一公里路书)
          if (node.steps.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 12, color: Colors.green[700]),
                const SizedBox(width: 2),
                Text(l10n.has_last_mile ?? "有路线", style: TextStyle(fontSize: 10, color: Colors.green[700])),
              ],
            )
          ]
        ],
      ),
    );
  }
}