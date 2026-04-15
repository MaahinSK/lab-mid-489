import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landmark_provider.dart';
import '../widgets/landmark_card.dart';

class LandmarksScreen extends StatelessWidget {
  const LandmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landmarks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<LandmarkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.landmarks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.landmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchLandmarks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.landmarks.isEmpty) {
            return const Center(child: Text('No landmarks found'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Min Score: ${provider.minScore.toStringAsFixed(0)}',
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        provider.sortByScoreAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      onPressed: () => provider.toggleSortOrder(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.landmarks.length,
                  itemBuilder: (context, index) {
                    final landmark = provider.landmarks[index];
                    return LandmarkCard(
                      landmark: landmark,
                      onVisit: () => provider.visitLandmark(landmark.id),
                    );
                  },
                ),
              ),
              if (!provider.isOnline)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange,
                  child: const Text(
                    'Offline Mode - Showing cached data',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final provider = context.read<LandmarkProvider>();
    double minScore = provider.minScore;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter by Score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Minimum Score: ${minScore.toStringAsFixed(0)}'),
              Slider(
                value: minScore,
                min: 0,
                max: 100,
                divisions: 20,
                label: minScore.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    minScore = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.setMinScore(minScore);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}