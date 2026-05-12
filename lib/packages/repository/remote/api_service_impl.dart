import 'package:flutter/services.dart';

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

  static final _aiOptions = Options(
    receiveTimeout: const Duration(minutes: 10),
    sendTimeout: const Duration(minutes: 2),
  );

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
      options: Options(contentType: 'text/plain; charset=utf-8'),
    );
  }

  @override
  Future<void> validateEmail() async {
    await _dioService.post(
      endpoint: '/api/user/v1/email/validate',
    );
  }

  @override
  Future<void> emailToken({required String token}) async {
    await _dioService.post(
      endpoint: '/api/user/v1/email/token',
      data: token,
      options: Options(contentType: 'text/plain; charset=utf-8'),
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
    required int projectId,
    required List<String> instructions,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/update_instructions',
      data: {
        'projectId': projectId,
        'instructions': instructions,
      },
    );
  }

  @override
  Future<void> addInstructions({
    required int projectId,
    required String newInstruction,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/add_instructions',
      data: {
        'projectId': projectId,
        'newInstruction': newInstruction,
      },
    );
  }

  @override
  Future<void> editProject({
    required int projectId,
    String? projectName,
    ArtStyle? artStyle,
  }) async {
    await _dioService.put(
      endpoint: '/api/project/v1/edit',
      data: {
        'projectId': projectId,
        'projectName': projectName,
        'artStyle': artStyle?.toJson(),
      },
    );
  }

  @override
  Future<ProjectDto> createProject({
    required String projectName,
    required String instructions,
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
  Future<ProjectDto> getProjectById({required int projectId}) async {
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
  Future<void> deleteProject({required int projectId}) async {
    await _dioService.delete(
      endpoint: '/api/project/v1/delete',
      queryParams: {'projectId': projectId},
    );
  }

  // ─── Album Management ─────────────────────────────────────────────────────────

  @override
  Future<void> editAlbum({
    required int albumId,
    String? albumName,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/edit',
      data: {
        'albumId': albumId,
        'name': albumName,
      },
    );
  }

  @override
  Future<void> deleteMediaFromAlbum({
    required int albumId,
    required int mediaId,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/delete_image',
      data: {
        'albumId': albumId,
        'mediaId': mediaId,
      },
    );
  }

  @override
  Future<void> addMedia({
    required int albumId,
    required int mediaId,
  }) async {
    await _dioService.put(
      endpoint: '/api/album/v1/add_image',
      data: {
        'albumId': albumId,
        'mediaId': mediaId,
      },
    );
  }

  @override
  Future<AlbumDto> createAlbum({
    required String name,
    required List<int> mediaIds,
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
  Future<AlbumDto> getAlbumById({required int albumId}) async {
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
  Future<void> deleteAlbum({required int albumId}) async {
    await _dioService.delete(
      endpoint: '/api/album/v1/delete',
      queryParams: {'albumId': albumId},
    );
  }

  // ─── Video Generation ─────────────────────────────────────────────────────────

  @override
  Future<VideoResponseDto> generateVideo({
    required int projectId,
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
    return await _dioService.postGetMessage(
      endpoint: '/api/user/v1/refresh_jwt',
      data: refreshToken,
      options: Options(contentType: 'text/plain; charset=utf-8'),
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
  Future<AuthenticationResponseDto> authenticateOAuthGoogle() =>
      _performOAuth2Login(
        url: '${Config.baseUrl}oauth2/authorization/google',
      );

  @override
  Future<AuthenticationResponseDto> authenticateOAuthGithub() =>
      _performOAuth2Login(
        url: '${Config.baseUrl}oauth2/authorization/github',
      );

  /// Opens the device browser to the server's OAuth2 entry URL, waits for the
  /// deep-link callback `artifexai://oauth2/callback?jwt=...&refresh=...`, and
  /// returns the parsed tokens as [AuthenticationResponseDto].
  Future<AuthenticationResponseDto> _performOAuth2Login({
    required String url,
  }) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'artifexai',
      );

      final uri = Uri.parse(result);
      final jwt = uri.queryParameters['jwt'];
      final refresh = uri.queryParameters['refresh'];

      if (jwt == null || refresh == null) {
        throw CustomException(
          message: 'OAuth2 login failed: missing tokens in callback',
        );
      }

      return AuthenticationResponseDto(jwtToken: jwt, refreshToken: refresh);
    } on PlatformException {
      // User closed the browser or cancelled – signal this to the caller.
      throw CustomException(
        message: 'cancelled',
        exceptionType: ExceptionType.cancelException,
      );
    }
  }

  // ─── Media Management ─────────────────────────────────────────────────────────

  @override
  Future<MediaDto> uploadClient({
    required String base64,
    required MimeType mimeType,
  }) async {
   final json = await _dioService.post(
      endpoint: '/api/media/v1/upload_image_client',
      data: {
        'base64': base64,
        'mimeType': mimeType.toJson(),
      },
    );
   return MediaDto.fromJson(json);
  }

  @override
  Future<MediaDto> getMediaById({required int id}) async {
    final json = await _dioService.get(
      endpoint: '/api/media/v1/get_by_id',
      queryParams: {'mediaId': id},
    );
    return MediaDto.fromJson(json);
  }

  @override
  Future<List<MediaDto>> getMediasByAlbum({required int albumId}) async {
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
  Future<void> deleteMedia({required int mediaId}) async {
    await _dioService.delete(
      endpoint: '/api/media/v1/delete',
      queryParams: {'mediaId': mediaId},
    );
  }

  // ─── Image Generation ─────────────────────────────────────────────────────────

  @override
  Future<ImageResponseDto> imageVariation({
    required int projectId,
    List<ReferenceImage> imageInfos = const [],
    required String prompt,
    GenerationModel model = GenerationModel.gpt,
  }) async {
    final json = await _dioService.post(
      endpoint: model.buildEndpoint('variation'),
      options: _aiOptions,
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
    required int projectId,
    required ReferenceImage imageInfo,
    required UpscaleFactor upscaleFactor,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/upscale',
      options: _aiOptions,
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
    required int projectId,
    required ReferenceImage imageInfo,
    required ArtStyle targetedStyle,
    required String additionalPrompts,
    GenerationModel model = GenerationModel.gpt,
  }) async {
    final json = await _dioService.post(
      endpoint: model.buildEndpoint('style_change'),
      options: _aiOptions,
      data: {
        'projectId': projectId,
        'imageInfo': imageInfo.toJson(),
        'targetStyle': targetedStyle.toJson(),
        'additionalPrompts': additionalPrompts,
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageSpriteSheet({
    required int projectId,
    String? characterDescription,
    String? actionDescription,
    required List<ReferenceImage> imageInfos,
    GenerationModel model = GenerationModel.gpt,
  }) async {
    final json = await _dioService.post(
      endpoint: model.buildEndpoint('sprite_sheet'),
      options: _aiOptions,
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
    required int projectId,
    required String splashDescription,
    GenerationModel model = GenerationModel.gpt,
  }) async {
    final json = await _dioService.post(
      endpoint: model.buildEndpoint('splash_art'),
      options: _aiOptions,
      data: {
        'projectId': projectId,
        'splashDescription': splashDescription,
      },
    );
    return ImageResponseDto.fromJson(json);
  }

  @override
  Future<ImageResponseDto> imageMaskedEdit({
    required int projectId,
    required ReferenceImage imageInfo,
    required String maskImageBase64,
    String? prompt,
    required EditMode editMode,
  }) async {
    final json = await _dioService.post(
      endpoint: '/api/image_generation/v1/masked_edit',
      options: _aiOptions,
      data: {
        'projectId': projectId,
        'imageInfo': imageInfo.toJson(),
        'maskImageBase64': maskImageBase64,
        'prompt': prompt,
        'editMode': editMode.toJson(),
      },
    );
    return ImageResponseDto.fromJson(json);
  }
}

