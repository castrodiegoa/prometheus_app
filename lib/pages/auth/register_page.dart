import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_input_field.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/login'); // Volver a la pantalla de Login
          },
        ),
        elevation: 0, // Sin sombra
        backgroundColor: Colors.white, // Fondo blanco
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear cuenta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                // Campo para Número de documento
                CustomInputField(
                  hintText: 'Número de documento',
                  controller: _documentNumberController,
                  icon: Icons.numbers,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                // Campo para Nombres
                CustomInputField(
                  hintText: 'Nombres',
                  controller: _firstNameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                // Campo para Apellidos
                CustomInputField(
                  hintText: 'Apellidos',
                  controller: _lastNameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                // Campo para Número de teléfono
                CustomInputField(
                  hintText: 'Número de teléfono',
                  controller: _phoneController,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                // Campo para Correo electrónico
                CustomInputField(
                  hintText: 'Correo electrónico',
                  controller: _emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // Campo para Contraseña
                CustomInputField(
                  hintText: 'Contraseña',
                  controller: _passwordController,
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Campo para Confirmar contraseña
                CustomInputField(
                  hintText: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                // Botón para continuar
                _buildContinueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para el botón de continuar
  Widget _buildContinueButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Color de fondo del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            String documentNumber = _documentNumberController.text.trim();
            String email = _emailController.text.trim();
            String phone = _phoneController.text.trim();
            String firstName = _firstNameController.text.trim();
            String lastName = _lastNameController.text.trim();
            String password = _passwordController.text.trim();
            String confirmPassword = _confirmPasswordController.text.trim();

            if (documentNumber.isEmpty ||
                email.isEmpty ||
                phone.isEmpty ||
                firstName.isEmpty ||
                lastName.isEmpty ||
                password.isEmpty ||
                confirmPassword.isEmpty) {
              Get.snackbar('Error', 'Todos los campos son obligatorios',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }

            if (password != confirmPassword) {
              Get.snackbar('Error', 'Las contraseñas no coinciden',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }

            if (!GetUtils.isEmail(email)) {
              Get.snackbar('Error', 'Correo no válido',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }

            // Lógica de registro
            _authController.register(
                documentNumber, firstName, lastName, phone, email, password);
          },
          child: const Text(
            'Continuar',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
