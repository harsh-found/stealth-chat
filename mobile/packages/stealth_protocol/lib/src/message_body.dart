import 'dart:convert';
import 'dart:typed_data';

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
      waveform:
          (json['waveform'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
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
