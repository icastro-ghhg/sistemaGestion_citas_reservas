import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/votes_repository.dart';

final voteResultsProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, pollToken) async {
    return VotesRepository().getVoteResults(pollToken);
  },
);

class ResultsDetailPage extends ConsumerWidget {
  final String pollToken;
  final String pollName;

  const ResultsDetailPage({
    super.key,
    required this.pollToken,
    required this.pollName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(voteResultsProvider(pollToken));

    return Scaffold(
      appBar: AppBar(title: Text('Resultados: $pollName')),
      body: results.when(
        data: (details) {
          final List<dynamic> resultsList = details['results'] ?? [];

          int totalVotes = 0;
          for (var option in resultsList) {
            totalVotes += (option['total'] as int? ?? 0);
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Total de Votos: $totalVotes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(height: 32),

              if (resultsList.isEmpty)
                const Text('Aún no hay resultados para esta encuesta.'),

              ...resultsList.map((option) {
                final String choice = option['choice'] ?? 'Opción';
                final int count = option['total'] as int? ?? 0;
                final double percentage = (totalVotes > 0)
                    ? (count / totalVotes)
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '$count Votos (${(percentage * 100).toStringAsFixed(1)}%)',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentage,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error al cargar resultados: $e'),
              ElevatedButton(
                onPressed: () => ref.invalidate(voteResultsProvider(pollToken)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
