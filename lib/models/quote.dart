class Quote {
  final String id;
  final String paragraph;
  final String author;
  final String occupation;

  Quote({required this.id, required this.paragraph, required this.author, required this.occupation});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      paragraph: json['paragraph'],
      author: json['author'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paragraph': paragraph,
      'author': author,
      'occupation': occupation,
    };
  }
}
