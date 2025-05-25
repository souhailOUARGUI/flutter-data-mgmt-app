import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        isbn TEXT UNIQUE NOT NULL,
        genre TEXT NOT NULL,
        publicationYear INTEGER NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        pages INTEGER NOT NULL,
        language TEXT NOT NULL,
        publisher TEXT NOT NULL,
        dateAdded TEXT NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        rating REAL
      )
    ''');

    // Insérer quelques données de test
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleBooks = [
      {
        'title': 'Le Petit Prince',
        'author': 'Antoine de Saint-Exupéry',
        'isbn': '978-2-07-040850-1',
        'genre': 'Fiction',
        'publicationYear': 1943,
        'price': 12.50,
        'description': 'Un conte poétique et philosophique sous l\'apparence d\'un conte pour enfants.',
        'pages': 96,
        'language': 'Français',
        'publisher': 'Gallimard',
        'dateAdded': DateTime.now().toIso8601String(),
        'isRead': 1,
        'rating': 4.8,
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'isbn': '978-0-452-28423-4',
        'genre': 'Science-Fiction',
        'publicationYear': 1949,
        'price': 15.99,
        'description': 'Un roman dystopique qui dépeint une société totalitaire.',
        'pages': 328,
        'language': 'Anglais',
        'publisher': 'Secker & Warburg',
        'dateAdded': DateTime.now().toIso8601String(),
        'isRead': 0,
        'rating': null,
      },
      {
        'title': 'L\'Étranger',
        'author': 'Albert Camus',
        'isbn': '978-2-07-036002-1',
        'genre': 'Philosophie',
        'publicationYear': 1942,
        'price': 8.90,
        'description': 'Premier roman d\'Albert Camus, publié en 1942.',
        'pages': 186,
        'language': 'Français',
        'publisher': 'Gallimard',
        'dateAdded': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'isRead': 1,
        'rating': 4.2,
      },
    ];

    for (var book in sampleBooks) {
      await db.insert('books', book);
    }
  }

  // CRUD Operations

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books', orderBy: 'dateAdded DESC');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Book>> searchBooks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ? OR genre LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'title ASC',
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<List<Book>> getBooksByGenre(String genre) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'genre = ?',
      whereArgs: [genre],
      orderBy: 'title ASC',
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getAllGenres() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT genre FROM books ORDER BY genre ASC',
    );
    return maps.map((map) => map['genre'] as String).toList();
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    
    final totalBooks = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM books'),
    ) ?? 0;
    
    final readBooks = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM books WHERE isRead = 1'),
    ) ?? 0;
    
    final avgRating = await db.rawQuery(
      'SELECT AVG(rating) as avgRating FROM books WHERE rating IS NOT NULL',
    );
    
    final totalValue = await db.rawQuery(
      'SELECT SUM(price) as totalValue FROM books',
    );

    return {
      'totalBooks': totalBooks,
      'readBooks': readBooks,
      'unreadBooks': totalBooks - readBooks,
      'averageRating': avgRating.first['avgRating'] ?? 0.0,
      'totalValue': totalValue.first['totalValue'] ?? 0.0,
    };
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
