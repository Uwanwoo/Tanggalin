import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _authHeaders;
  final http.Client _innerClient;
  static const _defaultEncoding = utf8;

  GoogleHttpClient(this._authHeaders, {http.Client? innerClient})
    : _innerClient = innerClient ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Ensure authorization headers are added
    request.headers.addAll(_authHeaders);

    // Ensure Content-Type header is set if not provided
    if (request.headers['Content-Type'] == null && request is http.Request) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
    }

    return _innerClient.send(request);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.get(url, headers: mergedHeaders);
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.post(
      url,
      headers: mergedHeaders,
      body: body,
      encoding: encoding ?? _defaultEncoding,
    );
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.put(
      url,
      headers: mergedHeaders,
      body: body,
      encoding: encoding ?? _defaultEncoding,
    );
  }

  @override
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.patch(
      url,
      headers: mergedHeaders,
      body: body,
      encoding: encoding ?? _defaultEncoding,
    );
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.delete(
      url,
      headers: mergedHeaders,
      body: body,
      encoding: encoding ?? _defaultEncoding,
    );
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    final mergedHeaders = _mergeHeaders(headers);
    return _innerClient.head(url, headers: mergedHeaders);
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {..._authHeaders, ...?headers};
  }

  @override
  void close() {
    _innerClient.close();
    super.close();
  }
}
