import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prometheus_app/controllers/tenant_controller.dart';
import 'package:prometheus_app/models/tenant_model.dart';
import 'package:intl/intl.dart';

class EditTenantPage extends StatefulWidget {
  final String entityType = 'Inquilinos';
  final String entityId;
  final Map entityData;

  EditTenantPage({
    required this.entityId,
    required this.entityData,
  });

  @override
  _EditTenantPageState createState() => _EditTenantPageState();
}

class _EditTenantPageState extends State<EditTenantPage> {
  final _formKey = GlobalKey<FormState>();
  final TenantController _tenantController = TenantController();

  // Controladores para los campos de texto
  late TextEditingController documentController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController primaryPhoneController;
  late TextEditingController secondaryPhoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con datos existentes
    documentController =
        TextEditingController(text: widget.entityData['document']);
    firstNameController =
        TextEditingController(text: widget.entityData['firstName']);
    lastNameController =
        TextEditingController(text: widget.entityData['lastName']);
    primaryPhoneController =
        TextEditingController(text: widget.entityData['primaryPhoneNumber']);
    secondaryPhoneController =
        TextEditingController(text: widget.entityData['secondaryPhoneNumber']);
    emailController = TextEditingController(text: widget.entityData['email']);
  }

  @override
  void dispose() {
    // Liberar recursos
    documentController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    primaryPhoneController.dispose();
    secondaryPhoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _updateTenant() async {
    if (_formKey.currentState!.validate()) {
      try {
        final tenant = Tenant(
          id: widget.entityId,
          document: documentController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          primaryPhoneNumber: primaryPhoneController.text,
          secondaryPhoneNumber: secondaryPhoneController.text,
          email: emailController.text,
          createdAt: (widget.entityData['createdAt'] as Timestamp?)?.toDate(),
          updatedAt: DateTime.now(),
          userId: widget.entityData['userId'],
        );

        await _tenantController.updateTenant(tenant);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inquilino actualizado exitosamente')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar inquilino: $e')),
        );
      }
    }
  }

  Future<void> _deleteTenant() async {
    try {
      await _tenantController.deleteTenant(widget.entityId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inquilino eliminado exitosamente')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar inquilino: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar este inquilino?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.pop(context);
                _deleteTenant();
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
                controller: documentController,
                decoration: InputDecoration(
                  labelText: 'Documento',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el documento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: primaryPhoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono principal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono principal';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: secondaryPhoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono secundario',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),

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
                    onPressed: _updateTenant,
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
