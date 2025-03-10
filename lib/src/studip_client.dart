import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:studip/src/studip_oauth2_client.dart';

/// Provides simple-to-use access to Stud.IP's JSON:API over OAuth 2.
class StudIPClient {
  /// The client with access to the JSON:API using the retrieved OAuth 2.0
  /// credentials.
  final OAuth2Helper _client;

  /// The base URL for access to the JSON:API. Optional argument, but it is
  /// highly advised to specify due to enabling the proper use of all `api*`
  /// methods in this class.
  final String? apiBaseUrl;

  /// This is used to fix a 406 error. Without this, Stud.IP behaves weirdly.
  final Map<String, String> _acceptHeaderFix = {'Accept': '*/*'};

  /// The `oAuthBaseUrl` points to the OAuth base url. The `clientId` and
  /// `clientSecret` are the OAuth 2.0 client_id and client_secret. These are
  /// the four required arguments. If you already have a token, you can pass
  /// them in through the optional `tokenStorage`, together with other settings.
  /// The API endpoint can be specified using the optional argument
  /// `apiBaseUrl`. This eases requesting data from the API due to enabling the
  /// use of the `api*` methods in this class.
  StudIPClient({
    required String oAuthBaseUrl,
    required String redirectUri,
    required String customUriScheme,
    required String clientId,
    String? clientSecret,
    TokenStorage? tokenStorage,
    this.apiBaseUrl,
  }) : _client = OAuth2Helper(
          StudIPOAuth2Client(
            baseUrl: oAuthBaseUrl,
            redirectUri: redirectUri,
            customUriScheme: customUriScheme,
          ),
          clientId: clientId,
          clientSecret: clientSecret,
          tokenStorage: tokenStorage,
        );

  /// Returns the current OAuth client.
  OAuth2Helper get client => _client;

  /// Returns the set client_id.
  String get clientId => _client.clientId;

  /// Returns the set client_secret or `null` if not set.
  String? get consumerSecret => _client.clientSecret;

  /// Extracts and returns the current access token or `null` if not yet set.
  Future<String?> getToken() async => (await client.getToken())?.accessToken;

  /// Enhances the given headers by adding the necessary Bearer token
  /// authorization entry.
  Future<Map<String, String>> signHeaders([
    Map<String, String>? headers,
  ]) async =>
      {'Authorization': 'Bearer ${await getToken()}', ...(headers ?? {})};

  /// Returns the streamed response after executing the given `request`.
  /// This process is async, thus the streamed response is returned as a future
  /// streamed response instance. For authentication, use in conjunction with
  /// [].
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      _client.send(request);

  /// Returns the body of the given `url` after a POST request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> post(String url, {Map<String, String>? headers}) async =>
      postBody(url, headers: headers);

  /// Returns the body of the given `url` after a PUT request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> put(String url, {Map<String, String>? headers}) async =>
      putBody(url, headers: headers);

  /// Returns the body of the given `url` after a PATCH request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> patch(String url, {Map<String, String>? headers}) async =>
      patchBody(url, headers: headers);

  /// Returns the body of the given `url` after a GET request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> get(String url, {Map<String, String>? headers}) async =>
      getBody(url, headers: headers);

  /// Returns the body of the given `url` after a DELETE request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> delete(String url, {Map<String, String>? headers}) async =>
      deleteBody(url, headers: headers);

  /// Returns the body of the given `url` after a HEAD request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> head(String url, {Map<String, String>? headers}) async =>
      headBody(url, headers: headers);

  /// Returns the response of the given `url` after a POST request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> postResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.post(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the response of the given `url` after a PUT request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> putResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.put(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the response of the given `url` after a PATCH request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> patchResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.patch(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the response of the given `url` after a GET request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> getResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.get(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the response of the given `url` after a DELETE request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> deleteResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.delete(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the response of the given `url` after a HEAD request. This
  /// process is async, thus the response is returned as a future response
  /// instance.
  Future<http.Response> headResponse(
    String uri, {
    Map<String, String>? headers,
  }) async =>
      _client.head(uri, headers: {..._acceptHeaderFix, ...(headers ?? {})});

  /// Returns the body of the given `uri` after a POST request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> postBody(String uri, {Map<String, String>? headers}) async {
    final res = await postResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `uri` after a PUT request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> putBody(String uri, {Map<String, String>? headers}) async {
    final res = await putResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `uri` after a PATCH request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> patchBody(String uri, {Map<String, String>? headers}) async {
    final res = await patchResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `uri` after a GET request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> getBody(String uri, {Map<String, String>? headers}) async {
    final res = await getResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `uri` after a DELETE request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> deleteBody(String uri, {Map<String, String>? headers}) async {
    final res = await deleteResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `uri` after a HEAD request. This process
  /// is async, thus the body is returned as a future String instance.
  Future<String> headBody(String uri, {Map<String, String>? headers}) async {
    final res = await headResponse(uri, headers: headers);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given `endpoint` in the specified JSON:API after
  /// a GET request. To proper use, specify `apiBaseUrl`.
  Future<String> apiGet(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      get(apiBaseUrl! + endpoint, headers: headers);

  /// Returns the body of the given `endpoint` in the specified JSON:API after
  /// a POST request. To proper use, specify `apiBaseUrl`.
  Future<String> apiPost(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      post(apiBaseUrl! + endpoint, headers: headers);

  /// Returns the body of the given `endpoint` in the specified JSON:API after
  /// a PUT request. To proper use, specify `apiBaseUrl`.
  Future<String> apiPut(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      put(apiBaseUrl! + endpoint, headers: headers);

  /// Returns the body of the given `endpoint` in the specified JSON:API after
  /// a DELETE request. To proper use, specify `apiBaseUrl`.
  Future<String> apiDelete(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      delete(apiBaseUrl! + endpoint, headers: headers);

  /// Returns the body decoded as JSON of the given `endpoint` in the
  /// specified JSON:API after a GET request. To proper use, specify
  /// `apiBaseUrl`.
  Future<dynamic> apiGetJson(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      json.decode(await apiGet(endpoint, headers: headers));

  /// Returns the body decoded as JSON of the given `endpoint` in the
  /// specified JSON:API after a POST request. To proper use, specify
  /// `apiBaseUrl`.
  Future<dynamic> apiPostJson(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      json.decode(await apiPost(endpoint, headers: headers));

  /// Returns the body decoded as JSON of the given `endpoint` in the
  /// specified JSON:API after a PUT request. To proper use, specify
  /// `apiBaseUrl`.
  Future<dynamic> apiPutJson(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      json.decode(await apiPut(endpoint, headers: headers));

  /// Returns the body decoded as JSON of the given `endpoint` in the
  /// specified JSON:API after a DELETE request. To proper use, specify
  /// `apiBaseUrl`.
  Future<dynamic> apiDeleteJson(
    String endpoint, {
    Map<String, String>? headers,
  }) async =>
      json.decode(await apiDelete(endpoint, headers: headers));

  /// Returns whether the given status code should be handled as a error code,
  /// thus indicating, that the session is invalid and should be renewed.
  bool isErrorCode(int statusCode) => statusCode == 401 || statusCode == 500;
}

/// Thrown when the currently used session is invalid and a new client should be
/// constructed.
class SessionInvalidException implements Exception {
  final int _errorCode;

  /// Constructs a new Exception indicating that the currently used session is
  /// invalid and a new client should be constructed.
  const SessionInvalidException(this._errorCode);

  /// Returns the HTTP error code received.
  int get errorCode => _errorCode;
}
