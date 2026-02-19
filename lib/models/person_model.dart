import 'package:flutter/material.dart';

// 新增：单步指引模型
class GuideStep {
  String description;
  String? imagePath;

  GuideStep({required this.description, this.imagePath});

  Map<String, dynamic> toMap() => {
    'desc': description,
    'img': imagePath,
  };

  factory GuideStep.fromMap(Map<String, dynamic> map) {
    return GuideStep(
      description: map['desc'] ?? "",
      imagePath: map['img'],
    );
  }
}

class PersonNode {
  final String id;
  String name;
  Offset position;
  String? birthDate;
  String? deathDate;
  String description;
  String? imagePath;
  
  // 新增：存储指引步骤的列表
  List<GuideStep> steps; 

  PersonNode({
    required this.id, 
    required this.name, 
    required this.position,
    this.birthDate, 
    this.deathDate, 
    this.description = "", 
    this.imagePath,
    // 初始化时默认为空列表
    List<GuideStep>? steps, 
  }) : steps = steps ?? [];

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'dx': position.dx, 'dy': position.dy,
    'birth': birthDate, 'death': deathDate, 'desc': description, 'image': imagePath,
    // 序列化列表
    'steps': steps.map((s) => s.toMap()).toList(),
  };

  factory PersonNode.fromMap(Map<String, dynamic> map) {
    return PersonNode(
      id: map['id'],
      name: map['name'],
      position: Offset(map['dx'], map['dy']),
      birthDate: map['birth'],
      deathDate: map['death'],
      description: map['desc'] ?? "",
      imagePath: map['image'],
      // 反序列化列表
      steps: (map['steps'] as List<dynamic>?)
          ?.map((item) => GuideStep.fromMap(item))
          .toList(),
    );
  }
}
// Relationship 类保持不变...
class Relationship {
  String fromId;
  String toId;
  String label;
  Relationship(this.fromId, this.toId, this.label);
}