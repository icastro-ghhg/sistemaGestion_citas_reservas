import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/votes_repository.dart';

class ResultsListState {
  final List<Map<String, dynamic>> polls;
  final int page;
  final bool hasReachedMax;
  final String query;

  ResultsListState({
    this.polls = const [],
    this.page = 1,
    this.hasReachedMax = false,
    this.query = '',
  });

  ResultsListState copyWith({
    List<Map<String, dynamic>>? polls,
    int? page,
    bool? hasReachedMax,
    String? query,
  }) {
    return ResultsListState(
      polls: polls ?? this.polls,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }
}

class ResultsNotifier extends AsyncNotifier<ResultsListState> {
  static const _pageSize = 20;
  final _repository = VotesRepository();

  @override
  Future<ResultsListState> build() async {
    final polls = await _repository.getVotes(
      page: 1,
      pageSize: _pageSize,
      q: '',
    );
    return ResultsListState(
      polls: polls,
      page: 1,
      hasReachedMax: polls.length < _pageSize,
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
      final newPolls = await _repository.getVotes(
        page: currentState.page + 1,
        pageSize: _pageSize,
        q: currentState.query,
      );
      state = AsyncValue.data(
        currentState.copyWith(
          polls: [...currentState.polls, ...newPolls],
          page: currentState.page + 1,
          hasReachedMax: newPolls.length < _pageSize,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> search(String newQuery) async {
    state = const AsyncValue.loading();
    try {
      final newPolls = await _repository.getVotes(
        page: 1,
        pageSize: _pageSize,
        q: newQuery,
      );
      state = AsyncValue.data(
        ResultsListState(
          polls: newPolls,
          page: 1,
          hasReachedMax: newPolls.length < _pageSize,
          query: newQuery,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final pollResultsProvider =
    AsyncNotifierProvider<ResultsNotifier, ResultsListState>(() {
      return ResultsNotifier();
    });
