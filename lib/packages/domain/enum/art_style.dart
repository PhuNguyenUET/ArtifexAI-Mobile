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