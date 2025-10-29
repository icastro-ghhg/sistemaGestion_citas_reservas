import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/votes_repository.dart';

class VotesListState {
  final List<Map<String, dynamic>> votes;
  final int page;
  final bool hasReachedMax;
  final String query;

  VotesListState({
    this.votes = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.query = '',
  });

  VotesListState copyWith({
    List<Map<String, dynamic>>? votes,
    int? page,
    bool? hasReachedMax,
    String? query,
  }) {
    return VotesListState(
      votes: votes ?? this.votes,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }
}

class VotesNotifier extends AsyncNotifier<VotesListState> {
  static const _pageSize = 20;
  final _repository = VotesRepository();

  @override
  Future<VotesListState> build() async {
    final votes = await _repository.getVotes(
      page: 1,
      pageSize: _pageSize,
      q: '',
    );
    return VotesListState(
      votes: votes,
      page: 1,

      hasReachedMax: votes.length < _pageSize,
      query: '',
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;
    if (state.isLoading || currentState == null || currentState.hasReachedMax) {
      return;
    }

    state = AsyncValue.data(currentState);

    try {
      final newVotes = await _repository.getVotes(
        page: currentState.page + 1,
        pageSize: _pageSize,
        q: currentState.query,
      );

      final hasReachedMax = newVotes.length < _pageSize;

      state = AsyncValue.data(
        currentState.copyWith(
          votes: [...currentState.votes, ...newVotes],
          page: currentState.page + 1,
          hasReachedMax: hasReachedMax,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> search(String newQuery) async {
    state = const AsyncValue.loading();

    try {
      final newVotes = await _repository.getVotes(
        page: 1,
        pageSize: _pageSize,
        q: newQuery,
      );

      final hasReachedMax = newVotes.length < _pageSize;

      state = AsyncValue.data(
        VotesListState(
          votes: newVotes,
          page: 1,
          hasReachedMax: hasReachedMax,
          query: newQuery,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final votesProvider = AsyncNotifierProvider<VotesNotifier, VotesListState>(() {
  return VotesNotifier();
});
