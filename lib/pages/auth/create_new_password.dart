import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/widgets/custom_input_field.dart';
import 'package:prometheus_app/widgets/custom_button.dart';

class NewPasswordScreen extends StatefulWidget {
  NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true; // Estado inicial: contraseña oculta

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
              'Crea una nueva contraseña',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Crea una contraseña con al menos 6 letras y números. Necesitarás esta contraseña para iniciar sesión en tu cuenta.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Campo para nueva contraseña con visibilidad dinámica
            CustomInputField(
              hintText: 'Nueva contraseña',
              controller: passwordController,
              icon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword =
                        !_obscurePassword; // Alternar visibilidad
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Botón para continuar
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
