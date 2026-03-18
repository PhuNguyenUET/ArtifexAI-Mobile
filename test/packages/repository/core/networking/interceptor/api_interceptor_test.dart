// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:typed_data';

import 'package:artifex_ai_mobile/packages/repository/core/helper/config.dart';
import 'package:artifex_ai_mobile/packages/repository/core/networking/interceptor/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ─── Minimal HTTP adapter that always returns 200 ─────────────────────────────

class CapturingAdapter implements HttpClientAdapter {
  /// Every [RequestOptions] passed to [fetch] is recorded here.
  final List<RequestOptions> captured = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured.add(options);
    return ResponseBody.fromString(
      jsonEncode({'code': 200, 'message': 'OK', 'results': null}),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Builds a [Dio] with [ApiInterceptor] and a [CapturingAdapter].
({Dio dio, CapturingAdapter adapter}) _buildFixture() {
  final adapter = CapturingAdapter();
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:7070/'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ApiInterceptor());
  return (dio: dio, adapter: adapter);
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  tearDown(() {
    Config.accessToken = '';
  });

  // ── Shared headers ──────────────────────────────────────────────────────────
  group('headers added to every request', () {
    test('X-auth-token header is always present', () async {
      final f = _buildFixture();
      await f.dio.get<dynamic>('/api/user/v1/authenticate');

      final headers = f.adapter.captured.first.headers;
      expect(headers['X-auth-token'], equals('ArtifexAI-API-Token'));
    });

    test('Accept-Language header matches Intl.getCurrentLocale()', () async {
      final f = _buildFixture();
      await f.dio.get<dynamic>('/api/user/v1/authenticate');

      final headers = f.adapter.captured.first.headers;
      expect(headers['Accept-Language'], equals(Intl.getCurrentLocale()));
    });
  });

  // ── Protected paths ─────────────────────────────────────────────────────────
  group('Authorization header on protected paths', () {
    test('present when Config.accessToken is non-empty', () async {
      Config.accessToken = 'my-valid-jwt';
      final f = _buildFixture();

      await f.dio.get<dynamic>('/api/protected/resource');

      final headers = f.adapter.captured.first.headers;
      expect(headers['Authorization'], equals('Bearer my-valid-jwt'));
    });

    test('absent when Config.accessToken is empty', () async {
      Config.accessToken = '';
      final f = _buildFixture();

      await f.dio.get<dynamic>('/api/protected/resource');

      final headers = f.adapter.captured.first.headers;
      expect(headers.containsKey('Authorization'), isFalse);
    });
  });

  // ── Public paths ─────────────────────────────────────────────────────────────
  group('Authorization header is omitted for public paths', () {
    final publicPaths = [
      '/api/user/v1/authenticate',
      '/api/user/v1/refresh_jwt',
      '/api/user/v1/forgot_password',
      '/api/user/v1/create_new_password',
      '/api/user/v1/register',
      '/oauth2/callback',
      '/api/user/v1/authenticate_oauth2',
      '/swagger-ui/index.html',
      '/v3/api-docs',
      '/health',
    ];

    for (final path in publicPaths) {
      test('no Authorization on $path even when token is set', () async {
        Config.accessToken = 'should-not-be-sent';
        final f = _buildFixture();

        await f.dio.get<dynamic>(path);

        final headers = f.adapter.captured.first.headers;
        expect(
          headers.containsKey('Authorization'),
          isFalse,
          reason: 'Authorization must not be sent to public path $path',
        );
      });
    }
  });

  // ── Multiple requests ───────────────────────────────────────────────────────
  group('header injection across multiple sequential requests', () {
    test('each request gets its own headers independently', () async {
      Config.accessToken = 'token-A';
      final f = _buildFixture();

      await f.dio.get<dynamic>('/api/res1');

      // Simulate token rotation.
      Config.accessToken = 'token-B';
      await f.dio.get<dynamic>('/api/res2');

      expect(f.adapter.captured[0].headers['Authorization'],
          equals('Bearer token-A'));
      expect(f.adapter.captured[1].headers['Authorization'],
          equals('Bearer token-B'));
    });
  });
}

