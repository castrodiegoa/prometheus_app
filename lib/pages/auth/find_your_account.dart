import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/widgets/custom_input_field.dart';
import 'package:prometheus_app/widgets/custom_button.dart';

class FindAccountScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  FindAccountScreen({super.key}); // Controlador para el campo de entrada

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
              'Busca tu cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Introduce tu dirección de correo electrónico.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            CustomInputField(
              hintText: 'Correo electrónico',
              controller: emailController,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Continuar',
              onPressed: () {
                // Aquí se puede realizar la validación o cualquier lógica antes de navegar
                Get.toNamed('/confirm-account');
              },
            ),
          ],
        ),
      ),
    );
  }
}
