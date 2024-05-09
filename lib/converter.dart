import 'package:flutter/material.dart';
import "package:material_color_utilities/material_color_utilities.dart" as mcu;
import 'package:themegen/wallpaper_pair.dart';

class ColorHelper {
  static String _colorToCSSTailwindVar(
    String name,
    bool isDark,
    Color? color,
  ) {
    final rgb =
        color != null ? "${color.red} ${color.green} ${color.blue}" : "";
    return "--md-sys-${isDark ? "dark" : "light"}-$name: $rgb;";
  }

  static String _colorToCSSTailwindColor(String name, bool isDark,
      {bool noComma = false}) {
    return "\"${isDark ? "dark" : "light"}-$name\": \"rgb(var(--md-sys-${isDark ? "dark" : "light"}-$name) / <alpha-value>)\"${noComma ? "" : ","}";
  }

  static String _tailwindConfigColors(bool isDark) {
    return """
  export const mdSys${isDark ? "Dark" : "Light"}Colors = {
    ${_colorToCSSTailwindColor("primary", isDark)}
    ${_colorToCSSTailwindColor("on-primary", isDark)}
    ${_colorToCSSTailwindColor("primary-container", isDark)}
    ${_colorToCSSTailwindColor("on-primary-container", isDark)}

    ${_colorToCSSTailwindColor("primary-fixed", isDark)}
    ${_colorToCSSTailwindColor("on-primary-fixed", isDark)}
    ${_colorToCSSTailwindColor("primary-fixed-dim", isDark)}
    ${_colorToCSSTailwindColor("on-primary-fixed-variant", isDark)}

    ${_colorToCSSTailwindColor("secondary", isDark)}
    ${_colorToCSSTailwindColor("on-secondary", isDark)}
    ${_colorToCSSTailwindColor("secondary-container", isDark)}
    ${_colorToCSSTailwindColor("on-secondary-container", isDark)}

    ${_colorToCSSTailwindColor("secondary-fixed", isDark)}
    ${_colorToCSSTailwindColor("on-secondary-fixed", isDark)}
    ${_colorToCSSTailwindColor("secondary-fixed-dim", isDark)}
    ${_colorToCSSTailwindColor("on-secondary-fixed-variant", isDark)}

    ${_colorToCSSTailwindColor("tertiary", isDark)}
    ${_colorToCSSTailwindColor("on-tertiary", isDark)}
    ${_colorToCSSTailwindColor("tertiary-container", isDark)}
    ${_colorToCSSTailwindColor("on-tertiary-container", isDark)}

    ${_colorToCSSTailwindColor("tertiary-fixed", isDark)}
    ${_colorToCSSTailwindColor("on-tertiary-fixed", isDark)}
    ${_colorToCSSTailwindColor("tertiary-fixed-dim", isDark)}
    ${_colorToCSSTailwindColor("on-tertiary-fixed-variant", isDark)}

    ${_colorToCSSTailwindColor("error", isDark)}
    ${_colorToCSSTailwindColor("on-error", isDark)}
    ${_colorToCSSTailwindColor("error-container", isDark)}
    ${_colorToCSSTailwindColor("on-error-container", isDark)}

    ${_colorToCSSTailwindColor("surface", isDark)}
    ${_colorToCSSTailwindColor("on-surface", isDark)}
    ${_colorToCSSTailwindColor("surface-variant", isDark)}
    ${_colorToCSSTailwindColor("on-surface-variant", isDark)}

    ${_colorToCSSTailwindColor("surface-container-lowest", isDark)}
    ${_colorToCSSTailwindColor("surface-container-low", isDark)}
    ${_colorToCSSTailwindColor("surface-container", isDark)}
    ${_colorToCSSTailwindColor("surface-container-high", isDark)}
    ${_colorToCSSTailwindColor("surface-container-highest", isDark)}

    ${_colorToCSSTailwindColor("surface-dim", isDark)}
    ${_colorToCSSTailwindColor("surface-bright", isDark)}
    ${_colorToCSSTailwindColor("surface-tint", isDark)}

    ${_colorToCSSTailwindColor("background", isDark)}
    ${_colorToCSSTailwindColor("on-background", isDark)}

    ${_colorToCSSTailwindColor("outline", isDark)}
    ${_colorToCSSTailwindColor("outline-variant", isDark)}

    ${_colorToCSSTailwindColor("inverse-surface", isDark)}
    ${_colorToCSSTailwindColor("inverse-on-surface", isDark)}
    ${_colorToCSSTailwindColor("inverse-primary", isDark)}

    ${_colorToCSSTailwindColor("shadow", isDark)}
    ${_colorToCSSTailwindColor("scrim", isDark, noComma: true)}
  }""";
  }

