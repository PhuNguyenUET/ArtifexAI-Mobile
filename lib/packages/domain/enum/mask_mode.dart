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

