import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/widgets/custom_input_field.dart';
import 'package:prometheus_app/widgets/custom_button.dart';

class ConfirmAccountScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  ConfirmAccountScreen({super.key}); // Controlador para el campo de entrada

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
              'Confirma tu cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Te hemos enviado un código a tu correo electrónico. Ingresa ese código para confirmar tu cuenta.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Reemplazar TextField por CustomInputField
            CustomInputField(
              hintText: 'Ingresa el código',
              controller: codeController,
              icon: Icons.lock_outlined,
            ),
            const SizedBox(height: 20),
            // Reemplazar ElevatedButton por CustomButton
            CustomButton(
              text: 'Continuar',
              onPressed: () {
                Get.toNamed(
                    '/create-password'); // Navegar a Create a New Password
              },
            ),
            TextButton(
              onPressed: () {
                // Acción para reenviar el código
              },
              child: const Text(
                'Reenviar código',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
