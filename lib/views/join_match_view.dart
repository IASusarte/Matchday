import 'package:flutter/material.dart';
import 'package:proyecto_titulo/utils/sports_utils.dart';
import '../data/test_data.dart';
import '../models/solicitud.dart';
import '../models/partida.dart';
import '../data/session.dart';

class JoinMatchView extends StatelessWidget {
  const JoinMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final partidasDisponibles = testPartidas.where(
              (p) => p.idCreador != usuarioLogueado!.id &&
                     p.estado != 'Finalizada',
            ).toList();
            
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas disponibles'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Partidas disponibles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: partidasDisponibles.length,
              itemBuilder: (context, index) {
                final partida = partidasDisponibles[index];
                return partidaCard(
                  context,
                  partida: partida,
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget partidaCard(
    BuildContext context, {
    required Partida partida,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              obtenerNombreDeporte(partida.idDeporte),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text('Lugar: ${partida.lugar}'),
            Text('Fecha: ${partida.fecha}'),
            Text('Hora: ${partida.hora}'),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                final existeSolicitud = testSolicitudes.any(
                  (s) =>
                      s.idUsuario == usuarioLogueado!.id && 
                      s.idPartida == partida.id,
                );
                if(existeSolicitud) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ya has solicitado unirte a esta partida'),
                    ),
                  );
                  return;
                }
                testSolicitudes.add(
                  Solicitud(
                    id: testSolicitudes.length + 1,
                    idPartida: partida.id,
                    idUsuario: usuarioLogueado!.id,
                    estado: 'Pendiente',
                  )
                );
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Solicitud enviada'),
                    content: const Text(
                      'La solicitud para unirse a la partida ha sido enviada.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final participantesPartida = testParticipantes.where(
                            (p) => p.idPartida == partida.id).length;

                            if(participantesPartida >= 
                              partida.cantJugadores) {

                            ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No hay cupos disponibles'),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Solicitar unirse'),
            ),
          ],
        ),
      ),
    );
  }
}