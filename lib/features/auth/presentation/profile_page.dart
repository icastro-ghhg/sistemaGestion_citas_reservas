import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../votes/data/votes_repository.dart';
import '../../votes/data/vote_history_service.dart';

final userHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final allPolls = await VotesRepository().getVotes();

  final votedPollTokens = await VoteHistoryService.getVotedPolls();

  if (votedPollTokens.isEmpty) {
    return [];
  }

  final historyList = allPolls.where((poll) {
    return votedPollTokens.contains(poll['token']);
  }).toList();

  return historyList;
});

final firebaseUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leemos los providers
    final User? user = ref.watch(firebaseUserProvider);
    final AsyncValue<List<Map<String, dynamic>>> history = ref.watch(
      userHistoryProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Datos de Usuario',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'No disponible'),
            ),
          ),

          const Divider(height: 32),
          Text(
            'Mi Historial de Votaciones',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          history.when(
            data: (voteList) {
              if (voteList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('Aún no has participado en ninguna votación.'),
                  ),
                );
              }
              return Column(
                children: voteList.map((vote) {
                  final String voteName =
                      vote['name'] ?? 'Votación desconocida';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(Icons.poll_outlined),
                      title: Text(voteName),
                    ),
                  );
                }).toList(),
              );
            },

            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Error al cargar tu historial: $e'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(userHistoryProvider);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 32),

          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ref.invalidate(userHistoryProvider);
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
