import 'dart:developer';

import 'package:studip/studip.dart' as studip;

/// How to retrieve data very simply
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
    log('${decoded['data']['attributes']['formatted-name']}');
  });
}
