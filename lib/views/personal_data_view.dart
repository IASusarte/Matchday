import 'package:flutter/material.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text('Datos personales'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Volver'),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Datos personales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _campo('Nombres'),
            _campo('Apellidos'),
            _campo('Correo'),
            _campo('Nickname'),
            _campo('RUT'),
            _campo('Fecha nacimiento'),
            _campo('Sexo'),

            const SizedBox(height: 30),

            const Text(
              'Reestablecer contraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 20),

            _campo('Contraseña actual'),
            _campo('Nueva contraseña'),
            _campo('Confirmar contraseña'),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _campo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          labelText: texto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}