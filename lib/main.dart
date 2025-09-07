import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  if (kIsWeb) {
    // Web-specific error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      // Log errors for health checker detection
      print('Platform error: $error');
      return true; // prevent default
    };
  }

  runZonedGuarded(() => runApp(const WebsiteApp()), (error, stack) {
    // Log zone errors for health checker detection
    print('Zone error: $error');
  });
}

class WebsiteApp extends StatelessWidget {
  const WebsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Website App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

