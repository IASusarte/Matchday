import 'package:flutter/material.dart';
import 'sports_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              'Registro de usuario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _campo('Nombres'),
            _campo('Apellidos'),
            _campo('Correo'),
            _campo('Nickname'),
            _campo('RUT'),
            _campo('Fecha de nacimiento'),
            _campo('Sexo'),
            _campo('Contraseña'),
            _campo('Confirmar contraseña'),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SportsView(),
                  ),
                );
              },
              child: const Text('Siguiente'),
            )
          ],
        ),
      ),
    );
  }

  Widget _campo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          labelText: texto,
          filled: true,
          fillColor: const Color(0xFF5850EC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}