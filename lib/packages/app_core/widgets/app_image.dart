import 'package:artifex_ai_mobile/generated/assets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as fcm;

import '../../index.dart';

/// A shared cache manager with a 30-day stalePeriod and a 500-object limit,
/// so images are reused across sessions without constantly re-downloading.
class AppImageCacheManager {
  static const _key = 'appImageCache';

  static final fcm.CacheManager instance = fcm.CacheManager(
    fcm.Config(
      _key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
    ),
  );
}

/// Strips ephemeral query params (Firebase `token`, CDN `X-Goog-Signature`, etc.)
/// so the disk-cache key stays stable even when the signed URL rotates.
String _stableCacheKey(String url) {
  try {
    final uri = Uri.parse(url);
    if (uri.queryParameters.isEmpty) return url;
    final stripped = uri.removeFragment().replace(queryParameters: const {});
    return stripped.toString();
  } catch (_) {
    return url;
  }
}

class AppImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final double radius;
  final bool cache;
  final bool inStorage;
  /// When set, the image is decoded at this width in memory (saves RAM and
  /// speeds up rendering for thumbnails). Pass the logical pixel width of the
  /// widget; Flutter will scale up for device pixel ratio automatically.
  final int? memCacheWidth;

  const AppImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.radius = 0,
    this.cache = true,
    this.inStorage = false,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!inStorage && isNetworkAsset() && !isSvgAsset()) {
      // Use LayoutBuilder so we always know the rendered size,
      // even when no explicit width/height is passed (e.g. grid thumbnails).
      Widget inner(BoxConstraints constraints) {
        final devicePixelRatio =
            MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0;
        // Prefer explicit memCacheWidth, then explicit width, then layout width.
        // Guard against double.infinity / NaN which would crash .round() → toInt().
        final effectiveWidth =
            (width != null && width!.isFinite && width! > 0) ? width : null;
        final resolvedMem = memCacheWidth ??
            (effectiveWidth != null
                ? (effectiveWidth * devicePixelRatio).round()
                : constraints.maxWidth.isFinite && constraints.maxWidth > 0
                    ? (constraints.maxWidth * devicePixelRatio).round()
                    : null);

        final img = _buildNetworkImgResolved(resolvedMem);
        return (radius == 0) ? img : _buildRadius(img);
      }

      // Skip LayoutBuilder only when width is a real finite value.
      final hasConcreteWidth =
          width != null && width!.isFinite && width! > 0;
      if (hasConcreteWidth || memCacheWidth != null) {
        return inner(const BoxConstraints());
      }
      return LayoutBuilder(builder: (_, constraints) => inner(constraints));
    }

    late Widget child;
    if (inStorage) {
      child = _buildStorageImage();
    } else if (isSvgAsset()) {
      child = _buildSvg();
    } else {
      child = _buildLocalImage();
    }

    return (radius == 0) ? child : _buildRadius(child);
  }

  bool isNetworkAsset() {
    return !asset.startsWith('assets');
  }

  bool isSvgAsset() {
    return asset.contains('.svg');
  }

  Widget _buildLocalImage() {
    return Image.asset(
      asset.isEmpty ? Assets.icons.outline.image.path : asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      filterQuality: FilterQuality.high,
    );
  }

  Widget _buildSvg() {
    return buildSvg(
      asset: asset,
      width: width,
      height: height,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }

  Widget _buildRadius(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }

  Widget _buildStorageImage() {
    return Image.file(
      File(asset),
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget _buildNetworkImgResolved(int? resolvedMemCacheWidth) {
    if (!cache) {
      return Image.network(
        asset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    return CachedNetworkImage(
      imageUrl: asset,
      cacheKey: _stableCacheKey(asset),
      cacheManager: AppImageCacheManager.instance,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: resolvedMemCacheWidth,
      fadeInDuration: const Duration(milliseconds: 300),
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}

Widget buildSvg({
  Key? key,
  required String asset,
  bool matchTextDirection = false,
  AssetBundle? bundle,
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
  AlignmentGeometry alignment = Alignment.center,
  bool allowDrawingOutsideViewBox = false,
  WidgetBuilder? placeholderBuilder,
  String? semanticsLabel,
  bool excludeFromSemantics = false,
  SvgTheme theme = const SvgTheme(),
  ColorFilter? colorFilter,
}) {
  return SvgPicture.asset(
    asset,
    key: key,
    matchTextDirection: matchTextDirection,
    bundle: bundle,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder: placeholderBuilder,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    theme: theme,
    colorFilter: colorFilter,
  );
}
