import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import 'package:get/get.dart';

// TODO: Organizar en service y controller

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar los datos del usuario logueado
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _documentNumberController.text = userDoc['document'] ?? '';
            _emailController.text = user.email ?? '';
            _phoneController.text = userDoc['phoneNumber'] ?? '';
            _firstNameController.text = userDoc['firstName'] ?? '';
            _lastNameController.text = userDoc['lastName'] ?? '';
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
        // Muestra un error al usuario si falla la carga de datos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos del perfil')),
        );
      }
    }
  }

  // Método para actualizar los datos en Firebase
  Future<void> _updateUserData() async {
    setState(() {
      isSaving = true;
    });
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Verificar si el documento ya está registrado con otro usuario
        QuerySnapshot documentSnapshot = await _firestore
            .collection('users')
            .where('document', isEqualTo: _documentNumberController.text)
            .where(FieldPath.documentId, isNotEqualTo: user.uid)
            .get();

        if (documentSnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'El número de documento ya está registrado con otro usuario.')),
          );
          return;
        }

        // Verificar si el correo ya está registrado con otro usuario
        if (_emailController.text != user.email) {
          QuerySnapshot emailSnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: _emailController.text)
              .where(FieldPath.documentId, isNotEqualTo: user.uid)
              .get();

          if (emailSnapshot.docs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'El correo electrónico ya está registrado con otro usuario.')),
            );
            return;
          }

          // Usar verifyBeforeUpdateEmail en lugar de updateEmail
          await user.verifyBeforeUpdateEmail(_emailController.text).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Correo de verificación enviado. Verifica el correo para completar el cambio de este.')),
            );
          }).catchError((error) {
            print('Error verifying email: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error al enviar la verificación del correo.')),
            );
          });
        }

        // Actualizar otros datos en Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'document': _documentNumberController.text,
          'phoneNumber': _phoneController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          //'email': _emailController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Mostrar éxito en la actualización de otros datos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resto de datos actualizados correctamente.')),
        );
      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil.')),
        );
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // Método para cambiar la contraseña
  Future<void> _changePassword() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Verificar si la contraseña actual es correcta
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña cambiada correctamente.')),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } catch (e) {
        print('Error cambiando la contraseña: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al cambiar la contraseña. Verifica la contraseña actual.')),
        );
      }
    }
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

  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
      text: 'Guardar cambios',
      onPressed: isSaving
          ? null
          : () {
              // Obtener valores de los campos
              String documentNumber = _documentNumberController.text.trim();
              String firstName = _firstNameController.text.trim();
              String lastName = _lastNameController.text.trim();
              String phone = _phoneController.text.trim();
              String email = _emailController.text.trim();

              // Validar campos
              String? validationMessage = _validateFields(
                  documentNumber, email, phone, firstName, lastName);

              if (validationMessage != null) {
                Get.snackbar('Advertencia', validationMessage,
                    backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }

              _updateUserData(); // Si no hay errores, procede a actualizar
            },
      isLoading: isSaving, // Pasar el estado de isSaving al CustomButton
    );
  }

// Método para validar campos
  String? _validateFields(String documentNumber, String email, String phone,
      String firstName, String lastName) {
    // Validar que todos los campos no estén vacíos
    if (documentNumber.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
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

    return null; // No hay errores
  }

  // Texto para cambiar contraseña
  Widget _buildChangePasswordText(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Mostrar un diálogo para cambiar la contraseña
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

  // Método para mostrar un diálogo para cambiar la contraseña
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para la contraseña actual
              CustomInputField(
                hintText: 'Contraseña actual',
                controller: _currentPasswordController,
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Campo para la nueva contraseña
              CustomInputField(
                hintText: 'Nueva contraseña',
                controller: _newPasswordController,
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Campo para confirmar la nueva contraseña
              CustomInputField(
                hintText: 'Confirmar contraseña',
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validar antes de cambiar la contraseña
                String? validationMessage = _validatePasswordFields(
                  _currentPasswordController.text.trim(),
                  _newPasswordController.text.trim(),
                  _confirmPasswordController.text.trim(),
                );

                if (validationMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(validationMessage)),
                  );
                  return; // No continuar si hay un error
                }

                _changePassword(); // Llamar al método para cambiar la contraseña
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cambiar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}

// Método para validar los campos de contraseña
String? _validatePasswordFields(
    String currentPassword, String newPassword, String confirmPassword) {
  if (currentPassword.isEmpty ||
      newPassword.isEmpty ||
      confirmPassword.isEmpty) {
    return 'Todos los campos son obligatorios';
  }

  if (newPassword.length < 6 || newPassword.length > 255) {
    return 'La nueva contraseña debe tener entre 6 y 255 caracteres';
  }

  if (newPassword != confirmPassword) {
    return 'Las nuevas contraseñas no coinciden';
  }

  return null; // No hay errores
}
