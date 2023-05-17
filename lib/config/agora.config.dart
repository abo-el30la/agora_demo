/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('201cb15314d74c2f89cc7b1e720153ed', defaultValue: '201cb15314d74c2f89cc7b1e720153ed');
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment(
      '007eJxTYNjgc6+sd5fYkyS7J/1nPaarFMzfvmFt779rJ2tur9rf9oZNgcHIwDA5ydDU2NAkxdwk2SjNwjI52TzJMNUcKGFqnJpy3jE5pSGQkcHbJJCVkQECQXw2huL85MzEHAYGAHrjIpA=',
      defaultValue:
          '007eJxTYNjgc6+sd5fYkyS7J/1nPaarFMzfvmFt779rJ2tur9rf9oZNgcHIwDA5ydDU2NAkxdwk2SjNwjI52TzJMNUcKGFqnJpy3jE5pSGQkcHbJJCVkQECQXw2huL85MzEHAYGAHrjIpA=');
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'social',
    defaultValue: 'social',
  );
}

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';

String get musicCenterAppId {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment('MUSIC_CENTER_APPID', defaultValue: '<MUSIC_CENTER_APPID>');
}
