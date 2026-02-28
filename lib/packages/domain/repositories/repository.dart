import '../../index.dart';

abstract class Repository {
  static Local get local => Local.instance;

  // ─── User ────────────────────────────────────────────────────────────────────
  Future<void> editUser({String? firstName, String? lastName, String? dateOfBirth});
  Future<void> changePassword({required String oldPassword, required String newPassword});
  Future<void> forgotPassword({required String email});
  Future<void> validateEmail();
  Future<void> emailToken();
  Future<void> createNewPassword({required String token, required String password});
  Future<UserDto> currentUser();

  // ─── Project Management ───────────────────────────────────────────────────────
  Future<void> updateInstructions({required String projectId, required List<String> instructions});
  Future<void> addInstructions({required String projectId, required String newInstruction});
  Future<void> editProject({required String projectId, String? projectName, ArtStyle? artStyle});
  Future<ProjectDto> createProject({required String projectName, required String? instructions, required ArtStyle artStyle});
  Future<ProjectDto> getProjectById({required String projectId});
  Future<List<ProjectDto>> getAllProjects();
  Future<void> deleteProject({required String projectId});

  // ─── Album Management ─────────────────────────────────────────────────────────
  Future<void> editAlbum({required String albumId, String? albumName});
  Future<void> deleteMediaFromAlbum({required String albumId, required String mediaId});
  Future<void> addMedia({required String albumId, required String mediaId});
  Future<AlbumDto> createAlbum({required String name, required List<String> mediaIds});
  Future<AlbumDto> getAlbumById({required String albumId});
  Future<List<AlbumDto>> getAllAlbums();
  Future<void> deleteAlbum({required String albumId});

  // ─── Video Generation ─────────────────────────────────────────────────────────
  Future<VideoResponseDto> generateVideo({
    required String projectId,
    ReferenceImage? referenceImage,
    required String prompt,
    required VideoLength videoLength,
  });

  // ─── User Authentication ──────────────────────────────────────────────────────
  Future<void> register({required String email, required String password});
  Future<String> refreshJwt({required String refreshToken});
  Future<AuthenticationResponseDto> authenticate({required String email, required String password});
  Future<AuthenticationResponseDto> authenticateOAuthGoogle();
  Future<AuthenticationResponseDto> authenticateOAuthGithub();

  // ─── Media Management ─────────────────────────────────────────────────────────
  Future<void> uploadClient({required String base64, required MimeType mimeType});
  Future<MediaDto> getMediaById({required String id});
  Future<List<MediaDto>> getMediasByAlbum({required String albumId});
  Future<List<MediaDto>> getGallery();
  Future<void> deleteMedia({required String mediaId});

  // ─── Image Generation ─────────────────────────────────────────────────────────
  Future<ImageResponseDto> imageVariation({
    required String projectId,
    List<ReferenceImage> imageInfos,
    required String prompt,
    required int numberOfOutputs,
  });
  Future<ImageResponseDto> imageUpscale({
    required String projectId,
    required ReferenceImage imageInfo,
    required UpscaleFactor upscaleFactor,
  });
  Future<ImageResponseDto> imageStyleChange({
    required String projectId,
    required ReferenceImage imageInfo,
    required ArtStyle targetedStyle,
    required String additionalPrompts,
    required int numberOfOutputs,
  });
  Future<ImageResponseDto> imageSpriteSheet({
    required String projectId,
    String? characterDescription,
    String? actionDescription,
    required List<ReferenceImage> imageInfos,
    required int numberOfOutputs,
  });
  Future<ImageResponseDto> splashArt({
    required String projectId,
    required String splashDescription,
    required int numberOfOutputs,
  });
  Future<ImageResponseDto> imageMaskedEdit({
    required String projectId,
    required ReferenceImage imageInfo,
    required String maskImageBase64,
    String? prompt,
    required EditMode editMode,
    required MaskMode maskReferenceMode,
    required int numberOfOutputs,
  });
}
