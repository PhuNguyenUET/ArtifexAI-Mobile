import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import 'project_state.dart';

class ProjectController extends Cubit<ProjectState> {
  ProjectController() : super(const ProjectState());

  final _storage = sl.get<AccessTokenStorage>();

  void setMode(GenerationMode mode) =>
      emit(ProjectState(mode: mode, instructions: state.instructions));

  void clearResult() =>
      emit(ProjectState(mode: state.mode, instructions: state.instructions));

  // ─── Instructions ─────────────────────────────────────────────────────────

  void loadInstructions(List<String> instructions) {
    emit(state.copyWith(instructions: List.unmodifiable(instructions)));
  }

  Future<void> deleteInstruction({
    required String projectId,
    required int index,
    void Function(String)? onError,
  }) async {
    final updated = List<String>.from(state.instructions)..removeAt(index);
    emit(state.copyWith(updatingInstructions: true));
    try {
      await _storage.repository.updateInstructions(
        projectId: projectId,
        instructions: updated,
      );
      emit(state.copyWith(instructions: updated, updatingInstructions: false));
    } on CustomException catch (e) {
      emit(state.copyWith(updatingInstructions: false));
      onError?.call(e.message);
    } catch (_) {
      emit(state.copyWith(updatingInstructions: false));
      onError?.call('Failed to delete instruction. Please try again.');
    }
  }

  Future<void> addInstruction({
    required String projectId,
    required String newInstruction,
    void Function(String)? onError,
  }) async {
    emit(state.copyWith(addingInstruction: true));
    try {
      await _storage.repository.addInstructions(
        projectId: projectId,
        newInstruction: newInstruction,
      );
      // Reload the project to get the AI-updated instruction list
      final updated = await _storage.repository.getProjectById(projectId: projectId);
      emit(state.copyWith(
        addingInstruction: false,
        instructions: List.unmodifiable(updated.instructions ?? []),
      ));
    } on CustomException catch (e) {
      emit(state.copyWith(addingInstruction: false));
      onError?.call(e.message);
    } catch (_) {
      emit(state.copyWith(addingInstruction: false));
      onError?.call('Failed to add instruction. Please try again.');
    }
  }


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
          );
          break;
        case GenerationMode.variation:
          result = await _storage.repository.imageVariation(
            projectId: projectId,
            imageInfos: variationImages ?? [],
            prompt: variationPrompt ?? '',
          );
          break;
        case GenerationMode.styleChange:
          result = await _storage.repository.imageStyleChange(
            projectId: projectId,
            imageInfo: styleImage!,
            targetedStyle: targetedStyle!,
            additionalPrompts: additionalPrompts ?? '',
          );
          break;
        case GenerationMode.spriteSheet:
          result = await _storage.repository.imageSpriteSheet(
            projectId: projectId,
            characterDescription: characterDescription,
            actionDescription: actionDescription,
            imageInfos: spriteImages ?? [],
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
