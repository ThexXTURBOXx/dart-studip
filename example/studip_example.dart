import 'dart:developer';
import 'dart:io';

import 'package:studip/studip.dart' as studip;

/// How to retrieve data very simply
void main() {
  // Initialize client
  final client = studip.StudIPClient(
    'https://studip.uni-passau.de/studip/dispatch.php/api',
    'CONSUMER_KEY',
    'CONSUMER_SECRET',
    apiBaseUrl: 'https://studip.uni-passau.de/studip/api.php/',
  );
  client
      .getAuthorizationUrl('example://oauth_callback')
      .then((url) {
        // Get verifier by calling the returned link and approve access
        log('Open URL in browser: $url');
        final uri = stdin.readLineSync()!;
        // FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'example');

        // Retrieve permanent token
        final verifier = Uri.parse(uri).queryParameters['oauth_verifier'] ?? '';
        return client.retrieveAccessToken(verifier);
      })
      .then((v) => client.apiGetJson('user'))
      .then((dynamic decoded) {
        // Example parsing of response
        log('${decoded['name']['formatted']}');
      });
}
