# Stud.IP

<p align="center">
  <a href="https://github.com/ThexXTURBOXx/dart-studip/actions/workflows/ci.yml"><img src="https://github.com/ThexXTURBOXx/dart-studip/actions/workflows/ci.yml/badge.svg"></a>
</p>

A library which provides simple access to Stud.IP's RestAPI services using
 OAuth 1 authentication for Dart.

## Usage

Add to `pubspec.yaml`:

```yaml
dependencies:
  studip: ^2.1.2
```

A simple usage example:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:studip/studip.dart' as studip;

void main() {
  // Initialize client
  final client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET',
      apiBaseUrl: 'https://studip.uni-passau.de/studip/api.php/');
  client.getAuthorizationUrl('example://oauth_callback').then((String url) {
    // Get verifier by calling the returned link and approve access
    print('Open URL in browser: $url');
    final uri = stdin.readLineSync()!;

    // Retrieve permanent token
    final verifier = Uri.parse(uri).queryParameters['oauth_verifier'] ?? '';
    return client.retrieveAccessToken(verifier);
  }).then((void v) {
    // Example call
    return client.apiGetJson('user');
  }).then((dynamic decoded) {
    // Example parsing of response
    print(decoded['name']['formatted']);
  });
}
```

## Additional compatibilities

This library features additional compatibility for the `flutter_web_auth_2` library.

You can use both libraries together like this:
```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:studip/studip.dart' as studip;

void main() {
  // Initialize client
  final client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET',
      apiBaseUrl: 'https://studip.uni-passau.de/studip/api.php/');
  client.getAuthorizationUrl('example://oauth_callback').then((String url) {
    // Get verifier by calling the returned link and approve access
    return FlutterWebAuth2.authenticate(url: url, callbackUrlScheme: 'example');
  }).then((uri) {
    // Retrieve permanent token
    final verifier = Uri.parse(uri).queryParameters['oauth_verifier'] ?? '';
    return client.retrieveAccessToken(verifier);
  }).then((void v) {
    // Example call
    return client.apiGetJson('user');
  }).then((dynamic decoded) {
    // Example parsing of response
    print(decoded['name']['formatted']);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/ThexXTURBOXx/dart-studip/issues).
