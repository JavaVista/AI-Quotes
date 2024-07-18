class Quote {
  final String id;
  final String paragraph;
  final String author;
  final String occupation;
  final String imageUrl;
  bool isFavorite;

  Quote({
    required this.id,
    required this.paragraph,
    required this.author,
    required this.occupation,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Quote copyWith({
    String? id,
    String? paragraph,
    String? author,
    String? occupation,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Quote(
      id: id ?? this.id,
      paragraph: paragraph ?? this.paragraph,
      author: author ?? this.author,
      occupation: occupation ?? this.occupation,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      paragraph: json['paragraph'] as String,
      author: json['author'] as String,
      occupation: json['occupation'] as String,
      imageUrl: json['imageUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paragraph': paragraph,
      'author': author,
      'occupation': occupation,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
