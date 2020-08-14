library studip_client;

import 'dart:convert';

import 'package:oauth1/oauth1.dart' as oauth1;

/// Provides simple-to-use access to Stud.IP's RestAPI over OAuth 1.
class StudIPClient {
  oauth1.ClientCredentials _clientCredentials;
  oauth1.Credentials _credentials;
  oauth1.Platform _platform;
  oauth1.Authorization _auth;

  /// The client with access to the RestAPI using the retrieved OAuth
  /// credentials (is null until ``retrieveAccessToken`` is called).
  oauth1.Client client;

  /// The base URL for access to the RestAPI. Optional argument, but it is
  /// highly advised to specify due to enabling the proper use of all ``api*``
  /// methods in this class.
  String apiBaseUrl;

  /// The ``oAuthBaseUrl`` points to the OAuth base url. The ``consumerKey``
  /// and ``consumerSecret`` are the OAuth consumer key and secret. These are
  /// the three required arguments. If you already have an access token and
  /// access token secret, you can pass them in as the optional arguments
  /// ``accessToken`` and ``accessTokenSecret``. The API endpoint can be
  /// specified using the optional argument ``apiBaseUrl``. This eases
  /// requesting data from the API due to enabling the use of the ``api*``
  /// methods in this class.
  StudIPClient(String oAuthBaseUrl, String consumerKey, String consumerSecret,
      {String accessToken, String accessTokenSecret, this.apiBaseUrl}) {
    _clientCredentials = oauth1.ClientCredentials(consumerKey, consumerSecret);
    _platform = oauth1.Platform(
        oAuthBaseUrl + '/oauth/request_token',
        oAuthBaseUrl + '/oauth/authorize',
        oAuthBaseUrl + '/oauth/access_token',
        oauth1.SignatureMethods.hmacSha1);
    _auth = oauth1.Authorization(_clientCredentials, _platform);
    _credentials = oauth1.Credentials(accessToken, accessTokenSecret);
    client = oauth1.Client(
        _platform.signatureMethod, _clientCredentials, _credentials);
  }

  /// Returns the set consumer key.
  String get consumerKey => _clientCredentials.token;

  /// Returns the set consumer secret.
  String get consumerSecret => _clientCredentials.tokenSecret;

  /// Returns the retrieved access token.
  String get accessToken => _credentials.token;

  /// Returns the retrieved access token secret.
  String get accessTokenSecret => _credentials.tokenSecret;

  /// The first step in the OAuth authentication process. Returns the
  /// authorization URL after it is generated. This process is async.
  Future<String> getAuthorizationUrl([String callback]) async {
    final res = await _auth.requestTemporaryCredentials(callback);
    _credentials = res.credentials;
    return _auth.getResourceOwnerAuthorizationURI(res.credentials.token);
  }

  /// The second step in the OAuth authentication process. A permanent access
  /// token is retrieved and saved. Requires a ``verifierToken``, which has
  /// been generated using the URL, retrieved in ``getAuthorizationUrl``. This
  /// process is async. After completion, Stud.IP's RestAPI can be fully
  /// accessed.
  Future<void> retrieveAccessToken(String verifierToken) async {
    final res =
        await _auth.requestTokenCredentials(_credentials, verifierToken);
    _credentials = res.credentials;
    client = oauth1.Client(
        _platform.signatureMethod, _clientCredentials, res.credentials);
  }

  /// Returns the body of the given ``url``. This process is async, thus the
  /// body is returned as a future String instance.
  Future<String> get(String url) async {
    final res = await client.get(url);
    if (isErrorCode(res.statusCode)) {
      throw SessionInvalidException(res.statusCode);
    }
    return res.body;
  }

  /// Returns the body of the given ``endpoint`` in the specified RestAPI. To
  /// proper use, specify ``apiBaseUrl``.
  Future<String> apiGet(String endpoint) async {
    return get(apiBaseUrl + endpoint);
  }

  /// Returns the body decoded as JSON of the given ``endpoint`` in the
  /// specified RestAPI. To proper use, specify ``apiBaseUrl``.
  Future<dynamic> apiGetJson(String endpoint) async {
    return json.decode(await apiGet(endpoint));
  }

  /// Returns whether the given status code should be handled as a error code,
  /// thus indicating, that the session is invalid and should be renewed.
  bool isErrorCode(int statusCode) {
    return statusCode == 401 || statusCode == 500;
  }
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
