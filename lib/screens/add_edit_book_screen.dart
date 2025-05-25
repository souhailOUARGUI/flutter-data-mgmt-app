import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _genreController = TextEditingController();
  final _publicationYearController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  final _languageController = TextEditingController();
  final _publisherController = TextEditingController();

  bool _isRead = false;
  double? _rating;
  bool _isLoading = false;

  final List<String> _commonGenres = [
    'Fiction',
    'Science-Fiction',
    'Fantasy',
    'Romance',
    'Thriller',
    'Mystère',
    'Biographie',
    'Histoire',
    'Philosophie',
    'Science',
    'Art',
    'Cuisine',
    'Voyage',
    'Développement personnel',
    'Autre',
  ];

  final List<String> _commonLanguages = [
    'Français',
    'Anglais',
    'Espagnol',
    'Italien',
    'Allemand',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final book = widget.book!;
    _titleController.text = book.title;
    _authorController.text = book.author;
    _isbnController.text = book.isbn;
    _genreController.text = book.genre;
    _publicationYearController.text = book.publicationYear.toString();
    _priceController.text = book.price.toString();
    _descriptionController.text = book.description;
    _pagesController.text = book.pages.toString();
    _languageController.text = book.language;
    _publisherController.text = book.publisher;
    _isRead = book.isRead;
    _rating = book.rating;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _genreController.dispose();
    _publicationYearController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _publisherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le livre' : 'Ajouter un livre'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveBook,
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Informations de base
            _buildSectionTitle('Informations de base'),
            _buildTextField(
              controller: _titleController,
              label: 'Titre',
              icon: Icons.book,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le titre est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _authorController,
              label: 'Auteur',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'L\'auteur est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _isbnController,
              label: 'ISBN',
              icon: Icons.qr_code,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'L\'ISBN est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Catégorisation
            _buildSectionTitle('Catégorisation'),
            _buildDropdownField(
              controller: _genreController,
              label: 'Genre',
              icon: Icons.category,
              items: _commonGenres,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le genre est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildDropdownField(
              controller: _languageController,
              label: 'Langue',
              icon: Icons.language,
              items: _commonLanguages,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La langue est requise';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Détails de publication
            _buildSectionTitle('Détails de publication'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _publicationYearController,
                    label: 'Année de publication',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'année est requise';
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < 1000 || year > DateTime.now().year) {
                        return 'Année invalide';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _buildTextField(
                    controller: _pagesController,
                    label: 'Nombre de pages',
                    icon: Icons.pages,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nombre de pages est requis';
                      }
                      final pages = int.tryParse(value);
                      if (pages == null || pages <= 0) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _publisherController,
              label: 'Éditeur',
              icon: Icons.business,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'L\'éditeur est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _priceController,
              label: 'Prix (€)',
              icon: Icons.euro,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le prix est requis';
                }
                final price = double.tryParse(value);
                if (price == null || price < 0) {
                  return 'Prix invalide';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Description
            _buildSectionTitle('Description'),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            // Statut de lecture
            _buildSectionTitle('Statut de lecture'),
            SwitchListTile(
              title: const Text('Livre lu'),
              subtitle: Text(_isRead ? 'Ce livre a été lu' : 'Ce livre n\'a pas encore été lu'),
              value: _isRead,
              onChanged: (value) {
                setState(() {
                  _isRead = value;
                  if (!value) {
                    _rating = null;
                  }
                });
              },
            ),

            if (_isRead) ...[
              const SizedBox(height: 16),
              _buildRatingSelector(),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty && items.contains(controller.text)
          ? controller.text
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.text = value;
        }
      },
      validator: validator,
    );
  }

  Widget _buildRatingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note (optionnelle)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = starValue;
                });
              },
              child: Icon(
                Icons.star,
                size: 32,
                color: _rating != null && _rating! >= starValue
                    ? Colors.amber
                    : Colors.grey[300],
              ),
            );
          }),
        ),
        if (_rating != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Text('Note: ${_rating!.toStringAsFixed(1)}/5'),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _rating = null;
                    });
                  },
                  child: const Text('Supprimer la note'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final book = Book(
        id: widget.book?.id,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        isbn: _isbnController.text.trim(),
        genre: _genreController.text.trim(),
        publicationYear: int.parse(_publicationYearController.text),
        price: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        pages: int.parse(_pagesController.text),
        language: _languageController.text.trim(),
        publisher: _publisherController.text.trim(),
        dateAdded: widget.book?.dateAdded ?? DateTime.now(),
        isRead: _isRead,
        rating: _rating,
      );

      final bookProvider = context.read<BookProvider>();
      bool success;

      if (widget.book == null) {
        success = await bookProvider.addBook(book);
      } else {
        success = await bookProvider.updateBook(book);
      }

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.book == null
                    ? 'Livre ajouté avec succès'
                    : 'Livre modifié avec succès',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.book == null
                    ? 'Erreur lors de l\'ajout du livre'
                    : 'Erreur lors de la modification du livre',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
