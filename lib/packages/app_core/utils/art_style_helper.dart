import 'package:flutter/material.dart';
import 'package:artifex_ai_mobile/packages/domain/enum/art_style.dart';

class ArtStyleMeta {
  const ArtStyleMeta({
    required this.label,
    required this.icon,
    required this.colors,
  });

  final String label;

  final IconData icon;

  final List<Color> colors;
}

class ArtStyleHelper {
  const ArtStyleHelper._();

  static const Map<ArtStyle, ArtStyleMeta> _map = {
    ArtStyle.pixelated: ArtStyleMeta(
      label: 'Pixel Art',
      icon: Icons.grid_on,
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    ArtStyle.handDrawn: ArtStyleMeta(
      label: 'Hand Drawn',
      icon: Icons.brush_outlined,
      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    ArtStyle.minimalist: ArtStyleMeta(
      label: 'Minimalist',
      icon: Icons.crop_square,
      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    ArtStyle.anime: ArtStyleMeta(
      label: 'Anime',
      icon: Icons.face_retouching_natural,
      colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
    ),
    ArtStyle.cartoon: ArtStyleMeta(
      label: 'Cartoon',
      icon: Icons.emoji_emotions_outlined,
      colors: [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
    ArtStyle.realistic: ArtStyleMeta(
      label: 'Realistic',
      icon: Icons.landscape_outlined,
      colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    ),
    ArtStyle.hyperRealistic: ArtStyleMeta(
      label: 'Hyper-Realistic',
      icon: Icons.hd_outlined,
      colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
    ),
    ArtStyle.custom: ArtStyleMeta(
      label: 'Custom',
      icon: Icons.tune,
      colors: [Color(0xFF96fbc4), Color(0xFFf9f586)],
    ),
  };

  static const ArtStyleMeta _fallback = ArtStyleMeta(
    label: 'Unknown',
    icon: Icons.auto_awesome,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );

  static ArtStyleMeta of(ArtStyle? style) =>
      style != null ? (_map[style] ?? _fallback) : _fallback;

  static List<MapEntry<ArtStyle, ArtStyleMeta>> get all =>
      _map.entries.toList();
}

