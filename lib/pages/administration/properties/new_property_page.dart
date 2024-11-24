import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/property_controller.dart';
import 'package:prometheus_app/models/property_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPropertyPage extends StatefulWidget {
  @override
  _NewPropertyPageState createState() => _NewPropertyPageState();
}

class _NewPropertyPageState extends State<NewPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final PropertyController _propertyController = PropertyController();

  // Controllers para los campos del formulario
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isRented =
      false; // Usamos un booleano para manejar el estado del checkbox
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // Limpieza de los controllers
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Método para crear la propiedad
  Future<void> _createProperty() async {
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

      final property = Property(
        id: '', // El ID se generará en Firestore
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        isRented: _isRented, // Usamos el valor booleano directamente
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: currentUser.uid,
      );

      await _propertyController.createProperty(property);

      // Si todo sale bien, regresamos a la página anterior
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propiedad creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // true indica que se creó exitosamente
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al crear la propiedad: ${e.toString()}';
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
          'Nueva propiedad',
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
                // Campo de dirección
                _buildFormField(
                  controller: _addressController,
                  label: 'Dirección',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección';
                    }
                    return null;
                  },
                ),

                // Campo de descripción
                _buildFormField(
                  controller: _descriptionController,
                  label: 'Descripción',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),

                // Campo de estado de alquiler con un Checkbox
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¿Está rentada?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text('No'),
                          Checkbox(
                            value: _isRented,
                            onChanged: (bool? value) {
                              setState(() {
                                _isRented = value ?? false;
                              });
                            },
                          ),
                          Text('Sí'),
                        ],
                      ),
                    ],
                  ),
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
                  onPressed: _isLoading ? null : _createProperty,
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
                          'Crear Propiedad',
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
