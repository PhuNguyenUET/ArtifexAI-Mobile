import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../packages/domain/index.dart';

part 'project_state.freezed.dart';

enum GenerationMode {
  splashArt,
  variation,
  styleChange,
  spriteSheet,
  upscale,
  video,
}

extension GenerationModeExt on GenerationMode {
  String get label {
    switch (this) {
      case GenerationMode.splashArt:   return 'Splash Art';
      case GenerationMode.variation:   return 'Variation';
      case GenerationMode.styleChange: return 'Style Change';
      case GenerationMode.spriteSheet: return 'Sprite Sheet';
      case GenerationMode.upscale:     return 'Upscale';
      case GenerationMode.video:       return 'Video';
    }
  }

  IconData get icon {
    switch (this) {
      case GenerationMode.splashArt:   return Icons.auto_awesome_rounded;
      case GenerationMode.variation:   return Icons.burst_mode_rounded;
      case GenerationMode.styleChange: return Icons.color_lens_rounded;
      case GenerationMode.spriteSheet: return Icons.view_module_rounded;
      case GenerationMode.upscale:     return Icons.hd_rounded;
      case GenerationMode.video:       return Icons.videocam_rounded;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case GenerationMode.splashArt:   return [Color(0xFFEE85FF), Color(0xFF89B8FF)];
      case GenerationMode.variation:   return [Color(0xFF43e97b), Color(0xFF38f9d7)];
      case GenerationMode.styleChange: return [Color(0xFFfa709a), Color(0xFFfee140)];
      case GenerationMode.spriteSheet: return [Color(0xFF659EED), Color(0xFF65DDED)];
      case GenerationMode.upscale:     return [Color(0xFFf093fb), Color(0xFFf5576c)];
      case GenerationMode.video:       return [Color(0xFFFF6B6B), Color(0xFFFFE66D)];
    }
  }


  bool get requiresPrompt {
    switch (this) {
      case GenerationMode.upscale:     return false;
      case GenerationMode.spriteSheet: return false;
      case GenerationMode.video:       return false;
      case GenerationMode.styleChange: return false;
      default: return true;
    }
  }

  /// 0 = none, -1 = zero-or-more, 1 = exactly one
  int get imageCount {
    switch (this) {
      case GenerationMode.splashArt:   return 0;
      case GenerationMode.variation:   return -1;
      case GenerationMode.styleChange: return 1;
      case GenerationMode.spriteSheet: return -1;
      case GenerationMode.upscale:     return 1;
      case GenerationMode.video:       return -1; // 0 or 1 optional
    }
  }

  bool get requiresImage => imageCount != 0;
}

@freezed
abstract class ProjectState with _$ProjectState {
  const factory ProjectState({
    @Default(GenerationMode.splashArt) GenerationMode mode,
    @Default(GenerationModel.gpt) GenerationModel generationModel,
    @Default(false) bool generating,
    @Default(false) bool done,
    ImageResponseDto? result,
    VideoResponseDto? videoResult,
    String? error,
    // ─── Instructions ─────────────────────────────────────────────────────────
    @Default([]) List<String> instructions,
    @Default(false) bool addingInstruction,
    @Default(false) bool updatingInstructions,
  }) = _ProjectState;
}
