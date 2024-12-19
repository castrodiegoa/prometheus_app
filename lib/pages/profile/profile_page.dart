import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_input_field.dart';
import '../../../widgets/custom_button.dart';
import 'package:prometheus_app/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Perfil',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: 'Número de documento',
                  controller: _controller.documentNumberController,
                  icon: Icons.numbers_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: 'Nombres',
                  controller: _controller.firstNameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: 'Apellidos',
                  controller: _controller.lastNameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: 'Número de teléfono',
                  controller: _controller.phoneController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: 'Correo electrónico',
                  controller: _controller.emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildSaveButton(context),
                const SizedBox(height: 20),
                _buildChangePasswordText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Obx(() {
      return CustomButton(
        text: 'Guardar cambios',
        onPressed: _controller.isLoading.value
            ? null
            : () => _controller.updateUserData(context),
        isLoading: _controller.isLoading.value,
      );
    });
  }

  void _updateFullName(String newName) {}

  Widget _buildChangePasswordText(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _showChangePasswordDialog(context),
        child: const Text(
          'Cambiar contraseña',
          style: TextStyle(
              color: Colors.grey, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cambiar Contraseña'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Contraseña actual
                  CustomInputField(
                    hintText: 'Contraseña actual',
                    controller: _controller.currentPasswordController,
                    icon: Icons.lock,
                    obscureText: _obscureCurrentPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nueva contraseña
                  CustomInputField(
                    hintText: 'Nueva contraseña',
                    controller: _controller.newPasswordController,
                    icon: Icons.lock_outline,
                    obscureText: _obscureNewPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Confirmar contraseña
                  CustomInputField(
                    hintText: 'Confirmar contraseña',
                    controller: _controller.confirmPasswordController,
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _controller.changePassword(context),
                  child: const Text('Cambiar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
