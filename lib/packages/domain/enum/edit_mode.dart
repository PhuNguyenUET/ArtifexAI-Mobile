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

extension EditModeJson on EditMode {
  String toJson() {
    const map = {
      EditMode.editModeDefault:            'EDIT_MODE_DEFAULT',
      EditMode.editModeInpaintRemoval:     'EDIT_MODE_INPAINT_REMOVAL',
      EditMode.editModeInpaintInsertion:   'EDIT_MODE_INPAINT_INSERTION',
      EditMode.editModeOutpaint:           'EDIT_MODE_OUTPAINT',
      EditMode.editModeControlledEditing:  'EDIT_MODE_CONTROLLED_EDITING',
      EditMode.editModeStyle:              'EDIT_MODE_STYLE',
      EditMode.editModeBgswap:             'EDIT_MODE_BGSWAP',
      EditMode.editModeProductImage:       'EDIT_MODE_PRODUCT_IMAGE',
      EditMode.editModeUnspecified:        'EDIT_MODE_UNSPECIFIED',
    };
    return map[this]!;
  }
}
