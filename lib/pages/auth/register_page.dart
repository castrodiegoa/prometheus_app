import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';

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
                  'Regístrate',
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
                  icon: Icons.numbers_outlined,
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
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                // Campo para Correo electrónico
                CustomInputField(
                  hintText: 'Correo electrónico',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // Campo para Contraseña
                CustomInputField(
                  hintText: 'Contraseña',
                  controller: _passwordController,
                  icon: Icons.lock,
                  obscureText: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Acción para mostrar/ocultar contraseña
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Campo para Confirmar contraseña
                CustomInputField(
                  hintText: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  icon: Icons.lock_outline,
                  obscureText: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Acción para mostrar/ocultar contraseña
                    },
                  ),
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
    return Obx(() => Center(
          child: CustomButton(
            text: 'Continuar',
            isLoading: _authController.isLoading.value,
            onPressed: () {
              String documentNumber = _documentNumberController.text.trim();
              String email = _emailController.text.trim();
              String phone = _phoneController.text.trim();
              String firstName = _firstNameController.text.trim();
              String lastName = _lastNameController.text.trim();
              String password = _passwordController.text.trim();
              String confirmPassword = _confirmPasswordController.text.trim();

              // Llamar a las funciones de validación
              String? validationError = _validateFields(documentNumber, email,
                  phone, firstName, lastName, password, confirmPassword);

              if (validationError != null) {
                Get.snackbar('Advertencia', validationError,
                    backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }

              // Lógica de registro
              _authController.register(
                  documentNumber, firstName, lastName, phone, email, password);
            },
          ),
        ));
  }

  // Método para validar campos
  String? _validateFields(
      String documentNumber,
      String email,
      String phone,
      String firstName,
      String lastName,
      String password,
      String confirmPassword) {
    if (documentNumber.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Todos los campos son obligatorios';
    }

    if (documentNumber.length < 7 || documentNumber.length > 15) {
      return 'El número de documento debe tener entre 7 y 15 caracteres';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(documentNumber)) {
      return 'El número de documento debe contener solo caracteres numéricos';
    }

    if (firstName.length > 50) {
      return 'El nombre no puede tener más de 50 caracteres';
    }

    if (lastName.length > 50) {
      return 'El apellido no puede tener más de 50 caracteres';
    }

    if (email.length > 255) {
      return 'El correo no puede tener más de 255 caracteres';
    }

    if (phone.length < 10 || phone.length > 15) {
      return 'El número de teléfono debe tener entre 10 y 15 caracteres';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'El número de teléfono debe contener solo caracteres numéricos';
    }

    if (password.length < 6 || password.length > 255) {
      return 'La contraseña debe tener entre 6 y 255 caracteres';
    }

    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }

    if (!GetUtils.isEmail(email)) {
      return 'Correo no válido';
    }

    return null; // No hay errores
  }
}
