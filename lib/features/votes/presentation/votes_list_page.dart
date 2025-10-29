import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/profile_page.dart';
import '../data/votes_repository.dart';
import 'vote_detail_page.dart';
import 'poll_results_page.dart';

final votesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return VotesRepository().getVotes();
});

class VotesListPage extends ConsumerWidget {
  const VotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votes = ref.watch(votesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votaciones Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Ver Resultados de Encuestas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PollResultsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      body: votes.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay votaciones disponibles en este momento.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(votesProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refrescar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final item = list[i];
              final String title = item['name'] ?? 'Sin título';
              final bool isActive = item['active'] ?? false;
              final String subtitle = isActive
                  ? 'Votación Activa'
                  : 'Votación Cerrada';

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                leading: Icon(isActive ? Icons.how_to_vote : Icons.lock_clock),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VoteDetailPage(vote: item)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar votaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(votesProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
