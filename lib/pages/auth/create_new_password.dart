import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/widgets/custom_input_field.dart';
import 'package:prometheus_app/widgets/custom_button.dart';

class NewPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  NewPasswordScreen({super.key}); // Controlador para la nueva contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Crea una nueva contraseña',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Crea una contraseña con al menos 6 letras y números. Necesitarás esta contraseña para iniciar sesión en tu cuenta.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Reemplazar TextField por CustomInputField
            CustomInputField(
              hintText: 'Nueva contraseña',
              controller: passwordController,
              icon: Icons.lock_outlined,
              obscureText: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {
                  // Acción para mostrar/ocultar contraseña
                },
              ),
            ),
            const SizedBox(height: 20),
            // Reemplazar ElevatedButton por CustomButton
            CustomButton(
              text: 'Continuar',
              onPressed: () {
                Get.toNamed('/login'); // Navegar a la pantalla de Login
              },
            ),
          ],
        ),
      ),
    );
  }
}
