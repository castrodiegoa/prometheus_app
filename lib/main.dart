import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prometheus_app/pages/auth/login_page.dart';
import 'package:prometheus_app/pages/auth/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prometheus_app/firebase_options.dart';
import 'package:prometheus_app/pages/home_page.dart';
import 'package:prometheus_app/pages/auth/find_your_account.dart';
import 'package:prometheus_app/pages/auth/confirm_your_account.dart';
import 'package:prometheus_app/pages/auth/create_new_password.dart';
import 'package:prometheus_app/controllers/auth_controller.dart';
import 'package:prometheus_app/pages/onboarding_page.dart'; // Importa la página de introducción

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init(); // Inicializa GetStorage
  Get.put(AuthController()); // Registrar el AuthController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final authController = Get.find<AuthController>();
    bool hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prometheus App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Obx(() {
        // Si el usuario está autenticado
        if (authController.user.value != null) {
          return const HomePage();
        }
        // Si no ha visto el onboarding
        if (!hasSeenOnboarding) {
          return const OnboardingPage();
        }
        // Por defecto, mostrar login
        return LoginPage();
      }),
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/onboarding', page: () => const OnboardingPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/forgot-password', page: () => FindAccountScreen()),
        GetPage(name: '/confirm-account', page: () => ConfirmAccountScreen()),
        GetPage(name: '/create-password', page: () => NewPasswordScreen()),
      ],
    );
  }
}
