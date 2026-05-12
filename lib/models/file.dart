class File {
  final String id;
  final String name;
  final String url;
  final String type;
  final int size;
  final DateTime createdAt;

  File({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    required this.createdAt,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: json['type'],
      size: json['size'],
      createdAt: json['createdAt'],
    );
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

  File copyWith({
    String? id,
    String? name,
    String? url,
    String? type,
    int? size,
    DateTime? createdAt,
  }) {
    return File(
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
