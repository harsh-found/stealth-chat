import 'enums.dart';
import 'messages.dart';

class Hello {
  final String accessToken;
  final String deviceId;
  final int v;
  final int syncToken;

  const Hello({
    required this.accessToken,
    required this.deviceId,
    this.v = 1,
    this.syncToken = 0,
  });

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'device_id': deviceId,
        'v': v,
        'sync_token': syncToken,
      };

  factory Hello.fromJson(Map<String, dynamic> json) {
    return Hello(
      accessToken: json['access_token'] as String? ?? '',
      deviceId: json['device_id'] as String? ?? '',
      v: json['v'] as int? ?? 1,
      syncToken: json['sync_token'] as int? ?? 0,
    );
  }
}

class ConversationSummary {
  final String conversationId;
  final int lastSeq;
  final int unreadCount;
  final String lastMessagePreview;
  final int lastMessageAtMs;

  const ConversationSummary({
    required this.conversationId,
    required this.lastSeq,
    required this.unreadCount,
    required this.lastMessagePreview,
    required this.lastMessageAtMs,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'last_seq': lastSeq,
        'unread_count': unreadCount,
        'last_message_preview': lastMessagePreview,
        'last_message_at_ms': lastMessageAtMs,
      };

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      conversationId: json['conversation_id'] as String,
      lastSeq: json['last_seq'] as int? ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
      lastMessagePreview: json['last_message_preview'] as String? ?? '',
      lastMessageAtMs: json['last_message_at_ms'] as int? ?? 0,
    );
  }
}

class HelloOk {
  final int serverTimeMs;
  final List<ConversationSummary> changedConversations;

  const HelloOk({
    required this.serverTimeMs,
    this.changedConversations = const [],
  });

  Map<String, dynamic> toJson() => {
        'server_time_ms': serverTimeMs,
        'changed_conversations':
            changedConversations.map((c) => c.toJson()).toList(),
      };

  factory HelloOk.fromJson(Map<String, dynamic> json) {
    return HelloOk(
      serverTimeMs: json['server_time_ms'] as int? ?? 0,
      changedConversations: (json['changed_conversations'] as List<dynamic>?)
              ?.map((e) =>
                  ConversationSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class SyncRequest {
  final String conversationId;
  final int afterSeq;
  final int limit;

  const SyncRequest({
    required this.conversationId,
    required this.afterSeq,
    this.limit = 50,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'after_seq': afterSeq,
        'limit': limit,
      };

  factory SyncRequest.fromJson(Map<String, dynamic> json) {
    return SyncRequest(
      conversationId: json['conversation_id'] as String,
      afterSeq: json['after_seq'] as int? ?? 0,
      limit: json['limit'] as int? ?? 50,
    );
  }
}

class SyncBatch {
  final String conversationId;
  final List<MessageNew> messages;
  final bool hasMore;

  const SyncBatch({
    required this.conversationId,
    this.messages = const [],
    this.hasMore = false,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'messages': messages.map((m) => m.toJson()).toList(),
        'has_more': hasMore,
      };

  factory SyncBatch.fromJson(Map<String, dynamic> json) {
    return SyncBatch(
      conversationId: json['conversation_id'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageNew.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class Typing {
  final String conversationId;
  final bool isTyping;

  const Typing({
    required this.conversationId,
    required this.isTyping,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'is_typing': isTyping,
      };

  factory Typing.fromJson(Map<String, dynamic> json) {
    return Typing(
      conversationId: json['conversation_id'] as String,
      isTyping: json['is_typing'] as bool? ?? false,
    );
  }
}

class SubscribePresence {
  final List<String> userIds;

  const SubscribePresence({this.userIds = const []});

  Map<String, dynamic> toJson() => {'user_ids': userIds};

  factory SubscribePresence.fromJson(Map<String, dynamic> json) {
    return SubscribePresence(
      userIds: (json['user_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}

class Presence {
  final String userId;
  final bool online;
  final int lastSeenMs;

  const Presence({
    required this.userId,
    required this.online,
    required this.lastSeenMs,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'online': online,
        'last_seen_ms': lastSeenMs,
      };

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      userId: json['user_id'] as String,
      online: json['online'] as bool? ?? false,
      lastSeenMs: json['last_seen_ms'] as int? ?? 0,
    );
  }
}

class Ping {
  final int timestampMs;
  const Ping({required this.timestampMs});
  Map<String, dynamic> toJson() => {'timestamp_ms': timestampMs};
  factory Ping.fromJson(Map<String, dynamic> json) =>
      Ping(timestampMs: json['timestamp_ms'] as int? ?? 0);
}

class Pong {
  final int timestampMs;
  const Pong({required this.timestampMs});
  Map<String, dynamic> toJson() => {'timestamp_ms': timestampMs};
  factory Pong.fromJson(Map<String, dynamic> json) =>
      Pong(timestampMs: json['timestamp_ms'] as int? ?? 0);
}

class ProtocolError {
  final String reqId;
  final ErrorCode code;
  final String message;
  final int retryAfterMs;

  const ProtocolError({
    required this.reqId,
    required this.code,
    required this.message,
    this.retryAfterMs = 0,
  });

  Map<String, dynamic> toJson() => {
        'req_id': reqId,
        'code': code.value,
        'message': message,
        'retry_after_ms': retryAfterMs,
      };

  factory ProtocolError.fromJson(Map<String, dynamic> json) {
    return ProtocolError(
      reqId: json['req_id'] as String? ?? '',
      code: ErrorCode.fromValue(json['code'] as int? ?? 0),
      message: json['message'] as String? ?? '',
      retryAfterMs: json['retry_after_ms'] as int? ?? 0,
    );
  }
}

class Kick {
  final String reason;
  const Kick({required this.reason});
  Map<String, dynamic> toJson() => {'reason': reason};
  factory Kick.fromJson(Map<String, dynamic> json) =>
      Kick(reason: json['reason'] as String? ?? '');
}
