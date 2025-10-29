import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'poll_results_provider.dart';
import 'results_detail_page.dart';

class PollResultsPage extends ConsumerStatefulWidget {
  const PollResultsPage({super.key});

  @override
  ConsumerState<PollResultsPage> createState() => _PollResultsPageState();
}

class _PollResultsPageState extends ConsumerState<PollResultsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(pollResultsProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsState = ref.watch(pollResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar resultados...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                ref.read(pollResultsProvider.notifier).search('');
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          onSubmitted: (value) {
            ref.read(pollResultsProvider.notifier).search(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FocusScope.of(context).unfocus();
              ref
                  .read(pollResultsProvider.notifier)
                  .search(_searchController.text);
            },
          ),
        ],
      ),
      body: resultsState.when(
        data: (state) {
          if (state.polls.isEmpty) {
            return Center(child: Text('No se encontraron resultados.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.polls.length
                : state.polls.length + 1,
            itemBuilder: (context, i) {
              if (i >= state.polls.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = state.polls[i];
              final String title = item['name'] ?? 'Resultados de encuesta';
              final bool isActive = item['active'] ?? false;

              return ListTile(
                title: Text(title),
                subtitle: Text(
                  isActive ? 'Votación en curso' : 'Votación cerrada',
                ),
                leading: const Icon(Icons.poll_outlined),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultsDetailPage(
                        pollToken: item['token'] as String,
                        pollName: title,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
