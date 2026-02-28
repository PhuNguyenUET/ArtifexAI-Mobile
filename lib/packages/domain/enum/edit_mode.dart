import 'package:freezed_annotation/freezed_annotation.dart';

enum EditMode {
  @JsonValue('EDIT_MODE_DEFAULT')
  editModeDefault,
  @JsonValue('EDIT_MODE_INPAINT_REMOVAL')
  editModeInpaintRemoval,
  @JsonValue('EDIT_MODE_INPAINT_INSERTION')
  editModeInpaintInsertion,
  @JsonValue('EDIT_MODE_OUTPAINT')
  editModeOutpaint,
  @JsonValue('EDIT_MODE_CONTROLLED_EDITING')
  editModeControlledEditing,
  @JsonValue('EDIT_MODE_STYLE')
  editModeStyle,
  @JsonValue('EDIT_MODE_BGSWAP')
  editModeBgswap,
  @JsonValue('EDIT_MODE_PRODUCT_IMAGE')
  editModeProductImage,
  @JsonValue('EDIT_MODE_UNSPECIFIED')
  editModeUnspecified,
}

