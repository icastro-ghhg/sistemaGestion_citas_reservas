import '../../../core/api_client.dart';
import 'package:dio/dio.dart'; // Importa Dio
import '../../../core/error_handler.dart';

class VotesRepository {
  final ApiClient _api = ApiClient();

  Future<List<Map<String, dynamic>>> getVotes({
    int page = 1,
    int pageSize = 20,
    String? q,
    Map<String, String>? filters,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
      if (q != null && q.isNotEmpty) params['q'] = q;
      if (filters != null) params.addAll(filters);

      final response = await _api.client.get(
        '/v1/polls/',
        queryParameters: params,
      );

      final List<dynamic> results = response.data as List<dynamic>;
      return results.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      final msg = ErrorHandler.mapDioError(e);
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> getVoteDetail(String voteId) async {
    try {
      final response = await _api.client.get('/v1/polls/$voteId');
      return (response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = ErrorHandler.mapDioError(e);
      throw Exception(msg);
    }
  }

  Future<void> voteOnOption({
    required String pollToken,
    required int selectionId,
  }) async {
    try {
      final response = await _api.client.post(
        '/v1/vote/election',
        data: {'pollToken': pollToken, 'selection': selectionId},
      );

      if (response.statusCode == null || (response.statusCode! >= 400)) {
        throw Exception(
          'Error al registrar el voto (código ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw Exception('Ya has votado en esta encuesta.');
      }
      final msg = ErrorHandler.mapDioError(e);
      throw Exception(msg);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error inesperado: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserHistory() async {
    try {
      try {
        final r = await _api.client.get('/v1/me/votes');
        final List<dynamic> results = r.data as List<dynamic>;
        return results.cast<Map<String, dynamic>>();
      } catch (_) {
        final r2 = await _api.client.get('/v1/users/me/votes');
        final List<dynamic> results = r2.data as List<dynamic>;
        return results.cast<Map<String, dynamic>>();
      }
    } on DioException catch (e) {
      final msg = ErrorHandler.mapDioError(e);
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> getVoteResults(String pollToken) async {
    try {
      final response = await _api.client.get('/v1/vote/$pollToken/results');
      return (response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = ErrorHandler.mapDioError(e);
      throw Exception(msg);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
