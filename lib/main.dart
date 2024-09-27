import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/pages/login_page.dart';
import 'package:prometheus_app/pages/register_page.dart';

void main() {
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
            page: () => LoginPage()), // Ruta para la página de Login
        GetPage(
            name: '/register',
            page: () => RegisterPage()), // Ruta para la página de Registro
      ],
    );
  }
}
