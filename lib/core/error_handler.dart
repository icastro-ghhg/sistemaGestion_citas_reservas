import 'package:dio/dio.dart';

class ErrorHandler {
  static String mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Tiempo de espera agotado. Revisa tu conexión e intenta nuevamente.';
    }

    if (e.type == DioExceptionType.badResponse && e.response != null) {
      final status = e.response!.statusCode ?? 0;
      final data = e.response!.data;

      if (status >= 400 && status < 500) {
        final message =
            _extractMessage(data) ?? 'Error en la solicitud (código $status).';
        return message;
      } else if (status >= 500) {
        return 'Error del servidor (código $status). Intenta más tarde.';
      }
    }

    if (e.type == DioExceptionType.unknown) {
      return 'Error de red. Comprueba tu conexión.';
    }

    return 'Ocurrió un error: ${e.message}';
  }

  static String? _extractMessage(dynamic data) {
    try {
      if (data == null) return null;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) return data['message']?.toString();
        if (data.containsKey('error')) return data['error']?.toString();
      }
      return data.toString();
    } catch (_) {
      return null;
    }
  }
}
