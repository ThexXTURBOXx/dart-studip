import 'package:oauth2_client/oauth2_client.dart';

/// Implements an OAuth2 client that uses Stud.IP services to
/// authorize requests.
///
/// You can get the access token for using it with the JSON:API
/// ```dart
/// oauth2Helper.getToken()
/// ```
class StudIPOAuth2Client extends OAuth2Client {
  StudIPOAuth2Client({
    required String baseUrl,
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
          authorizeUrl: '$baseUrl/dispatch.php/api/oauth2/authorize',
          tokenUrl: '$baseUrl/dispatch.php/api/oauth2/token',
        );
}
