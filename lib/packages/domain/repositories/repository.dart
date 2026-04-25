import '../../index.dart';

abstract class Repository {
  static Local get local => Local.instance;

  static NetworkSrc createNetworkSrc({required Local local}) {
    return NetworkSrc.instance();
  }

  static Future<Repository> createRepository({
    required AppEvent appEvent,
    required Local local,
  }) async {
    NetworkSrc networkSrc = createNetworkSrc(local: local);

    final apiService = ApiServiceImpl.instance(networkSrc.dioService,
        networkSrc.downloadDioService, networkSrc.commonDioService);

    return RepositoryImpl.instance(apiService: apiService);
  }

  // ─── User ────────────────────────────────────────────────────────────────────
  Future<void> editUser({String? firstName, String? lastName, String? dateOfBirth});
  Future<void> changePassword({required String oldPassword, required String newPassword});
  Future<void> forgotPassword({required String email});
  Future<void> validateEmail();
  Future<void> emailToken({required String token});
  Future<void> createNewPassword({required String token, required String password});
  Future<UserDto> currentUser();

  // ─── Project Management ───────────────────────────────────────────────────────
  Future<void> updateInstructions({required int projectId, required List<String> instructions});
  Future<void> addInstructions({required int projectId, required String newInstruction});
  Future<void> editProject({required int projectId, String? projectName, ArtStyle? artStyle});
  Future<ProjectDto> createProject({required String projectName, required String instructions, required ArtStyle artStyle});
  Future<ProjectDto> getProjectById({required int projectId});
  Future<List<ProjectDto>> getAllProjects();
  Future<void> deleteProject({required int projectId});

  // ─── Album Management ─────────────────────────────────────────────────────────
  Future<void> editAlbum({required int albumId, String? albumName});
  Future<void> deleteMediaFromAlbum({required int albumId, required int mediaId});
  Future<void> addMedia({required int albumId, required int mediaId});
  Future<AlbumDto> createAlbum({required String name, required List<int> mediaIds});
  Future<AlbumDto> getAlbumById({required int albumId});
  Future<List<AlbumDto>> getAllAlbums();
  Future<void> deleteAlbum({required int albumId});

  // ─── Video Generation ─────────────────────────────────────────────────────────
  Future<VideoResponseDto> generateVideo({
    required int projectId,
    ReferenceImage? referenceImage,
    required String prompt,
    required VideoLength videoLength,
  });

  // ─── User Authentication ──────────────────────────────────────────────────────
  Future<void> register({required String email, required String password});
  Future<String> refreshJwt({required String refreshToken});
  Future<void> jwtCheck();
  Future<AuthenticationResponseDto> authenticate({required String email, required String password});
  Future<AuthenticationResponseDto> authenticateOAuthGoogle();
  Future<AuthenticationResponseDto> authenticateOAuthGithub();

  // ─── Media Management ─────────────────────────────────────────────────────────
  Future<MediaDto> uploadClient({required String base64, required MimeType mimeType});
  Future<MediaDto> getMediaById({required int id});
  Future<List<MediaDto>> getMediasByAlbum({required int albumId});
  Future<List<MediaDto>> getGallery();
  Future<void> deleteMedia({required int mediaId});

  // ─── Image Generation ─────────────────────────────────────────────────────────
  Future<ImageResponseDto> imageVariation({
    required int projectId,
    List<ReferenceImage> imageInfos,
    required String prompt,
    GenerationModel model,
  });
  Future<ImageResponseDto> imageUpscale({
    required int projectId,
    required ReferenceImage imageInfo,
    required UpscaleFactor upscaleFactor,
  });
  Future<ImageResponseDto> imageStyleChange({
    required int projectId,
    required ReferenceImage imageInfo,
    required ArtStyle targetedStyle,
    required String additionalPrompts,
    GenerationModel model,
  });
  Future<ImageResponseDto> imageSpriteSheet({
    required int projectId,
    String? characterDescription,
    String? actionDescription,
    required List<ReferenceImage> imageInfos,
    GenerationModel model,
  });
  Future<ImageResponseDto> splashArt({
    required int projectId,
    required String splashDescription,
    GenerationModel model,
  });
  Future<ImageResponseDto> imageMaskedEdit({
    required int projectId,
    required ReferenceImage imageInfo,
    required String maskImageBase64,
    String? prompt,
    required EditMode editMode,
  });
}
