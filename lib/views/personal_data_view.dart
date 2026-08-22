import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../utils/reputation_utild.dart';
import '../data/session.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {

    final usuario = usuarioLogueado; 
    final partidasCreadas =
        testPartidas.where(
          (p) => p.idCreador == usuario?.id,
          ).length;

    final evaluacionUsuario =
        testEvaluaciones.where(
          (e) => e.idEvaluado == 1,
        ).toList();
    final promedioCompromiso = calcularPromedio(evaluacionUsuario, (e) => e.compromiso);  
    final promedioPuntualidad = calcularPromedio(evaluacionUsuario, (e) => e.puntualidad);  
    final promedioFairplay = calcularPromedio(evaluacionUsuario, (e) => e.fairplay);  
    final promedioNivelDeJuego = calcularPromedio(evaluacionUsuario, (e) => e.niveldejuego);
    final reputacionGeneral = (promedioCompromiso + promedioPuntualidad + promedioFairplay + promedioNivelDeJuego) / 4;     
    
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

            _campo('Nombres', valor: usuario?.nombres ?? ''),
            _campo('Apellidos', valor: usuario?.apellidos ?? ''),
            _campo('Correo', valor: usuario?.email ?? ''),
            _campo('Nickname', valor: usuario?.nickname ?? ''),
            _campo('RUT', valor: usuario?.rut ?? ''),
            _campo('Fecha nacimiento', valor: usuario?.fechaNacimiento.toString() ?? ''),
            _campo('Sexo', valor: usuario?.sexo ?? ''),

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

            const Text(
              'Reputación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 30),

            Text(
                  'Partidas creadas: $partidasCreadas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),

            Text(
                  'General: ${reputacionGeneral.toStringAsFixed(1)} ⭐',
            ),
            Text(
                  'Compromiso: ${promedioCompromiso.toStringAsFixed(1)} ⭐',
            ),
            Text(
                  'Puntualidad : ${promedioPuntualidad.toStringAsFixed(1)} ⭐',
            ),
            Text(
                  'FairPlay: ${promedioFairplay.toStringAsFixed(1)} ⭐',
            ),
            Text(
                  'Nivel de Juego: ${promedioNivelDeJuego.toStringAsFixed(1)} ⭐',
            ),



            ElevatedButton(
              onPressed: () {},
              child: const Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _campo(
    String texto,
    {String? valor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: TextEditingController(text: valor),
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