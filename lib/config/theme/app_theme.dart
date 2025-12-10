import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema principal de la aplicación
/// Basado en los colores de la U.E.P. Técnico Humanístico Ebenezer
class AppTheme {
  // 🎨 COLORES PRINCIPALES (basados en la web del colegio)
  static const Color primaryColor = Color(0xFF1E40AF); // Azul institucional
  static const Color secondaryColor = Color(0xFF059669); // Verde éxito
  static const Color accentColor = Color(0xFFFBBF24); // Amarillo/dorado
  static const Color errorColor = Color(0xFFDC2626); // Rojo para errores
  
  // Colores de fondo
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Colors.white;
  
  // Colores de texto
  static const Color textPrimaryColor = Color(0xFF111827);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  /// Tema principal de la app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Esquema de colores
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      
      // Tipografía (fuentes)
      textTheme: GoogleFonts.interTextTheme().copyWith(
        // Títulos grandes
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        // Títulos medianos
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        // Títulos pequeños
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        // Texto normal
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textPrimaryColor,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondaryColor,
        ),
      ),
      
      // Color de fondo general
      scaffoldBackgroundColor: backgroundColor,
      
      // Estilo de la barra superior (AppBar)
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Estilo de los botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Estilo de los campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Estilo de las tarjetas
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
    );
  }
}

/// Colores adicionales para los diferentes roles
class RoleColors {
  static const Color parent = Color(0xFF3B82F6); // Azul para padres
  static const Color student = Color(0xFF10B981); // Verde para estudiantes
  static const Color teacher = Color(0xFF8B5CF6); // Morado para docentes
  static const Color admin = Color(0xFFEF4444); // Rojo para admin
}