import 'package:freezed_annotation/freezed_annotation.dart';

enum MaskMode {
  @JsonValue('MASK_MODE_DEFAULT')
  maskModeDefault,
  @JsonValue('MASK_MODE_USER_PROVIDED')
  maskModeUserProvided,
  @JsonValue('MASK_MODE_BACKGROUND')
  maskModeBackground,
  @JsonValue('MASK_MODE_FOREGROUND')
  maskModeForeground,
  @JsonValue('MASK_MODE_SEMANTIC')
  maskModeSemantic,
  @JsonValue('MASK_REFERENCE_MODE_UNSPECIFIED')
  maskReferenceModeUnspecified,
}

extension MaskModeJson on MaskMode {
  String toJson() {
    const map = {
      MaskMode.maskModeDefault:              'MASK_MODE_DEFAULT',
      MaskMode.maskModeUserProvided:         'MASK_MODE_USER_PROVIDED',
      MaskMode.maskModeBackground:           'MASK_MODE_BACKGROUND',
      MaskMode.maskModeForeground:           'MASK_MODE_FOREGROUND',
      MaskMode.maskModeSemantic:             'MASK_MODE_SEMANTIC',
      MaskMode.maskReferenceModeUnspecified: 'MASK_REFERENCE_MODE_UNSPECIFIED',
    };
    return map[this]!;
  }
}
