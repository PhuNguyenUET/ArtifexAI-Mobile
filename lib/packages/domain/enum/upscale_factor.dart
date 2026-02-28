import 'package:freezed_annotation/freezed_annotation.dart';

enum UpscaleFactor {
  @JsonValue('X2')
  x2,
  @JsonValue('X4')
  x4,
  @JsonValue('X6')
  x6,
  @JsonValue('X8')
  x8,
  @JsonValue('X10')
  x10,
}

