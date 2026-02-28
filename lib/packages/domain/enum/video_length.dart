import '../../index.dart';

enum VideoLength {
  @JsonValue('SHORT')
  short,

  @JsonValue('MEDIUM')
  medium,

  @JsonValue('LONG')
  long,
}