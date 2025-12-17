import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'presentation/screens/auth/role_selection_screen.dart';
import 'package:colegio_app/presentation/providers/auth_provider.dart';

/// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

/// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'U.E.P. Técnico Humanístico',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // Pantalla inicial: Selección de rol
        home: const RoleSelectionScreen(),
      ),
    );
  }
}