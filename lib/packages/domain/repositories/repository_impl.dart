import '../../index.dart';

class RepositoryImpl extends Repository {
  static Repository instance({required ApiService apiService}) {
    return RepositoryImpl(apiService);
  }

  RepositoryImpl(ApiService apiService) : _apiService = apiService;

  final ApiService _apiService;

  // ─── User ────────────────────────────────────────────────────────────────────

  @override
  Future<void> editUser({String? firstName, String? lastName, String? dateOfBirth}) =>
      _apiService.editUser(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth);

  @override
  Future<void> changePassword({required String oldPassword, required String newPassword}) =>
      _apiService.changePassword(oldPassword: oldPassword, newPassword: newPassword);

  @override
  Future<void> forgotPassword({required String email}) =>
      _apiService.forgotPassword(email: email);

  @override
  Future<void> validateEmail() => _apiService.validateEmail();

  @override
  Future<void> emailToken() => _apiService.emailToken();

  @override
  Future<void> createNewPassword({required String token, required String password}) =>
      _apiService.createNewPassword(token: token, password: password);

  @override
  Future<UserDto> currentUser() => _apiService.currentUser();

  // ─── Project Management ───────────────────────────────────────────────────────

  @override
  Future<void> updateInstructions({required String projectId, required List<String> instructions}) =>
      _apiService.updateInstructions(projectId: projectId, instructions: instructions);

  @override
  Future<void> addInstructions({required String projectId, required String newInstruction}) =>
      _apiService.addInstructions(projectId: projectId, newInstruction: newInstruction);

  @override
  Future<void> editProject({required String projectId, String? projectName, ArtStyle? artStyle}) =>
      _apiService.editProject(projectId: projectId, projectName: projectName, artStyle: artStyle);

  @override
  Future<ProjectDto> createProject({required String projectName, required String? instructions, required ArtStyle artStyle}) =>
      _apiService.createProject(projectName: projectName, instructions: instructions, artStyle: artStyle);

  @override
  Future<ProjectDto> getProjectById({required String projectId}) =>
      _apiService.getProjectById(projectId: projectId);

  @override
  Future<List<ProjectDto>> getAllProjects() => _apiService.getAllProjects();

  @override
  Future<void> deleteProject({required String projectId}) =>
      _apiService.deleteProject(projectId: projectId);

  // ─── Album Management ─────────────────────────────────────────────────────────

  @override
  Future<void> editAlbum({required String albumId, String? albumName}) =>
      _apiService.editAlbum(albumId: albumId, albumName: albumName);

  @override
  Future<void> deleteMediaFromAlbum({required String albumId, required String mediaId}) =>
      _apiService.deleteMediaFromAlbum(albumId: albumId, mediaId: mediaId);

  @override
  Future<void> addMedia({required String albumId, required String mediaId}) =>
      _apiService.addMedia(albumId: albumId, mediaId: mediaId);

  @override
  Future<AlbumDto> createAlbum({required String name, required List<String> mediaIds}) =>
      _apiService.createAlbum(name: name, mediaIds: mediaIds);

  @override
  Future<AlbumDto> getAlbumById({required String albumId}) =>
      _apiService.getAlbumById(albumId: albumId);

  @override
  Future<List<AlbumDto>> getAllAlbums() => _apiService.getAllAlbums();

  @override
  Future<void> deleteAlbum({required String albumId}) =>
      _apiService.deleteAlbum(albumId: albumId);

  // ─── Video Generation ─────────────────────────────────────────────────────────

  @override
  Future<VideoResponseDto> generateVideo({
    required String projectId,
    ReferenceImage? referenceImage,
    required String prompt,
    required VideoLength videoLength,
  }) => _apiService.generateVideo(
        projectId: projectId,
        referenceImage: referenceImage,
        prompt: prompt,
        videoLength: videoLength,
      );

  // ─── User Authentication ──────────────────────────────────────────────────────

  @override
  Future<void> register({required String email, required String password}) =>
      _apiService.register(email: email, password: password);

  @override
  Future<String> refreshJwt({required String refreshToken}) =>
      _apiService.refreshJwt(refreshToken: refreshToken);

  @override
  Future<void> jwtCheck() => _apiService.jwtCheck();

  @override
  Future<AuthenticationResponseDto> authenticate({required String email, required String password}) =>
      _apiService.authenticate(email: email, password: password);

  @override
  Future<AuthenticationResponseDto> authenticateOAuthGoogle() =>
      _apiService.authenticateOAuthGoogle();

  @override
  Future<AuthenticationResponseDto> authenticateOAuthGithub() =>
      _apiService.authenticateOAuthGithub();

  // ─── Media Management ─────────────────────────────────────────────────────────

  @override
  Future<void> uploadClient({required String base64, required MimeType mimeType}) =>
      _apiService.uploadClient(base64: base64, mimeType: mimeType);

  @override
  Future<MediaDto> getMediaById({required String id}) =>
      _apiService.getMediaById(id: id);

  @override
  Future<List<MediaDto>> getMediasByAlbum({required String albumId}) =>
      _apiService.getMediasByAlbum(albumId: albumId);

  @override
  Future<List<MediaDto>> getGallery() => _apiService.getGallery();

  @override
  Future<void> deleteMedia({required String mediaId}) =>
      _apiService.deleteMedia(mediaId: mediaId);

  // ─── Image Generation ─────────────────────────────────────────────────────────

  @override
  Future<ImageResponseDto> imageVariation({
    required String projectId,
    List<ReferenceImage> imageInfos = const [],
    required String prompt,
  }) => _apiService.imageVariation(
        projectId: projectId,
        imageInfos: imageInfos,
        prompt: prompt,
      );

  @override
  Future<ImageResponseDto> imageUpscale({
    required String projectId,
    required ReferenceImage imageInfo,
    required UpscaleFactor upscaleFactor,
  }) => _apiService.imageUpscale(
        projectId: projectId,
        imageInfo: imageInfo,
        upscaleFactor: upscaleFactor,
      );

  @override
  Future<ImageResponseDto> imageStyleChange({
    required String projectId,
    required ReferenceImage imageInfo,
    required ArtStyle targetedStyle,
    required String additionalPrompts,
  }) => _apiService.imageStyleChange(
        projectId: projectId,
        imageInfo: imageInfo,
        targetedStyle: targetedStyle,
        additionalPrompts: additionalPrompts,
      );

  @override
  Future<ImageResponseDto> imageSpriteSheet({
    required String projectId,
    String? characterDescription,
    String? actionDescription,
    required List<ReferenceImage> imageInfos,
  }) => _apiService.imageSpriteSheet(
        projectId: projectId,
        characterDescription: characterDescription,
        actionDescription: actionDescription,
        imageInfos: imageInfos,
      );

  @override
  Future<ImageResponseDto> splashArt({
    required String projectId,
    required String splashDescription,
  }) => _apiService.splashArt(
        projectId: projectId,
        splashDescription: splashDescription,
      );

  @override
  Future<ImageResponseDto> imageMaskedEdit({
    required String projectId,
    required ReferenceImage imageInfo,
    required String maskImageBase64,
    String? prompt,
    required EditMode editMode,
    required MaskMode maskReferenceMode,
  }) => _apiService.imageMaskedEdit(
        projectId: projectId,
        imageInfo: imageInfo,
        maskImageBase64: maskImageBase64,
        prompt: prompt,
        editMode: editMode,
        maskReferenceMode: maskReferenceMode,
      );
}