  static String _tailwindBaseVariables(bool isDark, mcu.DynamicScheme c) {
    return """
@tailwind base;
  @layer base {
    :root {
      ${_colorToCSSTailwindVar("primary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.primary.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-primary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onPrimary.getArgb(c)))}
      ${_colorToCSSTailwindVar("primary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.primaryContainer.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-primary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onPrimaryContainer.getArgb(c)))}

      ${_colorToCSSTailwindVar("primary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.primaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-primary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onPrimaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("primary-fixed-dim", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.primaryFixedDim.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-primary-fixed-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onPrimaryFixedVariant.getArgb(c)))}

      ${_colorToCSSTailwindVar("secondary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.secondary.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-secondary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSecondary.getArgb(c)))}
      ${_colorToCSSTailwindVar("secondary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.secondaryContainer.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-secondary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSecondaryContainer.getArgb(c)))}

      ${_colorToCSSTailwindVar("secondary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.secondaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-secondary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSecondaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("secondary-fixed-dim", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.secondaryFixedDim.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-secondary-fixed-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSecondaryFixedVariant.getArgb(c)))}

      ${_colorToCSSTailwindVar("tertiary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.tertiary.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-tertiary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onTertiary.getArgb(c)))}
      ${_colorToCSSTailwindVar("tertiary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.tertiaryContainer.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-tertiary-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onTertiaryContainer.getArgb(c)))}

      ${_colorToCSSTailwindVar("tertiary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.tertiaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-tertiary-fixed", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onTertiaryFixed.getArgb(c)))}
      ${_colorToCSSTailwindVar("tertiary-fixed-dim", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.tertiaryFixedDim.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-tertiary-fixed-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onTertiaryFixedVariant.getArgb(c)))}

      ${_colorToCSSTailwindVar("error", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.error.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-error", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onError.getArgb(c)))}
      ${_colorToCSSTailwindVar("error-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.errorContainer.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-error-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onErrorContainer.getArgb(c)))}

      ${_colorToCSSTailwindVar("surface", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surface.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-surface", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSurface.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceVariant.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-surface-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onSurfaceVariant.getArgb(c)))}
      
      ${_colorToCSSTailwindVar("surface-container-lowest", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceContainerLowest.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-container-low", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceContainerLow.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-container", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceContainer.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-container-high", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceContainerHigh.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-container-highest", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceContainerHighest.getArgb(c)))}

      
      ${_colorToCSSTailwindVar("surface-dim", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceDim.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-bright", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceBright.getArgb(c)))}
      ${_colorToCSSTailwindVar("surface-tint", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.surfaceTint.getArgb(c)))}
    
      ${_colorToCSSTailwindVar("background", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.background.getArgb(c)))}
      ${_colorToCSSTailwindVar("on-background", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.onBackground.getArgb(c)))}
    
      ${_colorToCSSTailwindVar("outline", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.outline.getArgb(c)))}
      ${_colorToCSSTailwindVar("outline-variant", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.outlineVariant.getArgb(c)))}
      
      ${_colorToCSSTailwindVar("inverse-surface", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.inverseSurface.getArgb(c)))}
      ${_colorToCSSTailwindVar("inverse-on-surface", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.inverseOnSurface.getArgb(c)))}
      ${_colorToCSSTailwindVar("inverse-primary", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.inversePrimary.getArgb(c)))}
      
      ${_colorToCSSTailwindVar("shadow", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.shadow.getArgb(c)))}
      ${_colorToCSSTailwindVar("scrim", isDark, WallpaperPair.argbToColor(mcu.MaterialDynamicColors.scrim.getArgb(c)))}
    }
  }
  """;
  }

/*   static String copyToTailwind(ColorScheme light, ColorScheme dark) {
    return """\n
  // m3_sys_dark.css
  ${_tailwindBaseVariables(true, dark)}
  
  // m3_sys_light.css
  ${_tailwindBaseVariables(false, dark)}

  /**
   * Autogenerated do not edit directly
   */
  ${_tailwindConfigColors(true)}
  ${_tailwindConfigColors(false)}

  """;
  } */

  static String copyDarkCSS(mcu.DynamicScheme dark) {
    return """\n
  
/** 
 * m3_sys_dark.css
 * Autogenerated do not edit directly
*/
${_tailwindBaseVariables(true, dark)}
""";

    ///WallpaperPair.argbToColor(
    //   mcu.MaterialDynamicColors.primary.getArgb(dynamicScheme))
  }

  static String copyLightCSS(mcu.DynamicScheme light) {
    return """\n
  
/** 
 * m3_sys_light.css
 * Autogenerated do not edit directly
*/
${_tailwindBaseVariables(false, light)}
""";
  }
}
