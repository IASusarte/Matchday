import 'package:flutter/material.dart';
//import 'rate_players_view.dart';
import '../models/partida.dart';
import '../data/test_data.dart';
import 'player_rating_view.dart';
//import '../models/participante_partida.dart';
import '../utils/sports_utils.dart';

class MatchDetailView extends StatelessWidget {
  final Partida partida;

  const MatchDetailView({
    super.key, 
    required this.partida});

  @override
  Widget build(BuildContext context) {

    final participantesPartida = testParticipantes.where(
      (p) => p.idPartida == partida.id).toList();

    final participantesActuales = participantesPartida.length;
    final cuposDisponibles = partida.cantJugadores - participantesActuales;
    String estadoPartida;
      if(partida.estado == 'Finalizada'){
        estadoPartida = 'Finalizada';
      } else if (cuposDisponibles <= 0){
        estadoPartida = 'Completa';
      } else {
        estadoPartida = 'Activa';
      }

    final ocupacion = 
    (participantesActuales /
    partida.cantJugadores) * 100;

    final organizador = testUsuarios.firstWhere(
      (u) => u.id == partida.idCreador,
    );


    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Detalle de la partida'),
      ),

  body: Padding(
  padding: const EdgeInsets.all(20),
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            obtenerNombreDeporte(partida.idDeporte),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text('Fecha: ${partida.fecha.toString()}'),
          Text('Hora: ${partida.hora}'),
          Text('Lugar: ${partida.lugar}'),
          Text('Organizador: ${organizador.nickname}'),
          Text('Jugadores requeridos: ${partida.cantJugadores}'),
          Text('Participantes actuales: $participantesActuales',),
          Text('Cupos disponibles: $cuposDisponibles',),
          Text('Ocupación: ${ocupacion.toStringAsFixed(0)}%',),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: estadoPartida == 'Finalizada'
                ? Colors.grey
                : estadoPartida == 'Completa'
                  ? Colors.red
                  : Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              estadoPartida,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text('Estado de la partida: $estadoPartida'),

          const SizedBox(height: 20),

          const Text(
            'Descripción:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'Partido amistoso recreativo.',
          ),

          const SizedBox(height: 20),
                const Text(
                  'Participantes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
            ),
          ),


            ...participantesPartida.map(
                  (participante) {
                    final usuario = testUsuarios.firstWhere(
                      (u) => u.id == participante.idUsuario
                    );
                   return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      usuario.nickname,
                ),
              );
            },
          ),

          const Spacer(),

          Center(
            child: SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5850EC),
                ),

                
                onPressed: () {

                  if(participantesPartida.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No hay participantes para evaluar, deben existir al menos uno para finalizar partida'
                        ),
                      ),
                    );
                  }

                  showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Finalizar Partida'
                      ),
                      content: const Text(
                        '¿Estás seguro que quieres finalizar la partida'
                        'Podrás evaluar a los participantes inmediatamente.'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            partida.estado = 'Finalizada';

                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerRatingView(
                                  partida: partida, idUsuario: 0),
                                ),
                              );
                            
                          } ,
                          child: const Text('Finalizar'),
                        )
                      ],
                    )
                    );
                 
                },
                child: const Text(
                  'Finalizar y puntuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  ),
),
    );
  }
}