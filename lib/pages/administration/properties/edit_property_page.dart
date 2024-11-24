import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/property_controller.dart';
import 'package:prometheus_app/models/property_model.dart';
import 'package:intl/intl.dart';

class EditPropertyPage extends StatefulWidget {
  final String entityType = 'Propiedades';
  final String entityId;
  final Map entityData;

  EditPropertyPage({
    required this.entityId,
    required this.entityData,
  });

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final PropertyController _propertyController = PropertyController();

  // Controladores para los campos de texto
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  bool isRented = false; // Ahora es un valor booleano

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con datos existentes
    addressController =
        TextEditingController(text: widget.entityData['address']);
    descriptionController =
        TextEditingController(text: widget.entityData['description']);
    isRented =
        widget.entityData['isRented'] ?? false; // Cargar el valor de isRented
  }

  @override
  void dispose() {
    // Liberar recursos
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      try {
        final tenant = Property(
          id: widget.entityId,
          address: addressController.text,
          description: descriptionController.text,
          isRented: isRented, // Guardar el valor de isRented
          createdAt: (widget.entityData['createdAt'] as Timestamp?)?.toDate(),
          updatedAt: DateTime.now(),
          userId: widget.entityData['userId'],
        );

        await _propertyController.updateProperty(tenant);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Propiedad actualizada exitosamente')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la propiedad: $e')),
        );
      }
    }
  }

  Future<void> _deleteProperty() async {
    try {
      await _propertyController.deleteProperty(widget.entityId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Propiedad eliminada exitosamente')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la propiedad: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar esta propiedad?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.pop(context);
                _deleteProperty();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entityType,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campos no editables
              _buildReadOnlyField('id', widget.entityId),
              _buildReadOnlyFieldDate(
                  'Fecha de creación', widget.entityData['createdAt']),
              _buildReadOnlyFieldDate(
                  'Fecha de actualización', widget.entityData['updatedAt']),

              SizedBox(height: 20),

              // Campos editables
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Checkbox para isRented
              CheckboxListTile(
                title: Text('¿Está rentada?'),
                value: isRented,
                onChanged: (bool? newValue) {
                  setState(() {
                    isRented = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 16),

              SizedBox(height: 32),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showDeleteConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text(
                      'Eliminar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateProperty,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text(
                      'Actualizar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildReadOnlyFieldDate(String label, Timestamp? timestamp) {
    // Formatea el timestamp o muestra "N/A" si es null
    String formattedValue = timestamp != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            formattedValue,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Divider(),
        ],
      ),
    );
  }
}
