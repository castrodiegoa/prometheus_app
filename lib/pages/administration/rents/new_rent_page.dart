import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:prometheus_app/controllers/rent_controller.dart';

class NewRentPage extends StatelessWidget {
  final RentController controller = Get.put(RentController());
  final _formKey = GlobalKey<FormState>();

  NewRentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Nuevo Alquiler', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSection(),
              _buildFinancialSection(),
              _buildSelectionSection(),
              _buildFileSection(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      children: [
        Obx(() => _buildDateField(
              label: 'Fecha de inicio',
              value: controller.startDate.value,
              onSelect: _selectStartDate,
              validator: (value) {
                if (value == null) return 'La fecha de inicio es requerida';
                return null;
              },
            )),
        SizedBox(height: 16),
        Obx(() => _buildDateField(
              label: 'Fecha fin',
              value: controller.endDate.value,
              onSelect:
                  controller.startDate.value != null ? _selectEndDate : null,
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

  Widget _buildFinancialSection() {
    return Column(
      children: [
        _buildTextField(
          label: 'Monto',
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

  Widget _buildSelectionSection() {
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
                    child:
                        Text(tenant['firstName']?.toString() ?? 'Sin nombre'),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          TextFormField(
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
          ),
        ],
      ),
    );
  }

  Widget _buildFileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contrato', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Obx(
            () => controller.agreementFile.value != null
                ? _buildSelectedFile()
                : _buildFileSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Row(
      children: [
        Expanded(
          child: Text(
            controller.agreementFile.value!.path.split('/').last,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => controller.agreementFile.value = null,
        ),
      ],
    );
  }

  Widget _buildFileSelector() {
    return ElevatedButton(
      onPressed: _selectFile,
      child: Text('Seleccionar archivo'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Crear Alquiler',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    if (picked != null) {
      controller.updateStartDate(picked);
    }
  }

  Future<void> _selectEndDate() async {
    if (controller.startDate.value == null) return;

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(
        controller.startDate.value!.year,
        controller.startDate.value!.month + 1,
        controller.startDate.value!.day,
      ),
      firstDate: DateTime(
        controller.startDate.value!.year,
        controller.startDate.value!.month + 1,
        controller.startDate.value!.day,
      ),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    if (picked != null) {
      controller.updateEndDate(picked);
    }
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      controller.setAgreementFile(File(result.files.single.path!));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (controller.agreementFile.value == null) {
        Get.snackbar(
          'Error',
          'Debe seleccionar un archivo de contrato',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      controller.createRent();
      Get.snackbar(
        'OK',
        'Creado con éxito',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
