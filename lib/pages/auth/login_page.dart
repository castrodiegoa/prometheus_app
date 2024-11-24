import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

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
              // Campo de correo electrónico
              CustomInputField(
                hintText: 'Correo electrónico',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Campo de contraseña
              CustomInputField(
                hintText: 'Contraseña',
                controller: _passwordController,
                icon: Icons.lock_outline,
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/forgot-password');
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Obx(() => Center(
                    child: CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: () {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        _authController.login(email, password);
                      },
                      isLoading: _authController.isLoading.value,
                    ),
                  )),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
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
