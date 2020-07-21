# Stud.IP

A library which provides simple access to Stud.IP's RestAPI services using
 OAuth 1 authentication for Dart.

## Usage

Add to ``pubspec.yaml``:

```yaml
dependencies:
  studip: ^1.0.1
```

A simple usage example:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:studip/studip.dart' as studip;

void main() {
  // Initialize client
  var client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET');
  // TODO Replace CONSUMER_KEY and CONSUMER_SECRET
  client.getAuthorizationUrl('example://oauth_callback').then((url) {
    // Get verifier by calling the returned link and approve access
    print('Open URL in browser: $url');
    return stdin.readLineSync();
  }).then((res) {
    // Retrieve permanent token
    final verifier = Uri.parse(res).queryParameters['oauth_verifier'];
    return client.retrieveAccessToken(verifier);
  }).then((v) {
    // Example call
    return client.get('https://studip.uni-passau.de/studip/api.php/user');
  }).then((body) {
    // Example parsing of response
    final decoded = json.decode(body);
    print(decoded['name']['formatted']);
  });
}
```

## Additional compatibilities

This library features additional compatibility for the ``flutter_web_auth`` library.

You can use both libraries together like this:
```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:studip/studip.dart' as studip;

void main() {
  // Initialize client
  var client = studip.StudIPClient(
      'https://studip.uni-passau.de/studip/dispatch.php/api',
      'CONSUMER_KEY',
      'CONSUMER_SECRET');
  // TODO Replace CONSUMER_KEY and CONSUMER_SECRET
  client.getAuthorizationUrl('example://oauth_callback').then((url) {
    // Get verifier by calling the returned link and approve access
    return FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'example');
  }).then((res) {
    // Retrieve permanent token
    final verifier = Uri.parse(res).queryParameters['oauth_verifier'];
    return client.retrieveAccessToken(verifier);
  }).then((v) {
    // Example call
    return client.get('https://studip.uni-passau.de/studip/api.php/user');
  }).then((body) {
    // Example parsing of response
    final decoded = json.decode(body);
    print(decoded['name']['formatted']);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ThexXTURBOXx/dart-studip/issues
