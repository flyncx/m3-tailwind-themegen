import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import "package:material_color_utilities/material_color_utilities.dart" as mcu;
import 'package:material_color_utilities/scheme/variant.dart';

class WallpaperPickerProvider with ChangeNotifier {
  final WallpaperPair wallpaper1;
  final WallpaperPair wallpaper2;
  final WallpaperPair wallpaper3;
  final WallpaperPair wallpaper4;
  WallpaperPair? wallpaper5;

  WallpaperPair currentWallpaper;
  Brightness? brightness;

  WallpaperPickerProvider({
    required this.wallpaper1,
    required this.wallpaper2,
    required this.wallpaper3,
    required this.wallpaper4,
    required this.currentWallpaper,
  });

  void updateCurrentWallpaper(WallpaperPair wallpaperPair) {
    currentWallpaper = wallpaperPair;
    notifyListeners();
  }

  void updateCurrentWallpaper5(WallpaperPair? wallpaperPair) {
    wallpaper5 = wallpaperPair;
    notifyListeners();
  }

  void updateBrightness(Brightness nbrightness) {
    brightness = nbrightness;
    notifyListeners();
  }
}

class WallpaperPair {
  mcu.DynamicScheme dynamicSchemeLight;
  mcu.DynamicScheme dynamicSchemeDark;
  ColorScheme colorSchemeLight;
  ColorScheme colorSchemeDark;
  ImageProvider imageProvider;
  WallpaperPair(
      {required this.colorSchemeLight,
      required this.colorSchemeDark,
      required this.dynamicSchemeLight,
      required this.dynamicSchemeDark,
      required this.imageProvider});

  static Future<WallpaperPair> fromImageProvider(
      ImageProvider imageProvider) async {
    // Extract dominant colors from image.
    final mcu.QuantizerResult quantizerResult =
        await _extractColorsFromImageProvider(imageProvider);
    final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
      (int key, int value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
    );

    // Score colors for color scheme suitability.
    final List<int> scoredResults = mcu.Score.score(colorToCount, desired: 1);
    final ui.Color baseColor = Color(scoredResults.first);

    final sourceColorArgb = mcu.ColorUtils.argbFromRgb(
        baseColor.red, baseColor.green, baseColor.blue);
    final core = mcu.CorePalette.of(sourceColorArgb);
    final dynamicSchemeLight = mcu.DynamicScheme(
      isDark: false,
      sourceColorArgb: sourceColorArgb,
      variant: Variant.tonalSpot,
      primaryPalette: core.primary,
      secondaryPalette: core.secondary,
      tertiaryPalette: core.tertiary,
      neutralPalette: core.neutral,
      neutralVariantPalette: core.neutralVariant,
    );
    final dynamicSchemeDark = mcu.DynamicScheme(
      isDark: true,
      sourceColorArgb: sourceColorArgb,
      variant: Variant.tonalSpot,
      primaryPalette: core.primary,
      secondaryPalette: core.secondary,
      tertiaryPalette: core.tertiary,
      neutralPalette: core.neutral,
      neutralVariantPalette: core.neutralVariant,
    );

    return WallpaperPair(
      dynamicSchemeLight: dynamicSchemeLight,
      dynamicSchemeDark: dynamicSchemeDark,
      colorSchemeLight: await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.light,
      ),
      colorSchemeDark: await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.dark,
      ),
      imageProvider: imageProvider,
    );
  }

  ColorScheme colorScheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return colorSchemeDark;
      case Brightness.light:
        return colorSchemeLight;
    }
  } // ColorScheme.fromImageProvider() utilities.

  // Extracts bytes from an [ImageProvider] and returns a [QuantizerResult]
  // containing the most dominant colors.
  static Future<mcu.QuantizerResult> _extractColorsFromImageProvider(
      ImageProvider imageProvider) async {
    final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
    final ByteData? imageBytes = await scaledImage.toByteData();

    final mcu.QuantizerResult quantizerResult =
        await mcu.QuantizerCelebi().quantize(
      imageBytes!.buffer.asUint32List(),
      128,
      returnInputPixelToClusterPixel: true,
    );
    return quantizerResult;
  }

  // Scale image size down to reduce computation time of color extraction.
  static Future<ui.Image> _imageProviderToScaled(
      ImageProvider imageProvider) async {
    const double maxDimension = 112.0;
    final ImageStream stream = imageProvider.resolve(
        const ImageConfiguration(size: Size(maxDimension, maxDimension)));
    final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener((ImageInfo info, bool sync) async {
      loadFailureTimeout?.cancel();
      stream.removeListener(listener);
      final ui.Image image = info.image;
      final int width = image.width;
      final int height = image.height;
      double paintWidth = width.toDouble();
      double paintHeight = height.toDouble();
      assert(width > 0 && height > 0);

      final bool rescale = width > maxDimension || height > maxDimension;
      if (rescale) {
        paintWidth =
            (width > height) ? maxDimension : (maxDimension / height) * width;
        paintHeight =
            (height > width) ? maxDimension : (maxDimension / width) * height;
      }
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none);

      final ui.Picture picture = pictureRecorder.endRecording();
      scaledImage =
          await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
      imageCompleter.complete(info.image);
    }, onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      throw Exception('Failed to render image: $exception');
    });

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(
          TimeoutException('Timeout occurred trying to load image'));
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  // Converts AABBGGRR color int to AARRGGBB format.
  static int _getArgbFromAbgr(int abgr) {
    const int exceptRMask = 0xFF00FFFF;
    const int onlyRMask = ~exceptRMask;
    const int exceptBMask = 0xFFFFFF00;
    const int onlyBMask = ~exceptBMask;
    final int r = (abgr & onlyRMask) >> 16;
    final int b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }

  static Color argbToColor(int argb) {
    return Color.fromARGB(
        mcu.ColorUtils.alphaFromArgb(argb),
        mcu.ColorUtils.redFromArgb(argb),
        mcu.ColorUtils.greenFromArgb(argb),
        mcu.ColorUtils.blueFromArgb(argb));
  }
}
