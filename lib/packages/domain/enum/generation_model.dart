/// The AI model used for image generation.
enum GenerationModel {
  gemini('', 'Gemini', 'Best quality · Multi-image'),
  flux2('flux2', 'Flux-2', 'Photorealistic · Cinematic'),
  qwen('qwen', 'Qwen', 'Precise prompts · Detail'),
  firered('firered', 'FireRed', 'Edit & style transfer');

  /// The URL path segment inserted between the base path and the operation.
  /// Empty string means no prefix (Gemini — existing behaviour).
  final String pathSegment;

  /// Human-readable display name shown in the UI.
  final String displayName;

  /// Short subtitle shown below the display name.
  final String subtitle;

  const GenerationModel(this.pathSegment, this.displayName, this.subtitle);
}

extension GenerationModelExt on GenerationModel {
  /// Build the full endpoint path for an [operation] (e.g. `'splash_art'`).
  String buildEndpoint(String operation) {
    const base = '/api/image_generation/v1';
    final prefix = pathSegment.isEmpty ? '' : '/$pathSegment';
    return '$base$prefix/$operation';
  }

  /// Whether this model supports splash art (text-to-image).
  bool get supportsSplashArt => this != GenerationModel.firered;

  /// Whether this model requires at least one reference image for edit
  /// operations (variation, sprite sheet, style change).
  bool get requiresReferenceImage => this == GenerationModel.firered;
}

