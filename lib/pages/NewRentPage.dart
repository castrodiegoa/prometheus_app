import 'package:flutter/material.dart';

class NewRentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rentals',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Campos del formulario
            _buildDropdownFormField('Start Date'),
            _buildDropdownFormField('End Date'),
            _buildTextField('Amount'),
            _buildTextField('Total Persons'),
            _buildTextField('Tenant'),
            _buildDropdownForProperty('Property'),
            _buildTextField('Number Of Months Of Rent'),

            Spacer(),

            // Botón para crear el nuevo alquiler
            ElevatedButton(
              onPressed: () {
                // Acción para crear el nuevo alquiler
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Center(
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Constructor de campos de texto con solo borde inferior
  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(), // Borde solo inferior
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }

  // Constructor de campos de dropdown (fechas)
  Widget _buildDropdownFormField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  // Constructor de Dropdown para 'Property'
  Widget _buildDropdownForProperty(String label) {
    String dropdownValue = 'Select Property'; // Valor por defecto

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            items: <String>['Select Property', 'Property 1', 'Property 2'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Acción al seleccionar una propiedad
            },
          ),
        ],
      ),
    );
  }
}


