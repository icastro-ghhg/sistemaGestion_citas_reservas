

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vote_app/core/error_handler.dart';

void main() {
  group('ErrorHandler - mapDioError', () {
    test('debe retornar  "Ocurrio un error" cuando falla por badCertificate', () {
      RequestOptions requestOptions = RequestOptions();
      DioException dioException = DioException.badCertificate(requestOptions: requestOptions);

      String mensajeActual = ErrorHandler.mapDioError(dioException);

      expect(mensajeActual, equals("Ocurrió un error: The certificate of the response is not approved."));
    });

    test('debe retornar "Error del Servidor" cuando falla por badResponse con status 401', () {
    RequestOptions requestOptions = RequestOptions();
    Map<String, dynamic> jsonData =
      {
        "type": "https://developer.mozilla.org/es/docs/Web/HTTP/Reference/Status/401",
        "title": "Unauthorized",
        "status": 401,
        "detail": "Error al decodificar y validar idToken de Google",
        "instance": "/vote/v1/polls/",
        "timestamp": "2025-10-21T02:24:50.868113979Z",
        "errorCode": "SA",
        "method": "GET"
      };
    Response errorResponse = Response<Map<String, dynamic>>(requestOptions: requestOptions, data: jsonData, statusCode: 401);
    DioException dioException = DioException.badResponse(statusCode: 401, requestOptions: requestOptions, response: errorResponse);

    String mensajeActual = ErrorHandler.mapDioError(dioException);

    String errorEsperado = "{type: https://developer.mozilla.org/es/docs/Web/HTTP/Reference/Status/401, title: Unauthorized, status: 401, detail: Error al decodificar y validar idToken de Google, instance: /vote/v1/polls/, timestamp: 2025-10-21T02:24:50.868113979Z, errorCode: SA, method: GET}";
    expect(mensajeActual, equals(errorEsperado));
    });

    test('debe retornar  "Error del Servidor" cuando falla por badResponse con status 500', () {
      RequestOptions requestOptions = RequestOptions();
      Map<String, dynamic> jsonData  = {
        "type": "https://developer.mozilla.org/es/docs/Web/HTTP/Reference/Status/500",
        "title": "Internal Server Error",
        "status": 500,
        "detail": "Required request header 'Authorization' for method parameter type String is not present",
        "instance": "/vote/v1/polls/",
        "timestamp": "2025-10-21T02:12:08.595710898Z",
        "errorCode": "DC",
        "method": "GET"
      };

      Response errorResponse = Response<Map<String, dynamic>>(requestOptions: requestOptions, data: jsonData, statusCode: 500);
      DioException dioException = DioException.badResponse(statusCode: 500, requestOptions: requestOptions, response: errorResponse);

      String mensajeActual = ErrorHandler.mapDioError(dioException);

      String errorEsperado = "Error del servidor (código 500). Intenta más tarde.";
      expect(mensajeActual, equals(errorEsperado));
    });

    test('debe retornar error cuando es unknow', () {
      RequestOptions requestOptions = RequestOptions();
      DioException dioException = DioException(requestOptions: requestOptions);

      String mensajeErrorActual = ErrorHandler.mapDioError(dioException);

      String errorEsperado = "Error de red. Comprueba tu conexión.";
      expect(mensajeErrorActual, equals(errorEsperado));
    });

    test('debe retornar error cuando es timeout', () {
      RequestOptions requestOptions = RequestOptions();
      DioException dioException = DioException.receiveTimeout(timeout: Duration.zero, requestOptions: requestOptions);

      String mensajeActual = ErrorHandler.mapDioError(dioException);

      String errorEsperado = "Tiempo de espera agotado. Revisa tu conexión e intenta nuevamente.";
      expect(mensajeActual, equals(errorEsperado));
    });

  });
}
