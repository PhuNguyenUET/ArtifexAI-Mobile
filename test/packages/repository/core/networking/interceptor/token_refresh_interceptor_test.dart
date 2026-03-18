// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:artifex_ai_mobile/packages/repository/core/helper/config.dart';
import 'package:artifex_ai_mobile/packages/repository/core/networking/interceptor/token_refresh_interceptor.dart';
import 'package:artifex_ai_mobile/packages/repository/core/networking/interceptor/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────

class MockTokenStorage extends Mock implements TokenStorage {}

// ─── Fake HTTP adapters ───────────────────────────────────────────────────────

/// Simple queue-based adapter: each call pops the next stubbed response.
class QueuedAdapter implements HttpClientAdapter {
  final List<_Stub> _queue = [];

  /// Captured [RequestOptions] in order of invocation.
  final List<RequestOptions> captured = [];

  void enqueue({required int status, Map<String, dynamic>? body}) =>
      _queue.add(_Stub(status: status, body: body));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured.add(options);
    if (_queue.isEmpty) {
      throw StateError('QueuedAdapter: no more stubs for ${options.uri}');
    }
    final stub = _queue.removeAt(0);
    return ResponseBody.fromString(
      stub.body != null ? jsonEncode(stub.body) : '',
      stub.status,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Adapter that blocks on the first call until [complete] is called, so that
/// concurrent-request tests can trigger multiple 401s before refresh finishes.
class BlockingRefreshAdapter implements HttpClientAdapter {
  final _completer = Completer<_Stub>();
  int callCount = 0;

  void complete({required int status, Map<String, dynamic>? body}) =>
      _completer.complete(_Stub(status: status, body: body));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final stub = await _completer.future;
    return ResponseBody.fromString(
      stub.body != null ? jsonEncode(stub.body) : '',
      stub.status,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _Stub {
  _Stub({required this.status, this.body});
  final int status;
  final Map<String, dynamic>? body;
}

// ─── Body helpers ─────────────────────────────────────────────────────────────

Map<String, dynamic> _jwtExpiredBody() => {
      'code': 401,
      'message': 'JWT expired',
      'results': null,
    };

Map<String, dynamic> _successBody({dynamic results = 'payload'}) => {
      'code': 200,
      'message': 'OK',
      'results': results,
    };

Map<String, dynamic> _refreshSuccessBody({required String token}) => {
      'code': 200,
      'message': 'OK',
      'results': token,
    };

// ─── Test setup helpers ───────────────────────────────────────────────────────

/// Builds a primary [Dio] + [QueuedAdapter] and a refresh [Dio] +
/// [QueuedAdapter], wires them to a [TokenRefreshInterceptor], and returns
/// everything in a convenient record.
({
  Dio primaryDio,
  QueuedAdapter primaryAdapter,
  Dio refreshDio,
  QueuedAdapter refreshAdapter,
  MockTokenStorage storage,
  TokenRefreshInterceptor interceptor,
  bool Function() sessionExpiredCalled,
}) _buildFixture() {
  final storage = MockTokenStorage();
  final primaryAdapter = QueuedAdapter();
  final refreshAdapter = QueuedAdapter();
  var sessionExpired = false;

  final primaryDio = Dio(BaseOptions(baseUrl: 'http://localhost:7070/'))
    ..httpClientAdapter = primaryAdapter;

  final refreshDio = Dio(BaseOptions(baseUrl: 'http://localhost:7070/'))
    ..httpClientAdapter = refreshAdapter;

  final interceptor = TokenRefreshInterceptor(
    primaryDio: primaryDio,
    storage: storage,
    onSessionExpired: () => sessionExpired = true,
    testRefreshDio: refreshDio,
  );

  primaryDio.interceptors.add(interceptor);

  return (
    primaryDio: primaryDio,
    primaryAdapter: primaryAdapter,
    refreshDio: refreshDio,
    refreshAdapter: refreshAdapter,
    storage: storage,
    interceptor: interceptor,
    sessionExpiredCalled: () => sessionExpired,
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  tearDown(() {
    // Reset global state between tests.
    Config.accessToken = '';
    Config.refreshToken = '';
  });

  // ── 1. Pass-through: non-401 ────────────────────────────────────────────────
  group('non-401 errors are passed through unchanged', () {
    test('500 server error is not intercepted', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 500, body: {'message': 'Server error'});

      expect(
        () => f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          500,
        )),
      );

      // Let the request fly (expect throws asynchronously)
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => f.storage.getRefreshToken());
      expect(f.sessionExpiredCalled(), isFalse);
    });
  });

