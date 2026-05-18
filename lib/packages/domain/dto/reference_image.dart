import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:artifex_ai_mobile/packages/domain/index.dart';

part 'reference_image.freezed.dart';
part 'reference_image.g.dart';

@freezed
abstract class ReferenceImage with _$ReferenceImage {
  factory ReferenceImage({
    @JsonKey(name: 'imagePath') String? imagePath,
    @JsonKey(name: 'mimeType') MimeType? mimeType,
  }) = _ReferenceImage;

  factory ReferenceImage.fromJson(Map<String, dynamic> json) =>
      _$ReferenceImageFromJson(json);
}

