import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/votes_repository.dart';
import '../data/vote_history_service.dart';

final voteDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  voteToken,
) async {
  return VotesRepository().getVoteDetail(voteToken);
});
final selectedOptionProvider = StateProvider<int?>((ref) => null);

class VoteDetailPage extends ConsumerWidget {
  final Map<String, dynamic> vote;
  const VoteDetailPage({super.key, required this.vote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String voteToken = vote['token'] as String;
    final voteDetails = ref.watch(voteDetailProvider(voteToken));
    final int? selectedOptionId = ref.watch(selectedOptionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(vote['name'] ?? 'Detalle')),
      body: voteDetails.when(
        data: (details) {
          final String description =
              details['description'] ?? 'No hay descripción.';
          final List<dynamic> options = details['options'] ?? [];
          final bool isActive = details['active'] ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  details['name'] ?? 'Sin Título',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(isActive ? 'Activa' : 'Cerrada'),
                  backgroundColor: isActive
                      ? Colors.green.shade100
                      : Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(height: 32),
                Text(
                  'Opciones:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                for (var option in options)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(option['choice'] ?? '...'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),

                      onTap: isActive
                          ? () {
                              ref.read(selectedOptionProvider.notifier).state =
                                  option['selection'] as int;
                            }
                          : null,

                      trailing: Radio<int>(
                        value: option['selection'] as int,
                        groupValue: selectedOptionId,
                        onChanged: isActive
                            ? (value) {
                                ref
                                        .read(selectedOptionProvider.notifier)
                                        .state =
                                    value;
                              }
                            : null,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: (isActive && selectedOptionId != null)
                      ? () {
                          _onVotePressed(
                            context,
                            ref,
                            voteToken,
                            selectedOptionId,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    isActive ? 'Registrar mi Voto' : 'Votación Cerrada',
                  ),
                ),
              ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error al cargar detalle: $e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(voteDetailProvider(voteToken));
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onVotePressed(
    BuildContext context,
    WidgetRef ref,
    String pollToken,
    int selectionId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await VotesRepository().voteOnOption(
        pollToken: pollToken,
        selectionId: selectionId,
      );
      await VoteHistoryService.addVotedPoll(pollToken);
      Navigator.of(context).pop();
      ref.read(selectedOptionProvider.notifier).state = null;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Voto Registrado'),
          content: const Text('Tu voto ha sido registrado exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error al Votar'),
          content: Text('$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }
}
