import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/tenant_controller.dart';
import 'package:prometheus_app/models/tenant_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewTenantPage extends StatefulWidget {
  @override
  _NewTenantPageState createState() => _NewTenantPageState();
}

class _NewTenantPageState extends State<NewTenantPage> {
  final _formKey = GlobalKey<FormState>();
  final TenantController _tenantController = TenantController();

  // Controllers para los campos del formulario
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _primaryPhoneController = TextEditingController();
  final TextEditingController _secondaryPhoneController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // Limpieza de los controllers
    _documentController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _primaryPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Método para validar el email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Método para validar el número de teléfono
  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  // Método para crear el inquilino
  Future<void> _createTenant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Obtener el ID del usuario actual
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final tenant = Tenant(
        id: '', // El ID se generará en Firestore
        document: _documentController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        primaryPhoneNumber: _primaryPhoneController.text.trim(),
        secondaryPhoneNumber: _secondaryPhoneController.text.trim(),
        email: _emailController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: currentUser.uid,
      );

      await _tenantController.createTenant(tenant);

      // Si todo sale bien, regresamos a la página anterior
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inquilino creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // true indica que se creó exitosamente
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al crear el inquilino: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Error desconocido'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo Inquilino',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo de documento
                _buildFormField(
                  controller: _documentController,
                  label: 'Número de documento',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el número de documento';
                    }
                    return null;
                  },
                ),

                // Campo de nombre
                _buildFormField(
                  controller: _firstNameController,
                  label: 'Nombre',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),

                // Campo de apellido
                _buildFormField(
                  controller: _lastNameController,
                  label: 'Apellido',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el apellido';
                    }
                    return null;
                  },
                ),

                // Campo de teléfono principal
                _buildFormField(
                  controller: _primaryPhoneController,
                  label: 'Teléfono principal',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el teléfono principal';
                    }
                    if (!_isValidPhone(value)) {
                      return 'Por favor ingrese un número de teléfono válido';
                    }
                    return null;
                  },
                ),

                // Campo de teléfono secundario (opcional)
                _buildFormField(
                  controller: _secondaryPhoneController,
                  label: 'Teléfono secundario (opcional)',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !_isValidPhone(value)) {
                      return 'Por favor ingrese un número de teléfono válido';
                    }
                    return null;
                  },
                ),

                // Campo de correo electrónico
                _buildFormField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el correo electrónico';
                    }
                    if (!_isValidEmail(value)) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Mensaje de error si existe
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Botón de crear
                ElevatedButton(
                  onPressed: _isLoading ? null : _createTenant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Crear Inquilino',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.orange),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
