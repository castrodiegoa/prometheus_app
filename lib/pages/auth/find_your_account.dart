import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prometheus_app/widgets/custom_input_field.dart';
import 'package:prometheus_app/widgets/custom_button.dart';

class FindAccountScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  FindAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
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
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    // Lógica para enviar correo de recuperación
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);

                    // Mostrar notificación de éxito
                    Get.snackbar(
                      'Correo enviado',
                      'Se ha enviado un enlace para restablecer tu cuenta al correo $email.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                    // Navegar directamente al login
                    Get.offAllNamed('/login');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      // Manejo específico para correo no registrado
                      Get.snackbar(
                        'Usuario no encontrado',
                        'El correo electrónico $email no está registrado.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      // Otros errores de Firebase
                      Get.snackbar(
                        'Error',
                        'Ocurrió un error al intentar enviar el correo.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    // Errores generales
                    Get.snackbar(
                      'Error',
                      'Algo salió mal. Por favor, inténtalo de nuevo.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  // Validación si el campo está vacío
                  Get.snackbar(
                    'Campo vacío',
                    'Por favor, introduce tu dirección de correo.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
