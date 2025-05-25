import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class SearchFilterWidget extends StatefulWidget {
  const SearchFilterWidget({super.key});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _genres = ['Tous'];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    final genres = await context.read<BookProvider>().getAllGenres();
    setState(() {
      _genres = genres;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Barre de recherche
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher par titre, auteur ou genre...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            bookProvider.searchBooks('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  bookProvider.searchBooks(value);
                },
              ),
              
              const SizedBox(height: 12),
              
              // Filtres et tri
              Row(
                children: [
                  // Filtre par genre
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: bookProvider.selectedGenre,
                      decoration: InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: _genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          bookProvider.filterByGenre(value);
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Tri
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: bookProvider.sortBy,
                      decoration: InputDecoration(
                        labelText: 'Trier par',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'dateAdded',
                          child: Text('Date d\'ajout'),
                        ),
                        DropdownMenuItem(
                          value: 'title',
                          child: Text('Titre'),
                        ),
                        DropdownMenuItem(
                          value: 'author',
                          child: Text('Auteur'),
                        ),
                        DropdownMenuItem(
                          value: 'publicationYear',
                          child: Text('Année'),
                        ),
                        DropdownMenuItem(
                          value: 'price',
                          child: Text('Prix'),
                        ),
                        DropdownMenuItem(
                          value: 'rating',
                          child: Text('Note'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          bookProvider.sortBooks(value);
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Bouton d'ordre de tri
                  IconButton(
                    icon: Icon(
                      bookProvider.sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    onPressed: () {
                      bookProvider.sortBooks(
                        bookProvider.sortBy,
                        ascending: !bookProvider.sortAscending,
                      );
                    },
                    tooltip: bookProvider.sortAscending
                        ? 'Tri croissant'
                        : 'Tri décroissant',
                  ),
                ],
              ),
              
              // Informations sur les résultats
              if (bookProvider.books.isNotEmpty || bookProvider.searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bookProvider.books.length} livre(s) trouvé(s)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (bookProvider.searchQuery.isNotEmpty ||
                          bookProvider.selectedGenre != 'Tous')
                        TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            bookProvider.resetFilters();
                          },
                          icon: const Icon(Icons.clear_all, size: 16),
                          label: const Text(
                            'Effacer',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
