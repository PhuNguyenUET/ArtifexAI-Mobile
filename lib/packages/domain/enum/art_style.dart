import 'package:freezed_annotation/freezed_annotation.dart';

enum ArtStyle {
  @JsonValue('PIXELATED')
  pixelated,
  @JsonValue('HAND_DRAWN')
  handDrawn,
  @JsonValue('MINIMALIST')
  minimalist,
  @JsonValue('ANIME')
  anime,
  @JsonValue('CARTOON')
  cartoon,
  @JsonValue('REALISTIC')
  realistic,
  @JsonValue('HYPER_REALISTIC')
  hyperRealistic,
  @JsonValue('CUSTOM')
  custom,
}

extension ArtStyleJson on ArtStyle {
  String toJson() {
    const map = {
      ArtStyle.pixelated:      'PIXELATED',
      ArtStyle.handDrawn:      'HAND_DRAWN',
      ArtStyle.minimalist:     'MINIMALIST',
      ArtStyle.anime:          'ANIME',
      ArtStyle.cartoon:        'CARTOON',
      ArtStyle.realistic:      'REALISTIC',
      ArtStyle.hyperRealistic: 'HYPER_REALISTIC',
      ArtStyle.custom:         'CUSTOM',
    };
    return map[this]!;
  }
}
