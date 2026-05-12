class AboutUs {
  final List<String> description;
  final String imageUrl;
  final String mission;
  final String vision;

  AboutUs({
    required this.description,
    required this.imageUrl,
    required this.mission,
    required this.vision,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      description: (json['description'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      imageUrl: json['imageUrl'] ?? '',
      mission: json['mission'] ?? '',
      vision: json['vision'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'mission': mission,
      'vision': vision,
    };
  }

  AboutUs copyWith({
    List<String>? description,
    String? imageUrl,
    String? mission,
    String? vision,
  }) {
    return AboutUs(
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      mission: mission ?? this.mission,
      vision: vision ?? this.vision,
    );
  }

  @override
  String toString() {
    return 'AboutUs(description: $description, mission: $mission, vision: $vision)';
  }
}