  // ── 2. Pass-through: 401 without JWT expired message ───────────────────────
  group('401 without "JWT expired" is passed through', () {
    test('bad-credentials 401 is not intercepted', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(
        status: 401,
        body: {'code': 401, 'message': 'Bad credentials', 'results': null},
      );

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          401,
        )),
      );

      verifyNever(() => f.storage.getRefreshToken());
      expect(f.sessionExpiredCalled(), isFalse);
    });

    test('401 with null body is not intercepted', () async {
      final f = _buildFixture();

      // Return a 401 with no JSON body at all.
      f.primaryAdapter.enqueue(status: 401);

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      verifyNever(() => f.storage.getRefreshToken());
    });
  });

  // ── 3. Pass-through: public endpoints ──────────────────────────────────────
  group('public endpoints bypass the refresh flow', () {
    for (final publicPath in [
      '/api/user/v1/authenticate',
      '/api/user/v1/refresh_jwt',
      '/api/user/v1/forgot_password',
      '/api/user/v1/register',
    ]) {
      test('$publicPath is not intercepted on 401 JWT expired', () async {
        final f = _buildFixture();

        f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());

        await expectLater(
          f.primaryDio.get<dynamic>(publicPath),
          throwsA(isA<DioException>()),
        );

        verifyNever(() => f.storage.getRefreshToken());
        expect(f.sessionExpiredCalled(), isFalse);
      });
    }
  });

  // ── 4. Happy path: refresh succeeds ────────────────────────────────────────
  group('JWT expired 401 – successful refresh', () {
    test('retries the original request and resolves with retry response',
        () async {
      final f = _buildFixture();

      // First call → 401 JWT expired; second call (retry) → 200.
      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'my-payload'));

      // Refresh endpoint → returns new token.
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      final response = await f.primaryDio.get<dynamic>('/api/protected');

      expect(response.statusCode, equals(200));
    });

    test('saves new access token and original refresh token to storage',
        () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'data'));
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      await f.primaryDio.get<dynamic>('/api/protected');

      verify(() => f.storage.saveTokens(
            accessToken: 'new-jwt',
            refreshToken: 'old-refresh-token',
          )).called(1);
    });

    test('does NOT call onSessionExpired on success', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'data'));
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      await f.primaryDio.get<dynamic>('/api/protected');

      expect(f.sessionExpiredCalled(), isFalse);
    });

    test('injects new Bearer token into the retry Authorization header',
        () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'data'));
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      await f.primaryDio.get<dynamic>('/api/protected');

      // captured[0] = original 401 request, captured[1] = retry request.
      expect(f.primaryAdapter.captured.length, greaterThanOrEqualTo(2));
      final retryHeaders = f.primaryAdapter.captured[1].headers;
      expect(retryHeaders['Authorization'], equals('Bearer new-jwt'));
    });

    test('recognises "expired at" variant of JWT expired message', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(
        status: 401,
        body: {
          'code': 401,
          'message': 'Token expired at 2025-01-01T00:00:00',
          'results': null,
        },
      );
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'data'));
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      final response = await f.primaryDio.get<dynamic>('/api/protected');
      expect(response.statusCode, equals(200));
    });

    test('recognises "jwtExpired" variant of JWT expired message', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(
        status: 401,
        body: {
          'code': 401,
          'message': 'jwtExpired',
          'results': null,
        },
      );
      f.primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'data'));
      f.refreshAdapter
          .enqueue(status: 200, body: _refreshSuccessBody(token: 'new-jwt'));

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      final response = await f.primaryDio.get<dynamic>('/api/protected');
      expect(response.statusCode, equals(200));
    });
  });

  // ── 5. Failure: empty refresh token ────────────────────────────────────────
  group('empty stored refresh token → session expired', () {
    test('calls onSessionExpired', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());

      when(() => f.storage.getRefreshToken()).thenAnswer((_) async => '');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      expect(f.sessionExpiredCalled(), isTrue);
    });

    test('clears tokens from storage', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());

      when(() => f.storage.getRefreshToken()).thenAnswer((_) async => '');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      verify(() => f.storage.clearTokens()).called(1);
    });

    test('does NOT call saveTokens', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());

      when(() => f.storage.getRefreshToken()).thenAnswer((_) async => '');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      verifyNever(() => f.storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ));
    });
  });

  // ── 6. Failure: refresh endpoint returns empty token ───────────────────────
  group('refresh endpoint returns empty/null token → session expired', () {
    test('empty string in results fires session expired', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      // Refresh returns empty string for `results`.
      f.refreshAdapter.enqueue(
        status: 200,
        body: {'code': 200, 'message': 'OK', 'results': ''},
      );

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      expect(f.sessionExpiredCalled(), isTrue);
      verify(() => f.storage.clearTokens()).called(1);
    });

    test('null results fires session expired', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      f.refreshAdapter.enqueue(
        status: 200,
        body: {'code': 200, 'message': 'OK', 'results': null},
      );

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      expect(f.sessionExpiredCalled(), isTrue);
    });
  });

  // ── 7. Failure: refresh endpoint throws ────────────────────────────────────
  group('refresh endpoint throws → session expired', () {
    test('refresh endpoint 500 → fires session expired and clears tokens',
        () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      // Refresh endpoint itself returns a server error.
      f.refreshAdapter
          .enqueue(status: 500, body: {'message': 'Internal Server Error'});

      when(() => f.storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh-token');
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      expect(f.sessionExpiredCalled(), isTrue);
      verify(() => f.storage.clearTokens()).called(1);
    });

    test('storage.getRefreshToken() throws → fires session expired', () async {
      final f = _buildFixture();

      f.primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());

      when(() => f.storage.getRefreshToken())
          .thenThrow(Exception('Secure storage unavailable'));
      when(() => f.storage.clearTokens()).thenAnswer((_) async {});

      await expectLater(
        f.primaryDio.get<dynamic>('/api/protected'),
        throwsA(isA<DioException>()),
      );

      expect(f.sessionExpiredCalled(), isTrue);
    });
  });

  // ── 8. Concurrent 401s: only one refresh call ──────────────────────────────
  group('concurrent JWT expired 401s', () {
    test('only one refresh call is made when two requests 401 simultaneously',
        () async {
      final storage = MockTokenStorage();
      final primaryAdapter = QueuedAdapter();
      final blockingRefreshAdapter = BlockingRefreshAdapter();
      var sessionExpired = false;

      final primaryDio = Dio(BaseOptions(baseUrl: 'http://localhost:7070/'))
        ..httpClientAdapter = primaryAdapter;

      final refreshDio = Dio(BaseOptions(baseUrl: 'http://localhost:7070/'))
        ..httpClientAdapter = blockingRefreshAdapter;

      final interceptor = TokenRefreshInterceptor(
        primaryDio: primaryDio,
        storage: storage,
        onSessionExpired: () => sessionExpired = true,
        testRefreshDio: refreshDio,
      );
      primaryDio.interceptors.add(interceptor);

      // Both requests will first get a 401 JWT expired.
      primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      primaryAdapter.enqueue(status: 401, body: _jwtExpiredBody());
      // Retry responses for both requests after refresh.
      primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'res-1'));
      primaryAdapter.enqueue(
          status: 200, body: _successBody(results: 'res-2'));

      when(() => storage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh');
      when(() => storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      // Fire two requests concurrently.
      final future1 = primaryDio.get<dynamic>('/api/req1');
      final future2 = primaryDio.get<dynamic>('/api/req2');

      // Give the event loop a tick so both 401s can arrive.
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Exactly one refresh call should have been made so far.
      expect(blockingRefreshAdapter.callCount, equals(1));

      // Now let the refresh complete.
      blockingRefreshAdapter.complete(
        status: 200,
        body: _refreshSuccessBody(token: 'brand-new-jwt'),
      );

      final results = await Future.wait<Response<dynamic>>([future1, future2]);
      expect(results[0].statusCode, equals(200));
      expect(results[1].statusCode, equals(200));
      expect(sessionExpired, isFalse);
    });
  });
}


