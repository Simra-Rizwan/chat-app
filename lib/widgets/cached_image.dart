import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    this.imageUrl,
    this.borderRadius = 50,
    this.strokeWidth = 5.0,
    this.imageHeight = 200,
    this.imageWidth = 50,
    this.elevation = 0.5,
    this.fit = BoxFit.cover,
    this.label,
    this.border,
    this.errorImagePath = "assets/images/no_image_found.png",
  });

  final String? imageUrl;
  final double borderRadius;
  final double strokeWidth;
  final double imageHeight;
  final double imageWidth;
  final double elevation;
  final BoxFit fit;
  final String? label;
  final BoxBorder? border;
  final String errorImagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: imageHeight,
        width: imageWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: (imageUrl ?? "").isNotEmpty
              ? CachedNetworkImage(
            imageUrl: imageUrl!,
            height: imageHeight,
            width: imageWidth,
            fit: fit,
            // Progress Indicator
            progressIndicatorBuilder: (
                BuildContext context,
                String url,
                DownloadProgress downloadProgress,
                ) =>
                SizedBox(
                  height: 20,
                  width: 20,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
            // Error Widget
            errorWidget: (
                BuildContext context,
                String url,
                dynamic error,
                ) =>
                _errorImage(),
          )
              : _errorImage(),
        ),
      ),
    );
  }

  Widget _errorImage() =>  Image.asset(
    errorImagePath,
    height: imageHeight,
    width: imageWidth,
    fit: BoxFit.cover,
  );
}