import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Tu paleta de colores personalizada
  static const Color primaryDark = Color(0xFF03045E);   // #03045E
  static const Color primaryMedium = Color(0xFF0077B6); // #0077B6  
  static const Color primaryLight = Color(0xFF00B4D8);  // #00B4D8
  static const Color accent = Color(0xFF90E0EF);        // #90E0EF
  static const Color surface = Color(0xFFCAF0F8);       // #CAF0F8
  
  // Colores adicionales para la app
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Colores neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 🎨 Color scheme principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMedium,
        brightness: Brightness.light,
        primary: primaryMedium,
        primaryContainer: surface,
        secondary: accent,
        secondaryContainer: accent.withOpacity(0.3),
        surface: white,
        surfaceContainerHighest: lightGrey,
        error: error,
      ),

      // 🍎 AppBar personalizada
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        iconTheme: IconThemeData(color: white),
        actionsIconTheme: IconThemeData(color: white),
      ),

      // 🔽 Bottom Navigation personalizada
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryMedium,
        unselectedItemColor: mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 🃏 Card personalizada
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shadowColor: primaryDark.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 🔘 Botones personalizados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMedium,
          foregroundColor: white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMedium,
          side: const BorderSide(color: primaryMedium, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 📝 Campos de texto personalizados
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryMedium, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: mediumGrey),
      ),

      // 🔄 Chips personalizados
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primaryLight,
        secondarySelectedColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: const TextStyle(
          color: primaryDark,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: white,
          fontWeight: FontWeight.w500,
        ),
      ),

      // 📊 Progress indicator personalizado
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryMedium,
        linearTrackColor: surface,
        circularTrackColor: surface,
      ),

      // 🎨 Colores adicionales para widgets personalizados
      extensions: <ThemeExtension<dynamic>>[
        CustomColors(
          success: success,
          warning: warning,
          info: info,
          cardGradientStart: primaryLight.withOpacity(0.1),
          cardGradientEnd: accent.withOpacity(0.05),
          shimmerBase: surface,
          shimmerHighlight: white,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMedium,
        brightness: Brightness.dark,
        primary: accent,
        primaryContainer: primaryDark,
        secondary: primaryLight,
        surface: const Color(0xFF121212),
        surfaceContainerHighest: const Color(0xFF1E1E1E),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: white,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: accent,
        unselectedItemColor: mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      extensions: <ThemeExtension<dynamic>>[
        CustomColors(
          success: success,
          warning: warning,
          info: info,
          cardGradientStart: primaryDark.withOpacity(0.3),
          cardGradientEnd: primaryMedium.withOpacity(0.1),
          shimmerBase: const Color(0xFF2A2A2A),
          shimmerHighlight: const Color(0xFF3A3A3A),
        ),
      ],
    );
  }
}

// 🎨 Extensión para colores personalizados
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.cardGradientStart,
    required this.cardGradientEnd,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color cardGradientStart;
  final Color cardGradientEnd;
  final Color shimmerBase;
  final Color shimmerHighlight;

  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? cardGradientStart,
    Color? cardGradientEnd,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardGradientStart: Color.lerp(cardGradientStart, other.cardGradientStart, t)!,
      cardGradientEnd: Color.lerp(cardGradientEnd, other.cardGradientEnd, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }

  // Helper para acceder fácilmente desde BuildContext
  static CustomColors of(BuildContext context) {
    return Theme.of(context).extension<CustomColors>()!;
  }
}

// 🎯 Utilidades para gradientes comunes
class AppGradients {
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppTheme.primaryMedium,
      AppTheme.primaryLight,
    ],
  );

  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppTheme.accent,
      AppTheme.surface,
    ],
  );

  static LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppTheme.surface.withOpacity(0.1),
      AppTheme.accent.withOpacity(0.05),
    ],
  );
}