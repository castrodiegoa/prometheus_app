import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // final ProfileController _profileController = Get.find();
  // final AuthController _authController = Get.find();

  ProfilePage({super.key});

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

                _buildSaveButton(context),
                const SizedBox(height: 20),

                // Texto para cambiar contraseña
                _buildChangePasswordText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para el botón de guardar
  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            // Aquí iría la lógica para guardar el perfil
          },
          child: const Text(
            'Guardar cambios',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Método para el texto que redirige a cambiar contraseña
  Widget _buildChangePasswordText(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Mostrar el diálogo para cambiar la contraseña
          _showChangePasswordDialog(context);
        },
        child: const Text(
          'Cambiar contraseña',
          style: TextStyle(
              color: Colors.grey, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de cambio de contraseña
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _currentPasswordController =
            TextEditingController();
        TextEditingController _newPasswordController = TextEditingController();
        TextEditingController _confirmPasswordController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Contraseña actual'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Nueva contraseña'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirmar contraseña'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para cambiar la contraseña
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
