import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/book_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic>? _statistics;
  Map<String, int>? _genreStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bookProvider = context.read<BookProvider>();
      final stats = await bookProvider.getStatistics();
      final books = bookProvider.allBooks;
      
      // Calculer les statistiques par genre
      final genreStats = <String, int>{};
      for (final book in books) {
        genreStats[book.genre] = (genreStats[book.genre] ?? 0) + 1;
      }

      setState(() {
        _statistics = stats;
        _genreStats = genreStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des statistiques: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _statistics == null
              ? const Center(
                  child: Text('Erreur lors du chargement des statistiques'),
                )
              : RefreshIndicator(
                  onRefresh: _loadStatistics,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistiques générales
                        _buildGeneralStats(),
                        
                        const SizedBox(height: 24),
                        
                        // Statistiques par genre
                        _buildGenreStats(),
                        
                        const SizedBox(height: 24),
                        
                        // Graphiques et visualisations
                        _buildProgressSection(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildGeneralStats() {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vue d\'ensemble',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatCard(
              'Total des livres',
              _statistics!['totalBooks'].toString(),
              Icons.library_books,
              Colors.blue,
            ),
            _buildStatCard(
              'Livres lus',
              _statistics!['readBooks'].toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              'À lire',
              _statistics!['unreadBooks'].toString(),
              Icons.schedule,
              Colors.orange,
            ),
            _buildStatCard(
              'Valeur totale',
              currencyFormat.format(_statistics!['totalValue']),
              Icons.euro,
              Colors.purple,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Note moyenne
        if (_statistics!['averageRating'] > 0)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Note moyenne',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_statistics!['averageRating'].toStringAsFixed(1)}/5',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Barre de progression pour la note
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: _statistics!['averageRating'] / 5,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreStats() {
    if (_genreStats == null || _genreStats!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Trier les genres par nombre de livres
    final sortedGenres = _genreStats!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Répartition par genre',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: sortedGenres.map((entry) {
                final percentage = (entry.value / _statistics!['totalBooks'] * 100);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${entry.value} livre${entry.value > 1 ? 's' : ''} (${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: entry.value / _statistics!['totalBooks'],
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getGenreColor(sortedGenres.indexOf(entry)),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final readPercentage = _statistics!['totalBooks'] > 0
        ? (_statistics!['readBooks'] / _statistics!['totalBooks'] * 100)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progression de lecture',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Livres lus',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_statistics!['readBooks']}/${_statistics!['totalBooks']} (${readPercentage.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _statistics!['totalBooks'] > 0 
                      ? _statistics!['readBooks'] / _statistics!['totalBooks'] 
                      : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                ),
                const SizedBox(height: 16),
                
                // Objectif de lecture (exemple)
                if (_statistics!['totalBooks'] > 0) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Objectif: Lire tous les livres',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '${_statistics!['unreadBooks']} restant${_statistics!['unreadBooks'] > 1 ? 's' : ''}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getGenreColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
