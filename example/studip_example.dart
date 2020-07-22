import 'dart:convert';
import 'dart:io';

import 'package:studip/studip.dart' as studip;

/// The old way before 1.0.1 (see `studip_101_example.dart` for a new example).
void main() {
  // Initialize client
  final client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET');
  client.getAuthorizationUrl('example://oauth_callback').then((String url) {
    // Get verifier by calling the returned link and approve access
    print('Open URL in browser: $url');
    final uri = stdin.readLineSync();
    // or e.g. using FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'example');

    // Retrieve permanent token
    final verifier = Uri.parse(uri).queryParameters['oauth_verifier'];
    return client.retrieveAccessToken(verifier);
  }).then((void v) {
    // Example call
    return client.get('https://studip.uni-passau.de/studip/api.php/user');
  }).then((body) {
    // Example parsing of response
    final dynamic decoded = json.decode(body);
    print(decoded['name']['formatted']);
  });
}
