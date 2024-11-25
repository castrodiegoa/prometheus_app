import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prometheus_app/controllers/rent_controller.dart';
import '/models/rent_model.dart';

class EditRentPage extends StatelessWidget {
  final String entityId;
  final Map<String, dynamic> entityData;
  final _formKey = GlobalKey<FormState>();

  EditRentPage({
    Key? key,
    required this.entityId,
    required this.entityData,
  }) : super(key: key);

  // Convertir los datos recibidos a un objeto Rent
  Rent get rent {
    return Rent(
      id: entityId,
      startDate: (entityData['startDate'] as Timestamp).toDate(),
      endDate: (entityData['endDate'] as Timestamp).toDate(),
      amount: (entityData['amount'] as num).toDouble(),
      totalPersons: entityData['totalPersons'] as String,
      tenantId: entityData['tenantId'] as String,
      propertyId: entityData['propertyId'] as String,
      userId: entityData['userId'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    final RentController controller = Get.find();

    // Inicializar el estado del formulario con los datos existentes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        controller.startDate.value = rent.startDate;
        controller.endDate.value = rent.endDate;
        controller.amount.value = rent.amount;
        controller.totalPersons.value = rent.totalPersons!;
        controller.selectedTenantId.value = rent.tenantId;
        controller.selectedPropertyId.value = rent.propertyId;
        controller.loadInitialData();
      } catch (e) {
        print('Error inicializando datos: $e');
        Get.snackbar(
          'Error',
          'Error al cargar los datos del alquiler',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(controller),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Editar Alquiler', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(),
        ),
      ],
    );
  }

  Widget _buildBody(RentController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSection(controller),
              _buildFinancialSection(controller),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return _buildSelectionSection(controller);
              }),
              _buildActionButtons(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(RentController controller) {
    return Column(
      children: [
        Obx(() => _buildDateField(
              label: 'Fecha de inicio',
              value: controller.startDate.value,
              onSelect: () => _selectStartDate(controller),
              validator: (value) {
                if (value == null) return 'La fecha de inicio es requerida';
                return null;
              },
            )),
        SizedBox(height: 16),
        Obx(() => _buildDateField(
              label: 'Fecha fin',
              value: controller.endDate.value,
              onSelect: controller.startDate.value != null
                  ? () => _selectEndDate(controller)
                  : null,
              validator: (value) {
                if (value == null) return 'La fecha fin es requerida';
                if (controller.startDate.value != null &&
                    value.isBefore(controller.startDate.value!)) {
                  return 'La fecha fin debe ser posterior a la fecha de inicio';
                }
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildFinancialSection(RentController controller) {
    return Column(
      children: [
        _buildTextField(
          label: 'Monto',
          initialValue: controller.amount.value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (value) =>
              controller.amount.value = double.tryParse(value) ?? 0.0,
          validator: (value) {
            if (value == null || value.isEmpty) return 'El monto es requerido';
            if (double.tryParse(value) == null)
              return 'Ingrese un monto válido';
            if (double.parse(value) <= 0) return 'El monto debe ser mayor a 0';
            return null;
          },
        ),
        _buildTextField(
          label: 'Cantidad de personas',
          initialValue: controller.totalPersons.value,
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.totalPersons.value = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La cantidad de personas es requerida';
            }
            if (int.tryParse(value) == null) {
              return 'Ingrese un número válido';
            }
            if (int.parse(value) <= 0) {
              return 'La cantidad debe ser mayor a 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSelectionSection(RentController controller) {
    return Column(
      children: [
        Obx(() => _buildDropdownField(
              label: 'Inquilino',
              value: controller.selectedTenantId.value,
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar inquilino'),
                ),
                ...controller.availableTenants.map((tenant) {
                  return DropdownMenuItem(
                    value: tenant['id']?.toString() ?? '',
                    child: Text(
                        '${tenant['firstName']} ${tenant['lastName']}' ??
                            'Sin nombre'),
                  );
                }),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debe seleccionar un inquilino';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) controller.selectedTenantId.value = value;
              },
            )),
        Obx(() => _buildDropdownField(
              label: 'Propiedad',
              value: controller.selectedPropertyId.value,
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar propiedad'),
                ),
                ...controller.availableProperties.map((property) {
                  return DropdownMenuItem(
                    value: property['id']?.toString() ?? '',
                    child: Text(property['description']?.toString() ??
                        'Sin descripción'),
                  );
                }),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debe seleccionar una propiedad';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) controller.selectedPropertyId.value = value;
              },
            )),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required Function()? onSelect,
    required String? Function(DateTime?)? validator,
  }) {
    return FormField<DateTime>(
      validator: validator,
      initialValue: value,
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            InkWell(
              onTap: onSelect,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: state.hasError ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value != null
                          ? '${value.day}/${value.month}/${value.year}'
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: onSelect != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    Icon(Icons.calendar_today,
                        color: onSelect != null ? Colors.black : Colors.grey),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    String? initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(RentController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Obx(() {
        final isLoading = controller.isLoading.value;
        return ElevatedButton(
          onPressed: isLoading ? null : () => _submitForm(controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 50),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  'Actualizar Alquiler',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        );
      }),
    );
  }

  Future<void> _selectStartDate(RentController controller) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000), // Permitir fechas pasadas
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    if (picked != null) {
      controller.updateStartDate(picked);
    }
  }

  Future<void> _selectEndDate(RentController controller) async {
    if (controller.startDate.value == null) return;

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.endDate.value ??
          DateTime(
            controller.startDate.value!.year,
            controller.startDate.value!.month + 1,
            controller.startDate.value!.day,
          ),
      firstDate: controller
          .startDate.value!, // La fecha fin debe ser después de la fecha inicio
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    if (picked != null) {
      controller.updateEndDate(picked);
    }
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Está seguro que desea eliminar este alquiler?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Get.back(); // Cerrar diálogo
              final RentController controller = Get.find();
              try {
                controller.isLoading.value = true;
                await controller.deleteRent(entityId);
                Get.back(); // Regresar a la pantalla anterior
                Get.snackbar(
                  'Éxito',
                  'Alquiler eliminado con éxito',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                print('Error al eliminar: $e');
                Get.snackbar(
                  'Error',
                  'No se pudo eliminar el alquiler: ${e.toString()}',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                controller.isLoading.value = false;
              }
            },
          ),
        ],
      ),
    );
  }

  void _submitForm(RentController controller) async {
    if (_formKey.currentState!.validate()) {
      try {
        controller.isLoading.value = true;
        await controller.updateRent(rent.id);
        Get.back(); // Return to previous screen
        Get.snackbar(
          'Éxito',
          'Alquiler actualizado con éxito',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Ocurrió un problema al actualizar el alquiler',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        controller.isLoading.value = false;
      }
    }
  }
}
