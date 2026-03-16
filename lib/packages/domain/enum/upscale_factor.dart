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

extension UpscaleFactorJson on UpscaleFactor {
  String toJson() {
    const map = {
      UpscaleFactor.x2:  'X2',
      UpscaleFactor.x4:  'X4',
      UpscaleFactor.x6:  'X6',
      UpscaleFactor.x8:  'X8',
      UpscaleFactor.x10: 'X10',
    };
    return map[this]!;
  }
}
