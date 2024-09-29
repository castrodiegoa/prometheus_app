import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prometheus_app/pages/login_page.dart';
import 'package:prometheus_app/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prometheus_app/firebase_options.dart';
import 'package:prometheus_app/pages/home_page.dart'; // Importa la página de inicio (ejemplo)
import 'package:prometheus_app/pages/find_your_account.dart'; // Importa la página de recuperación de contraseña (ejemplo)
import 'package:prometheus_app/pages/confirm_your_account.dart'; 
import 'package:prometheus_app/pages/create_new_password.dart'; 
void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prometheus App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Página de inicio
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ), // Ruta para la página de Login
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
        ), // Ruta para la página de Registro
        GetPage(
          name: '/home',
          page: () => HomePage(),
        ), // Ruta para la página principal (ejemplo)
        GetPage(
          name: '/forgot-password',
          page: () => FindAccountScreen(),
        ), // Ruta para la página de recuperación de contraseña (ejemplo)
        GetPage(
          name: '/confirm-account',
          page: () => ConfirmAccountScreen(),
        ),
        GetPage(
          name: '/create-password',
          page: () =>  NewPasswordScreen(),
        )
        // Puedes seguir agregando más rutas de la misma forma
      ],
    );
  }
}

