class UserSession {
  final String userId;
  final String username;
  final String displayName;
  final String accessToken;
  final String refreshToken;
  final String deviceId;
  final String about;

  const UserSession({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.accessToken,
    required this.refreshToken,
    required this.deviceId,
    this.about = '',
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'displayName': displayName,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'deviceId': deviceId,
        'about': about,
      };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;
    return UserSession(
      userId: json['userId'] as String? ??
          userMap?['id'] as String? ??
          json['user_id'] as String? ??
          '',
      username:
          json['username'] as String? ?? userMap?['username'] as String? ?? '',
      displayName: json['displayName'] as String? ??
          userMap?['display_name'] as String? ??
          '',
      accessToken: json['accessToken'] as String? ??
          json['access_token'] as String? ??
          '',
      refreshToken: json['refreshToken'] as String? ??
          json['refresh_token'] as String? ??
          '',
      deviceId:
          json['deviceId'] as String? ?? json['device_id'] as String? ?? '',
      about: json['about'] as String? ?? userMap?['about'] as String? ?? '',
    );
  }
}

class UserSearchItem {
  final String id;
  final String username;
  final String displayName;
  final String about;

  const UserSearchItem({
    required this.id,
    required this.username,
    required this.displayName,
    required this.about,
  });

  factory UserSearchItem.fromJson(Map<String, dynamic> json) {
    return UserSearchItem(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ??
          json['display_name'] as String? ??
          '',
      about: json['about'] as String? ?? '',
    );
  }
}
