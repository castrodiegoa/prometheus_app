import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child:
                    Image.asset('assets/Icon-Prometheus-128px.png', height: 80),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Lógica para recuperar contraseña
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica de inicio de sesión
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Redirigir a la página de Crear Cuenta
                    Get.toNamed('/register');
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
