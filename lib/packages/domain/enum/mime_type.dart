import '../../index.dart';

enum MimeType {
  @JsonValue('JPEG')
  jpeg,

  @JsonValue('PNG')
  png,
}

extension MimeTypeJson on MimeType {
  String toJson() {
    const map = {
      MimeType.jpeg: 'JPEG',
      MimeType.png:  'PNG',
    };
    return map[this]!;
  }
}
