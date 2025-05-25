class Book {
  final int? id;
  final String title;
  final String author;
  final String isbn;
  final String genre;
  final int publicationYear;
  final double price;
  final String description;
  final int pages;
  final String language;
  final String publisher;
  final DateTime dateAdded;
  final bool isRead;
  final double? rating;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.genre,
    required this.publicationYear,
    required this.price,
    required this.description,
    required this.pages,
    required this.language,
    required this.publisher,
    required this.dateAdded,
    this.isRead = false,
    this.rating,
  });

  // Convertir un Book en Map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'genre': genre,
      'publicationYear': publicationYear,
      'price': price,
      'description': description,
      'pages': pages,
      'language': language,
      'publisher': publisher,
      'dateAdded': dateAdded.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'rating': rating,
    };
  }

  // Créer un Book à partir d'une Map de la base de données
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      isbn: map['isbn'] ?? '',
      genre: map['genre'] ?? '',
      publicationYear: map['publicationYear']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      pages: map['pages']?.toInt() ?? 0,
      language: map['language'] ?? '',
      publisher: map['publisher'] ?? '',
      dateAdded: DateTime.parse(map['dateAdded']),
      isRead: map['isRead'] == 1,
      rating: map['rating']?.toDouble(),
    );
  }

  // Créer une copie du livre avec des modifications
  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? isbn,
    String? genre,
    int? publicationYear,
    double? price,
    String? description,
    int? pages,
    String? language,
    String? publisher,
    DateTime? dateAdded,
    bool? isRead,
    double? rating,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      genre: genre ?? this.genre,
      publicationYear: publicationYear ?? this.publicationYear,
      price: price ?? this.price,
      description: description ?? this.description,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      publisher: publisher ?? this.publisher,
      dateAdded: dateAdded ?? this.dateAdded,
      isRead: isRead ?? this.isRead,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, isbn: $isbn}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
