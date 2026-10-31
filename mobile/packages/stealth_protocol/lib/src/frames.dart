import 'dart:convert';
import 'dart:typed_data';

import 'messages.dart';
import 'sync_models.dart';

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
      body = SubscribePresence.fromJson(
          json['subscribe_presence'] as Map<String, dynamic>);
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
