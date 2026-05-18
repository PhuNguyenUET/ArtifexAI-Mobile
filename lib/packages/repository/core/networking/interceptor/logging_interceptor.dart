import 'dart:convert';

import '../../../../index.dart';

enum Level {
  none,

  basic,

  headers,

  body,
}

class LoggingInterceptor extends Interceptor {
  final Level level;

  void Function(Object object) logPrint;

  final bool compact;

  final JsonDecoder decoder = const JsonDecoder();
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  LoggingInterceptor({
    this.level = Level.none,
    this.compact = true,
    this.logPrint = print,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (level == Level.none) return handler.next(options);

    logPrint('[DIO]--> ${options.method} ${options.uri}');

    if (level == Level.basic) return handler.next(options);

    if (level == Level.headers) {
      logPrint('[DIO]--> END ${options.method}');
      return handler.next(options);
    }

    final data = options.data;

    if (data != null) {
      if (data is Map) {
        if (compact) {
          logPrint('[DIO][Request]${jsonEncode(data)}');
        } else {
          _prettyPrintJson(data);
        }
      } else if (data is FormData) {
        logPrint('[DIO][Request]${jsonEncode(data)}');
      } else {
        logPrint('[DIO][Request]${jsonEncode(data)}');
      }
    }

    logPrint('[DIO]--> END ${options.method}');

    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (level == Level.none) return handler.next(response);

    logPrint(
        '[DIO Response status]<-- ${response.statusCode} ${(response.statusMessage?.isNotEmpty ?? false) ? response.statusMessage : ''}');

    if (level == Level.basic) return handler.next(response);

    if (level == Level.headers) {
      logPrint('[DIO]--> END HTTP');
      return handler.next(response);
    }

    final data = response.data;
    if (data != null) {
      if (data is Map) {
        if (compact) {
          try {
            logPrint('[DIO][Request]${jsonEncode(data)}');
          } on Exception catch (_) {
            logPrint('[DIO][Request]${data.toString()}');
          }
        } else {
          logPrint('[DIO][Response]');
          try {
            _prettyPrintJson(data);
          } catch (e) {
            log(e.toString());
          }
        }
      } else if (data is List) {
      } else if (data is FormData) {
      } else {
        logPrint('[DIO][Response]${data.toString()}');
      }
    }

    logPrint('[DIO]<-- END HTTP');
    return handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (level == Level.none) return handler.next(err);

    try {
      logPrint('[DIO]<-- HTTP FAILED: ${jsonEncode(err.response?.data)}');
    } catch (_) {
      logPrint('[DIO]<-- HTTP FAILED: ${err.response?.data.toString()}');
    }

    return handler.next(err);
  }

  void _prettyPrintJson(Object input) {
    var prettyString = encoder.convert(input);
    prettyString.split('\n').forEach((element) => logPrint(element));
  }
}
