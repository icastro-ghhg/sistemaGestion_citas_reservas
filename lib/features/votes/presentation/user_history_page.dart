import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/votes_repository.dart';

final userHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      return VotesRepository().getUserHistory();
    });

class UserHistoryPage extends ConsumerWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = ref.watch(userHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de votaciones')),
      body: hist.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text('No hay votaciones en tu historial.'),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final item = list[i];
              return ListTile(
                title: Text(item['title'] ?? 'Sin título'),
                subtitle: Text(
                  item['votedOption']?.toString() ??
                      item['option']?.toString() ??
                      '',
                ),
                trailing: Text(item['date'] ?? ''),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error al cargar historial: ${e.toString()}')),
      ),
    );
  }
}
