library studip_client;

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

  /// The ``baseUrl`` points to the API endpoint base url. The ``consumerKey``
  /// and ``consumerSecret`` are the OAuth consumer key and secret. These are
  /// the three required arguments. If you already have an access token and
  /// access token secret, you can pass them in as the optional arguments
  /// ``accessToken`` and ``accessTokenSecret``.
  StudIPClient(String baseUrl, String consumerKey, String consumerSecret,
      [String accessToken, String accessTokenSecret]) {
    _clientCredentials = oauth1.ClientCredentials(consumerKey, consumerSecret);
    _platform = oauth1.Platform(
        baseUrl + '/oauth/request_token',
        baseUrl + '/oauth/authorize',
        baseUrl + '/oauth/access_token',
        oauth1.SignatureMethods.hmacSha1);
    _auth = oauth1.Authorization(_clientCredentials, _platform);
    _credentials = oauth1.Credentials(accessToken, accessTokenSecret);
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
    var res = await _auth.requestTemporaryCredentials(callback);
    _credentials = res.credentials;
    return _auth.getResourceOwnerAuthorizationURI(res.credentials.token);
  }

  /// The second step in the OAuth authentication process. A permanent access
  /// token is retrieved and saved. Requires a ``verifierToken``, which has
  /// been generated using the URL, retrieved in ``getAuthorizationUrl``. This
  /// process is async. After completion, Stud.IP's RestAPI can be fully
  /// accessed.
  Future<void> retrieveAccessToken(String verifierToken) async {
    var res = await _auth.requestTokenCredentials(_credentials, verifierToken);
    _credentials = res.credentials;
    client = oauth1.Client(
        _platform.signatureMethod, _clientCredentials, res.credentials);
  }

  /// Returns the body of the given ``url``. This process is async, thus the
  /// body is returned as a future String instance.
  Future<String> get(String url) async {
    return (await client.get(url)).body;
  }
}
