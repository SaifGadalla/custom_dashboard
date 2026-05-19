import 'package:cloud_firestore/cloud_firestore.dart';

class AppFile {
  final String id;
  final String name;
  final String url;
  final String type;
  final int size;
  final DateTime createdAt;

  AppFile({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    required this.createdAt,
  });

  factory AppFile.fromJson(Map<String, dynamic> json) {
    return AppFile(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: json['type'],
      size: json['size'],
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppFile copyWith({
    String? id,
    String? name,
    String? url,
    String? type,
    int? size,
    DateTime? createdAt,
  }) {
    return AppFile(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UploadedFile(id: $id, name: $name, url: $url, type: $type, size: $size, createdAt: $createdAt)';
  }
}
