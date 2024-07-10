class Quote {
  final String id;
  final String paragraph;
  final String author;
  final String occupation;
  bool isFavorite;

  Quote({
    required this.id,
    required this.paragraph,
    required this.author,
    required this.occupation,
    this.isFavorite = false,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      paragraph: json['paragraph'],
      author: json['author'],
      occupation: json['occupation'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paragraph': paragraph,
      'author': author,
      'occupation': occupation,
      'isFavorite': isFavorite,
    };
  }
}
