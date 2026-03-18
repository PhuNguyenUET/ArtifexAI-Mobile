import '../../index.dart';

class ApiServiceImpl extends ApiService {
  static ApiService instance(DioService dioService, DioService downloadService,
      DioService commonService) {
    return ApiServiceImpl(dioService, downloadService, commonService);
  }

  ApiServiceImpl(DioService dioService, DioService downloadService,
      DioService commonService)
      : _dioService = dioService,
        _downloadService = downloadService,
        _commonService = commonService;

  final DioService _dioService;
  final DioService _downloadService;
  final DioService _commonService;

  // ─── User ────────────────────────────────────────────────────────────────────

  @override
  Future<void> editUser({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
  }) async {
    await _dioService.put(
      endpoint: '/api/user/v1/edit',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
      },
    );
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _dioService.put(
      endpoint: '/api/user/v1/change_password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dioService.post(
      endpoint: '/api/user/v1/forgot_password',
      data: email,
    );
  }

  @override
  Future<void> validateEmail() async {
    await _dioService.post(
      endpoint: '/api/user/v1/email/validate',
    );
  }

  @override
  Future<void> emailToken() async {
    await _dioService.post(
      endpoint: '/api/user/v1/email/validate',
    );
  }

  @override
  Future<void> createNewPassword({
    required String token,
    required String password,
  }) async {
    await _dioService.post(
      endpoint: '/api/user/v1/create_new_password',
      data: {
        'token': token,
        'password': password,
      },
    );
  }

  @override
  Future<UserDto> currentUser() async {
    final userDto = await _dioService.get(
      endpoint: '/api/user/v1/current_user',
    );
    return UserDto.fromJson(userDto);
  }

  // ─── Project Management ───────────────────────────────────────────────────────

  @override
  Future<void> updateInstructions({
    required String projectId,
    required List<String> instructions,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/update_instructions',
      data: {
        'projectId': projectId,
        'instructions': instructions,
        'newInstruction': ''
      },
    );
  }

  @override
  Future<void> addInstructions({
    required String projectId,
    required String newInstruction,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/add_instructions',
      data: {
        'projectId': projectId,
        'instruction': [],
        'newInstruction': newInstruction
      },
    );
  }

  @override
  Future<void> editProject({
    required String projectId,
    String? projectName,
    ArtStyle? artStyle,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/edit',
      data: {
        'projectName': projectName ?? '',
        'artStyle': artStyle?.toJson(),
      },
    );
  }

  @override
  Future<ProjectDto> createProject({
    required String projectName,
    required String? instructions,
    required ArtStyle artStyle,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/project/v1/create',
      data: {
        'projectName': projectName,
        'instructions': instructions,
        'artStyle': artStyle.toJson(),
      },
    );
    return ProjectDto.fromJson(json);
  }

  @override
  Future<ProjectDto> getProjectById({required String projectId}) async {
    final json = await _dioService.get(
      endpoint: '/api/project/v1/get_by_id',
      queryParams: {'projectId': projectId},
    );
    return ProjectDto.fromJson(json);
  }

  @override
  Future<List<ProjectDto>> getAllProjects() async {
    final list = await _dioService.getList(
      endpoint: '/api/project/v1/get_all',
    );
    return list.map((e) => ProjectDto.fromJson(e as JSON)).toList();
  }

  @override
  Future<void> deleteProject({required String projectId}) async {
    await _dioService.delete(
      endpoint: '/api/project/v1/delete',
      queryParams: {'projectId': projectId},
    );
  }

  // ─── Album Management ─────────────────────────────────────────────────────────

  @override
  Future<void> editAlbum({
    required String albumId,
    String? albumName,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/edit',
      data: {
        'albumId': albumId,
        'albumName': albumName
      },
    );
  }

  @override
  Future<void> deleteMediaFromAlbum({
    required String albumId,
    required String mediaId,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/delete_image',
      data: {
        'albumId': albumId,
        'mediaId': mediaId
      },
    );
  }

  @override
  Future<void> addMedia({
    required String albumId,
    required String mediaId,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/add_image',
      data: {
        'albumId': albumId,
        'mediaId': mediaId
      },
    );
  }

  @override
  Future<AlbumDto> createAlbum({
    required String name,
    required List<String> mediaIds,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/album/v1/create',
      data: {
        'name': name,
        'mediaIds': mediaIds,
      },
    );
    return AlbumDto.fromJson(json);
  }

  @override
  Future<AlbumDto> getAlbumById({required String albumId}) async {
    final json = await _dioService.get(
      endpoint: '/api/album/v1/get_by_id',
      queryParams: {'albumId': albumId},
    );
    return AlbumDto.fromJson(json);
  }

  @override
  Future<List<AlbumDto>> getAllAlbums() async {
    final list = await _dioService.getList(
      endpoint: '/api/album/v1/get_all',
    );
    return list.map((e) => AlbumDto.fromJson(e as JSON)).toList();
  }

  @override
  Future<void> deleteAlbum({required String albumId}) async {
    await _dioService.delete(
      endpoint: '/api/album/v1/delete',
      queryParams: {'albumId': albumId},
    );
  }

  // ─── Video Generation ─────────────────────────────────────────────────────────

  @override
  Future<VideoResponseDto> generateVideo({
    required String projectId,
    ReferenceImage? referenceImage,
    required String prompt,
    required VideoLength videoLength,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/video_generation/v1/generate',
      data: {
        'projectId': projectId,
        'referenceImage': referenceImage?.toJson(),
        'prompt': prompt,
        'videoLength': videoLength.toJson(),
      },
    );
    return VideoResponseDto.fromJson(json);
  }

  // ─── User Authentication ──────────────────────────────────────────────────────

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _dioService.post(
      endpoint: '/api/user/v1/register',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<String> refreshJwt({required String refreshToken}) async {
    return await _dioService.postString(
      endpoint: '/api/user/v1/refresh_jwt',
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> jwtCheck() async {
    await _dioService.getRaw(
      endpoint: '/jwt_check',
    );
  }

  @override
  Future<AuthenticationResponseDto> authenticate({
    required String email,
    required String password,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/user/v1/authenticate',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthenticationResponseDto.fromJson(json);
  }

  @override
  Future<AuthenticationResponseDto> authenticateOAuthGoogle() async {
    final json = await _dioService.post(
      endpoint: '/api/user/v1/oauth/google',
    );
    return AuthenticationResponseDto.fromJson(json);
  }

  @override
  Future<AuthenticationResponseDto> authenticateOAuthGithub() async {
    final json = await _dioService.post(
      endpoint: '/api/user/v1/oauth/github',
    );
    return AuthenticationResponseDto.fromJson(json);
  }

  // ─── Media Management ─────────────────────────────────────────────────────────

  @override
  Future<void> uploadClient({
    required String base64,
    required MimeType mimeType,
  }) async {
    await _dioService.post(
      endpoint: '/api/media/v1/upload_image_client',
      data: {
        'base64': base64,
        'mimeType': mimeType.toJson(),
      },
    );
  }

  @override
  Future<MediaDto> getMediaById({required String id}) async {
    final json = await _dioService.get(
      endpoint: '/api/media/v1/get_by_id',
      queryParams: {'mediaId': id},
    );
    return MediaDto.fromJson(json);
  }

  @override
  Future<List<MediaDto>> getMediasByAlbum({required String albumId}) async {
    final list = await _dioService.getList(
      endpoint: '/api/media/v1/get_by_album',
      queryParams: {'albumId': albumId},
    );
    return list.map((e) => MediaDto.fromJson(e as JSON)).toList();
  }

  @override
  Future<List<MediaDto>> getGallery() async {
    final list = await _dioService.getList(
      endpoint: '/api/media/v1/gallery',
    );
    return list.map((e) => MediaDto.fromJson(e as JSON)).toList();
  }

  @override
  Future<void> deleteMedia({required String mediaId}) async {
    await _dioService.delete(
      endpoint: '/api/media/v1/delete',
      queryParams: {'mediaId': mediaId},
    );
  }

  // ─── Image Generation ─────────────────────────────────────────────────────────

  @override
  Future<ImageResponseDto> imageVariation({
    required String projectId,
    List<ReferenceImage> imageInfos = const [],
    required String prompt,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/variation',
      data: {
        'projectId': projectId,
        'imageInfos': imageInfos.map((e) => e.toJson()).toList(),
        'prompt': prompt,
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageUpscale({
    required String projectId,
    required ReferenceImage imageInfo,
    required UpscaleFactor upscaleFactor,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/upscale',
      data: {
        'projectId': projectId,
        'imageInfo': imageInfo.toJson(),
        'upscaleFactor': upscaleFactor.toJson(),
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageStyleChange({
    required String projectId,
    required ReferenceImage imageInfo,
    required ArtStyle targetedStyle,
    required String additionalPrompts,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/style_change',
      data: {
        'projectId': projectId,
        'imageInfo': imageInfo.toJson(),
        'targetedStyle': targetedStyle.toJson(),
        'additionalPrompts': additionalPrompts,
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageSpriteSheet({
    required String projectId,
    String? characterDescription,
    String? actionDescription,
    required List<ReferenceImage> imageInfos,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/sprite_sheet',
      data: {
        'projectId': projectId,
        'characterDescription': characterDescription,
        'actionDescription': actionDescription,
        'imageInfos': imageInfos.map((e) => e.toJson()).toList(),
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> splashArt({
    required String projectId,
    required String splashDescription,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/splash_art',
      data: {
        'projectId': projectId,
        'splashDescription': splashDescription,
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageMaskedEdit({
    required String projectId,
    required ReferenceImage imageInfo,
    required String maskImageBase64,
    String? prompt,
    required EditMode editMode,
    required MaskMode maskReferenceMode,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/masked_edit',
      data: {
        'projectId': projectId,
        'imageInfo': imageInfo.toJson(),
        'maskImageBase64': maskImageBase64,
        'prompt': prompt,
        'editMode': editMode.toJson(),
        'maskReferenceMode': maskReferenceMode.toJson(),
      },
    );
    return ImageResponseDto.fromJson(json);
  }
}

