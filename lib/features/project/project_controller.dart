import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import 'project_state.dart';

class ProjectController extends Cubit<ProjectState> {
  ProjectController() : super(const ProjectState());

  final _storage = sl.get<AccessTokenStorage>();

  void setMode(GenerationMode mode) =>
      emit(ProjectState(mode: mode));

  void clearResult() =>
      emit(ProjectState(mode: state.mode));

  Future<void> generate({
    required GenerationMode mode,
    required String projectId,
    String? splashDescription,
    String? variationPrompt,
    List<ReferenceImage>? variationImages,
    ReferenceImage? styleImage,
    ArtStyle? targetedStyle,
    String? additionalPrompts,
    String? characterDescription,
    String? actionDescription,
    List<ReferenceImage>? spriteImages,
    ReferenceImage? upscaleImage,
    UpscaleFactor? upscaleFactor,
    // Video
    String? videoPrompt,
    ReferenceImage? videoReferenceImage,
    VideoLength videoLength = VideoLength.medium,
    int numberOfOutputs = 1,
    void Function(String)? onError,
  }) async {
    emit(ProjectState(mode: mode, generating: true));
    try {
      if (mode == GenerationMode.video) {
        final videoResult = await _storage.repository.generateVideo(
          projectId: projectId,
          referenceImage: videoReferenceImage,
          prompt: videoPrompt ?? '',
          videoLength: videoLength,
        );
        emit(ProjectState(mode: mode, done: true, videoResult: videoResult));
        return;
      }

      late ImageResponseDto result;
      switch (mode) {
        case GenerationMode.splashArt:
          result = await _storage.repository.splashArt(
            projectId: projectId,
            splashDescription: splashDescription ?? '',
            numberOfOutputs: numberOfOutputs,
          );
          break;
        case GenerationMode.variation:
          result = await _storage.repository.imageVariation(
            projectId: projectId,
            imageInfos: variationImages ?? [],
            prompt: variationPrompt ?? '',
            numberOfOutputs: numberOfOutputs,
          );
          break;
        case GenerationMode.styleChange:
          result = await _storage.repository.imageStyleChange(
            projectId: projectId,
            imageInfo: styleImage!,
            targetedStyle: targetedStyle!,
            additionalPrompts: additionalPrompts ?? '',
            numberOfOutputs: numberOfOutputs,
          );
          break;
        case GenerationMode.spriteSheet:
          result = await _storage.repository.imageSpriteSheet(
            projectId: projectId,
            characterDescription: characterDescription,
            actionDescription: actionDescription,
            imageInfos: spriteImages ?? [],
            numberOfOutputs: numberOfOutputs,
          );
          break;
        case GenerationMode.upscale:
          result = await _storage.repository.imageUpscale(
            projectId: projectId,
            imageInfo: upscaleImage!,
            upscaleFactor: upscaleFactor ?? UpscaleFactor.x2,
          );
          break;
        case GenerationMode.video:
          break; // handled above
      }
      emit(ProjectState(mode: mode, done: true, result: result));
    } on CustomException catch (e) {
      emit(ProjectState(mode: mode, error: e.message));
      onError?.call(e.message);
    } catch (_) {
      const msg = 'Generation failed. Please try again.';
      emit(ProjectState(mode: mode, error: msg));
      onError?.call(msg);
    }
  }
}
