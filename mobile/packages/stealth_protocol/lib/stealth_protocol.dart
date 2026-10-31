import 'dart:convert';
import 'dart:typed_data';

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

class MessageBody {
  final String text;
  final String? mediaId;
  final String? mime;
  final String? fileName;
  final int? sizeBytes;
  final String? thumbhash;
  final int? durationMs;
  final List<int> waveform;

  const MessageBody({
    this.text = '',
    this.mediaId,
    this.mime,
    this.fileName,
    this.sizeBytes,
    this.thumbhash,
    this.durationMs,
    this.waveform = const [],
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    if (mediaId != null) 'media_id': mediaId,
    if (mime != null) 'mime': mime,
    if (fileName != null) 'file_name': fileName,
    if (sizeBytes != null) 'size_bytes': sizeBytes,
    if (thumbhash != null) 'thumbhash': thumbhash,
    if (durationMs != null) 'duration_ms': durationMs,
    if (waveform.isNotEmpty) 'waveform': waveform,
  };

  factory MessageBody.fromJson(Map<String, dynamic> json) {
    return MessageBody(
      text: json['text'] as String? ?? '',
      mediaId: json['media_id'] as String?,
      mime: json['mime'] as String?,
      fileName: json['file_name'] as String?,
      sizeBytes: json['size_bytes'] as int?,
      thumbhash: json['thumbhash'] as String?,
      durationMs: json['duration_ms'] as int?,
      waveform: (json['waveform'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Uint8List toBytes() => Uint8List.fromList(utf8.encode(jsonEncode(toJson())));

  factory MessageBody.fromBytes(Uint8List bytes) {
    if (bytes.isEmpty) return const MessageBody();
    try {
      final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      return MessageBody.fromJson(decoded);
    } catch (_) {
      return MessageBody(text: utf8.decode(bytes, allowMalformed: true));
    }
  }
}

class SendMessage {
  final String messageId;
  final String conversationId;
  final MessageKind kind;
  final Uint8List payload;
  final String? replyToId;
  final int clientTsMs;

  const SendMessage({
    required this.messageId,
    required this.conversationId,
    this.kind = MessageKind.text,
    required this.payload,
    this.replyToId,
    required this.clientTsMs,
  });

  Map<String, dynamic> toJson() => {
    'message_id': messageId,
    'conversation_id': conversationId,
    'kind': kind.value,
    'payload': base64Encode(payload),
    if (replyToId != null) 'reply_to_id': replyToId,
    'client_ts_ms': clientTsMs,
  };

  factory SendMessage.fromJson(Map<String, dynamic> json) {
    return SendMessage(
      messageId: json['message_id'] as String,
      conversationId: json['conversation_id'] as String,
      kind: MessageKind.fromValue(json['kind'] as int? ?? 1),
      payload: base64Decode(json['payload'] as String? ?? ''),
      replyToId: json['reply_to_id'] as String?,
      clientTsMs: json['client_ts_ms'] as int? ?? 0,
    );
  }
}

class Ack {
  final String messageId;
  final int seq;
  final int serverTsMs;

  const Ack({
    required this.messageId,
    required this.seq,
    required this.serverTsMs,
  });

  Map<String, dynamic> toJson() => {
    'message_id': messageId,
    'seq': seq,
    'server_ts_ms': serverTsMs,
  };

  factory Ack.fromJson(Map<String, dynamic> json) {
    return Ack(
      messageId: json['message_id'] as String,
      seq: json['seq'] as int? ?? 0,
      serverTsMs: json['server_ts_ms'] as int? ?? 0,
    );
  }
}

class MessageNew {
  final String conversationId;
  final int seq;
  final String messageId;
  final String senderId;
  final MessageKind kind;
  final Uint8List payload;
  final String? replyToId;
  final int serverTsMs;
  final int editVersion;

  const MessageNew({
    required this.conversationId,
    required this.seq,
    required this.messageId,
    required this.senderId,
    this.kind = MessageKind.text,
    required this.payload,
    this.replyToId,
    required this.serverTsMs,
    this.editVersion = 0,
  });

  Map<String, dynamic> toJson() => {
    'conversation_id': conversationId,
    'seq': seq,
    'message_id': messageId,
    'sender_id': senderId,
    'kind': kind.value,
    'payload': base64Encode(payload),
    if (replyToId != null) 'reply_to_id': replyToId,
    'server_ts_ms': serverTsMs,
    'edit_version': editVersion,
  };

  factory MessageNew.fromJson(Map<String, dynamic> json) {
    return MessageNew(
      conversationId: json['conversation_id'] as String,
      seq: json['seq'] as int? ?? 0,
      messageId: json['message_id'] as String,
      senderId: json['sender_id'] as String,
      kind: MessageKind.fromValue(json['kind'] as int? ?? 1),
      payload: base64Decode(json['payload'] as String? ?? ''),
      replyToId: json['reply_to_id'] as String?,
      serverTsMs: json['server_ts_ms'] as int? ?? 0,
      editVersion: json['edit_version'] as int? ?? 0,
    );
  }
}

class ReceiptUpTo {
  final String conversationId;
  final int deliveredUptoSeq;
  final int readUptoSeq;

  const ReceiptUpTo({
    required this.conversationId,
    required this.deliveredUptoSeq,
    required this.readUptoSeq,
  });

  Map<String, dynamic> toJson() => {
    'conversation_id': conversationId,
    'delivered_upto_seq': deliveredUptoSeq,
    'read_upto_seq': readUptoSeq,
  };

  factory ReceiptUpTo.fromJson(Map<String, dynamic> json) {
    return ReceiptUpTo(
      conversationId: json['conversation_id'] as String,
      deliveredUptoSeq: json['delivered_upto_seq'] as int? ?? 0,
      readUptoSeq: json['read_upto_seq'] as int? ?? 0,
    );
  }
}

class ReceiptUpdate {
  final String conversationId;
  final String userId;
  final int deliveredUptoSeq;
  final int readUptoSeq;

  const ReceiptUpdate({
    required this.conversationId,
    required this.userId,
    required this.deliveredUptoSeq,
    required this.readUptoSeq,
  });

  Map<String, dynamic> toJson() => {
    'conversation_id': conversationId,
    'user_id': userId,
    'delivered_upto_seq': deliveredUptoSeq,
    'read_upto_seq': readUptoSeq,
  };

  factory ReceiptUpdate.fromJson(Map<String, dynamic> json) {
    return ReceiptUpdate(
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      deliveredUptoSeq: json['delivered_upto_seq'] as int? ?? 0,
      readUptoSeq: json['read_upto_seq'] as int? ?? 0,
    );
  }
}

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
    'changed_conversations': changedConversations.map((c) => c.toJson()).toList(),
  };

  factory HelloOk.fromJson(Map<String, dynamic> json) {
    return HelloOk(
      serverTimeMs: json['server_time_ms'] as int? ?? 0,
      changedConversations: (json['changed_conversations'] as List<dynamic>?)
          ?.map((e) => ConversationSummary.fromJson(e as Map<String, dynamic>))
          .toList() ?? const [],
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
          .toList() ?? const [],
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
      userIds: (json['user_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
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
  factory Ping.fromJson(Map<String, dynamic> json) => Ping(timestampMs: json['timestamp_ms'] as int? ?? 0);
}

class Pong {
  final int timestampMs;
  const Pong({required this.timestampMs});
  Map<String, dynamic> toJson() => {'timestamp_ms': timestampMs};
  factory Pong.fromJson(Map<String, dynamic> json) => Pong(timestampMs: json['timestamp_ms'] as int? ?? 0);
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
  factory Kick.fromJson(Map<String, dynamic> json) => Kick(reason: json['reason'] as String? ?? '');
}

class ClientFrame {
  final int v;
  final String reqId;
  final dynamic body;

  const ClientFrame({
    this.v = 1,
    required this.reqId,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'v': v,
      'req_id': reqId,
    };
    if (body is Hello) {
      map['hello'] = (body as Hello).toJson();
    } else if (body is SendMessage) {
      map['send'] = (body as SendMessage).toJson();
    } else if (body is ReceiptUpTo) {
      map['receipt'] = (body as ReceiptUpTo).toJson();
    } else if (body is Typing) {
      map['typing'] = (body as Typing).toJson();
    } else if (body is SyncRequest) {
      map['sync'] = (body as SyncRequest).toJson();
    } else if (body is SubscribePresence) {
      map['subscribe_presence'] = (body as SubscribePresence).toJson();
    } else if (body is Ping) {
      map['ping'] = (body as Ping).toJson();
    }
    return map;
  }

  Uint8List toBytes() => Uint8List.fromList(utf8.encode(jsonEncode(toJson())));

  factory ClientFrame.fromJson(Map<String, dynamic> json) {
    final v = json['v'] as int? ?? 1;
    final reqId = json['req_id'] as String? ?? '';
    dynamic body;

    if (json.containsKey('hello')) {
      body = Hello.fromJson(json['hello'] as Map<String, dynamic>);
    } else if (json.containsKey('send')) {
      body = SendMessage.fromJson(json['send'] as Map<String, dynamic>);
    } else if (json.containsKey('receipt')) {
      body = ReceiptUpTo.fromJson(json['receipt'] as Map<String, dynamic>);
    } else if (json.containsKey('typing')) {
      body = Typing.fromJson(json['typing'] as Map<String, dynamic>);
    } else if (json.containsKey('sync')) {
      body = SyncRequest.fromJson(json['sync'] as Map<String, dynamic>);
    } else if (json.containsKey('subscribe_presence')) {
      body = SubscribePresence.fromJson(json['subscribe_presence'] as Map<String, dynamic>);
    } else if (json.containsKey('ping')) {
      body = Ping.fromJson(json['ping'] as Map<String, dynamic>);
    }

    return ClientFrame(v: v, reqId: reqId, body: body);
  }

  factory ClientFrame.fromBytes(Uint8List bytes) {
    final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    return ClientFrame.fromJson(decoded);
  }
}

class ServerFrame {
  final int v;
  final String reqId;
  final dynamic body;

  const ServerFrame({
    this.v = 1,
    this.reqId = '',
    required this.body,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'v': v,
      'req_id': reqId,
    };
    if (body is HelloOk) {
      map['hello_ok'] = (body as HelloOk).toJson();
    } else if (body is Ack) {
      map['ack'] = (body as Ack).toJson();
    } else if (body is ProtocolError) {
      map['error'] = (body as ProtocolError).toJson();
    } else if (body is MessageNew) {
      map['message_new'] = (body as MessageNew).toJson();
    } else if (body is ReceiptUpdate) {
      map['receipt'] = (body as ReceiptUpdate).toJson();
    } else if (body is SyncBatch) {
      map['sync_batch'] = (body as SyncBatch).toJson();
    } else if (body is Presence) {
      map['presence'] = (body as Presence).toJson();
    } else if (body is Pong) {
      map['pong'] = (body as Pong).toJson();
    } else if (body is Kick) {
      map['kick'] = (body as Kick).toJson();
    }
    return map;
  }

  Uint8List toBytes() => Uint8List.fromList(utf8.encode(jsonEncode(toJson())));

  factory ServerFrame.fromJson(Map<String, dynamic> json) {
    final v = json['v'] as int? ?? 1;
    final reqId = json['req_id'] as String? ?? '';
    dynamic body;

    if (json.containsKey('hello_ok')) {
      body = HelloOk.fromJson(json['hello_ok'] as Map<String, dynamic>);
    } else if (json.containsKey('ack')) {
      body = Ack.fromJson(json['ack'] as Map<String, dynamic>);
    } else if (json.containsKey('error')) {
      body = ProtocolError.fromJson(json['error'] as Map<String, dynamic>);
    } else if (json.containsKey('message_new')) {
      body = MessageNew.fromJson(json['message_new'] as Map<String, dynamic>);
    } else if (json.containsKey('receipt')) {
      body = ReceiptUpdate.fromJson(json['receipt'] as Map<String, dynamic>);
    } else if (json.containsKey('sync_batch')) {
      body = SyncBatch.fromJson(json['sync_batch'] as Map<String, dynamic>);
    } else if (json.containsKey('presence')) {
      body = Presence.fromJson(json['presence'] as Map<String, dynamic>);
    } else if (json.containsKey('pong')) {
      body = Pong.fromJson(json['pong'] as Map<String, dynamic>);
    } else if (json.containsKey('kick')) {
      body = Kick.fromJson(json['kick'] as Map<String, dynamic>);
    }

    return ServerFrame(v: v, reqId: reqId, body: body);
  }

  factory ServerFrame.fromBytes(Uint8List bytes) {
    final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    return ServerFrame.fromJson(decoded);
  }
}
