enum MessageKind {
  unspecified(0),
  text(1),
  image(2),
  voice(3),
  video(4),
  file(5);

  final int value;
  const MessageKind(this.value);

  static MessageKind fromValue(int value) {
    return MessageKind.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageKind.unspecified,
    );
  }
}

enum ErrorCode {
  unspecified(0),
  unauthenticated(1),
  tokenExpired(2),
  forbidden(3),
  notFound(4),
  rateLimited(5),
  tooLarge(6),
  internal(7),
  unsupportedVersion(8);

  final int value;
  const ErrorCode(this.value);

  static ErrorCode fromValue(int value) {
    return ErrorCode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ErrorCode.unspecified,
    );
  }
}
