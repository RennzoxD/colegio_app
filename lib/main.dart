import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/providers/auth_provider.dart';

/// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

/// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: permite usar múltiples providers en toda la app
    // Providers = gestión de estado (datos que cambian y se comparten)
    return MultiProvider(
      providers: [
        // Provider de autenticación (login, logout, usuario actual)
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        // Aquí agregaremos más providers después
        // Por ejemplo: NotasProvider, AsistenciaProvider, etc.
      ],
      child: MaterialApp(
        // Título de la app
        title: 'U.E.P. Técnico Humanístico',
        
        // Quitar el banner de "DEBUG"
        debugShowCheckedModeBanner: false,
        
        // Aplicar nuestro tema personalizado
        theme: AppTheme.lightTheme,
        
        // Pantalla inicial (Login)
        home: const LoginScreen(),
      ),
    );
  }
}