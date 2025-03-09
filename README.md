# Stud.IP

<p align="center">
  <a href="https://github.com/ThexXTURBOXx/dart-studip/actions/workflows/ci.yml"><img src="https://github.com/ThexXTURBOXx/dart-studip/actions/workflows/ci.yml/badge.svg"></a>
</p>

A library which provides simple access to Stud.IP's JSON:API services using
 OAuth 2 authentication for Dart.

## Usage

Add to `pubspec.yaml`:

```yaml
dependencies:
  studip: ^3.0.0
```

A simple usage example:

```dart
import 'package:studip/studip.dart' as studip;

void main() {
  const studIpProviderUrl = 'http://studip.uni-passau.de/studip/';
  const apiBaseUrl = '${studIpProviderUrl}jsonapi.php/v1/';

  // Initialize client and log in
  final client = studip.StudIPClient(
    oAuthBaseUrl: studIpProviderUrl,
    redirectUri: 'example://oauth_callback',
    customUriScheme: 'example',
    clientId: 'CLIENT_ID',
    //clientSecret: 'CLIENT_SECRET_IF_NEEDED',
    apiBaseUrl: apiBaseUrl,
  );

  client.apiGetJson('users/me').then((dynamic decoded) {
    // Example parsing of response
    print('${decoded['data']['attributes']['formatted-name']}');
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/ThexXTURBOXx/dart-studip/issues).
