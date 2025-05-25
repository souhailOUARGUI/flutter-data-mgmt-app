import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../utils/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  String _searchQuery = '';
  String _selectedGenre = 'Tous';
  String _sortBy = 'dateAdded';
  bool _sortAscending = false;
  bool _isLoading = false;

  // Getters
  List<Book> get books => _filteredBooks;
  List<Book> get allBooks => _books;
  String get searchQuery => _searchQuery;
  String get selectedGenre => _selectedGenre;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  bool get isLoading => _isLoading;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  BookProvider() {
    loadBooks();
  }

  // Charger tous les livres
  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _databaseHelper.getAllBooks();
      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('Erreur lors du chargement des livres: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter un livre
  Future<bool> addBook(Book book) async {
    try {
      final id = await _databaseHelper.insertBook(book);
      if (id > 0) {
        await loadBooks(); // Recharger la liste
        return true;
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout du livre: $e');
    }
    return false;
  }

  // Mettre à jour un livre
  Future<bool> updateBook(Book book) async {
    try {
      final result = await _databaseHelper.updateBook(book);
      if (result > 0) {
        await loadBooks(); // Recharger la liste
        return true;
      }
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du livre: $e');
    }
    return false;
  }

  // Supprimer un livre
  Future<bool> deleteBook(int id) async {
    try {
      final result = await _databaseHelper.deleteBook(id);
      if (result > 0) {
        await loadBooks(); // Recharger la liste
        return true;
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression du livre: $e');
    }
    return false;
  }

  // Rechercher des livres
  void searchBooks(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Filtrer par genre
  void filterByGenre(String genre) {
    _selectedGenre = genre;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Trier les livres
  void sortBooks(String sortBy, {bool? ascending}) {
    _sortBy = sortBy;
    if (ascending != null) {
      _sortAscending = ascending;
    } else {
      _sortAscending = !_sortAscending;
    }
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Appliquer les filtres et le tri
  void _applyFiltersAndSort() {
    _filteredBooks = List.from(_books);

    // Appliquer la recherche
    if (_searchQuery.isNotEmpty) {
      _filteredBooks = _filteredBooks.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               book.genre.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Appliquer le filtre par genre
    if (_selectedGenre != 'Tous') {
      _filteredBooks = _filteredBooks.where((book) {
        return book.genre == _selectedGenre;
      }).toList();
    }

    // Appliquer le tri
    _filteredBooks.sort((a, b) {
      int comparison = 0;
      
      switch (_sortBy) {
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'author':
          comparison = a.author.compareTo(b.author);
          break;
        case 'publicationYear':
          comparison = a.publicationYear.compareTo(b.publicationYear);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'rating':
          final aRating = a.rating ?? 0;
          final bRating = b.rating ?? 0;
          comparison = aRating.compareTo(bRating);
          break;
        case 'dateAdded':
        default:
          comparison = a.dateAdded.compareTo(b.dateAdded);
          break;
      }

      return _sortAscending ? comparison : -comparison;
    });
  }

  // Obtenir tous les genres
  Future<List<String>> getAllGenres() async {
    try {
      final genres = await _databaseHelper.getAllGenres();
      return ['Tous', ...genres];
    } catch (e) {
      debugPrint('Erreur lors de la récupération des genres: $e');
      return ['Tous'];
    }
  }

  // Obtenir les statistiques
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _databaseHelper.getStatistics();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des statistiques: $e');
      return {
        'totalBooks': 0,
        'readBooks': 0,
        'unreadBooks': 0,
        'averageRating': 0.0,
        'totalValue': 0.0,
      };
    }
  }

  // Marquer un livre comme lu/non lu
  Future<bool> toggleReadStatus(Book book) async {
    final updatedBook = book.copyWith(isRead: !book.isRead);
    return await updateBook(updatedBook);
  }

  // Mettre à jour la note d'un livre
  Future<bool> updateRating(Book book, double rating) async {
    final updatedBook = book.copyWith(rating: rating);
    return await updateBook(updatedBook);
  }

  // Réinitialiser les filtres
  void resetFilters() {
    _searchQuery = '';
    _selectedGenre = 'Tous';
    _sortBy = 'dateAdded';
    _sortAscending = false;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Obtenir un livre par ID
  Future<Book?> getBookById(int id) async {
    try {
      return await _databaseHelper.getBookById(id);
    } catch (e) {
      debugPrint('Erreur lors de la récupération du livre: $e');
      return null;
    }
  }
}
