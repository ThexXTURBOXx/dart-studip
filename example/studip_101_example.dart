import 'dart:io';

import 'package:studip/studip.dart' as studip;

/// A new way (introduced in 1.0.1) to retrieve data with even less code!
void main() {
  // Initialize client
  var client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET',
      apiBaseUrl: 'https://studip.uni-passau.de/studip/api.php/');
  // TODO Replace CONSUMER_KEY and CONSUMER_SECRET
  client.getAuthorizationUrl('example://oauth_callback').then((url) {
    // Get verifier by calling the returned link and approve access
    print('Open URL in browser: $url');
    final uri = stdin.readLineSync();
    // or e.g. using FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'example');

    // Retrieve permanent token
    final verifier = Uri.parse(uri).queryParameters['oauth_verifier'];
    return client.retrieveAccessToken(verifier);
  }).then((v) {
    // Example call
    return client.apiGetJson('user');
  }).then((decoded) {
    // Example parsing of response
    print(decoded['name']['formatted']);
  });
}
