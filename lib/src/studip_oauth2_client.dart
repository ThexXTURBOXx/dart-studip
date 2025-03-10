import 'package:oauth2_client/oauth2_client.dart';

/// Implements an OAuth2 client that uses Stud.IP services to
/// authorize requests.
///
/// You can get the access token for using it with the JSON:API
/// ```dart
/// oauth2Helper.getToken()
/// ```
class StudIPOAuth2Client extends OAuth2Client {
  /// `baseUrl` is the Stud.IP base URL (e.g., at the University of Passau:
  /// https://studip.uni-passau.de/studip). `redirectUri` is the URI that should
  /// be used as the redirect URI within the OAuth 2.0 process.
  /// `customUriScheme` is the scheme of the `redirectUri`.
  StudIPOAuth2Client({
    required String baseUrl,
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
          authorizeUrl: '$baseUrl/dispatch.php/api/oauth2/authorize',
          tokenUrl: '$baseUrl/dispatch.php/api/oauth2/token',
        );
}
