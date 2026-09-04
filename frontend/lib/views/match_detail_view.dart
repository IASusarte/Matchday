import 'package:flutter/material.dart';
//import 'rate_players_view.dart';
//import '../models/partida.dart';
//import 'player_rating_view.dart';
//import '../models/participante_partida.dart';
import '../utils/sports_utils.dart';
import '../api/api_match.dart';
import '../api/api_request.dart';
import '../data/session.dart';

class MatchDetailView extends StatefulWidget {
  final int idPartida;
  

  const MatchDetailView({
    super.key, 
    required this.idPartida});

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
  }

  class _MatchDetailViewState extends State<MatchDetailView> {

  Map<String, dynamic>? partida;

  List<dynamic> participantes = [];

  Future<void> cargarDatos() async {

  final data = await MatchApi.obtenerPartida(widget.idPartida);
  final jugadores = await MatchApi.obtenerParticipantes(widget.idPartida);
  setState(() {
    partida = data;
    participantes = jugadores;
  });
  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }


  @override
  Widget build(BuildContext context) {

    if (partida == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final participantesActuales = participantes.length;

    //final participantesActuales = participantesPartida.length;
    final cuposDisponibles = partida!["cant_jugadores"] - participantesActuales;
    String estadoPartida;
      if(partida!["estado"] == 'Finalizada'){
        estadoPartida = 'Finalizada';
      } else if (cuposDisponibles <= 0){
        estadoPartida = 'Completa';
      } else {
        estadoPartida = 'Activa';
      }

    final ocupacion = 
    (participantesActuales /
    partida!["cant_jugadores"]) * 100;

    Text('Organizador: ${partida!["id_creador"]}');


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
            obtenerNombreDeporte(partida!["id_deporte"]),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text('Fecha: ${partida!["fecha"].toString()}'),
          Text('Hora: ${partida!["hora"].toString()}'),
          Text('Lugar: ${partida!["lugar"].toString()}'),
          Text('Organizador: ${partida!["id_creador"]}'),
          Text('Jugadores requeridos: ${partida!["cant_jugadores"].toString()}'),
          Text('Descripción: ${partida!["descripcion"].toString()}'),
          Text('Participantes actuales: $participantesActuales',),
          Text('Cupos disponibles: $cuposDisponibles',),
          Text('Ocupación: ${ocupacion.toStringAsFixed(0)}%',),

          ElevatedButton(
            onPressed: () async {
              final res = await RequestApi.crearSolicitud(
                idUsuario: Session.usuarioId!,
                idPartida: widget.idPartida,
              );
              if (!context.mounted) return;
              if (res?["ok"] == false) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Ya existe una solicitud para esta partida',
                    ),
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Solicitud enviada correctamente',
                  ),
                ),
              );
            },
            child: const Text(
              'Solicitar participación',
            ),
          ),
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


          ...participantes.map(
            (participante) {

              return ListTile(
                leading: const Icon(
                  Icons.person,
                ),
                title: Text(
                  'Usuario ${participante["id_usuario"]}',
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

                  if(participantes.isEmpty){
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sistema de evaluación en proceso de integración',
                                ),
                              ),
                            );
                          },
                          /*onPressed: () {
                            //partida.estado = 'Finalizada';

                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerRatingView(
                                  partida: partida, idUsuario: 0),
                                ),
                              );
                            
                          } ,*/
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