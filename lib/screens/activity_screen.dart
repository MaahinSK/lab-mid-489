import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landmark_provider.dart';
import '../widgets/visit_history_card.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit History'),
      ),
      body: Consumer<LandmarkProvider>(
        builder: (context, provider, child) {
          if (provider.visits.isEmpty) {
            return const Center(
              child: Text('No visits yet'),
            );
          }

          return ListView.builder(
            itemCount: provider.visits.length,
            itemBuilder: (context, index) {
              final visit = provider.visits[index];
              return VisitHistoryCard(visit: visit);
            },
          );
        },
      ),
    );
  }
}