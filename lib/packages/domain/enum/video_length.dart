import '../../index.dart';

enum VideoLength {
  @JsonValue('SHORT')
  short,

  @JsonValue('MEDIUM')
  medium,

  @JsonValue('LONG')
  long,
}

extension VideoLengthJson on VideoLength {
  String toJson() {
    const map = {
      VideoLength.short:  'SHORT',
      VideoLength.medium: 'MEDIUM',
      VideoLength.long:   'LONG',
    };
    return map[this]!;
  }
}
