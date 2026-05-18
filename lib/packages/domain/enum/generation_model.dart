enum GenerationModel {
  gpt('gpt', 'ChatGPT', 'GPT-Image-2 · Natural language'),
  gemini('', 'Gemini', 'Best quality · Multi-image'),
  flux2('flux2', 'Flux-2', 'Photorealistic · Cinematic'),
  qwen('qwen', 'Qwen', 'Precise prompts · Detail');

  final String pathSegment;

  final String displayName;

  final String subtitle;

  const GenerationModel(this.pathSegment, this.displayName, this.subtitle);
}

extension GenerationModelExt on GenerationModel {
  String buildEndpoint(String operation) {
    const base = '/api/image_generation/v1';
    final prefix = pathSegment.isEmpty ? '' : '/$pathSegment';
    return '$base$prefix/$operation';
  }

  bool get supportsSplashArt => true;

  bool get requiresReferenceImage => false;
}

