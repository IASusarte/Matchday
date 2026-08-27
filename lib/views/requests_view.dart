import 'package:flutter/material.dart';
import '../data/test_data.dart';
//import '../models/solicitud.dart';
import '../models/participante_partida.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  @override
  Widget build(BuildContext context) {

    final solicitudesPendientes = 
          testSolicitudes.where(
            (s) => s.estado == 'Pendiente',
            ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Solicitudes de participación'),
      ),

      body: Column(
  children: [

    Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        'Solicitudes pendientes: ${solicitudesPendientes.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: solicitudesPendientes.length,
        itemBuilder: (context, index) {

          final solicitud = solicitudesPendientes[index];

          final usuario = testUsuarios.firstWhere(
            (u) => u.id == solicitud.idUsuario,
          );

          final partida = testPartidas.firstWhere(
            (p) => p.id == solicitud.idPartida,
          );

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    usuario.nickname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text('Partida: ${partida.id}'),
                  Text('Lugar: ${partida.lugar}'),
                  Text('Estado: ${solicitud.estado}'),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [

                      ElevatedButton(
                        onPressed: () {

                          final existe =
                              testParticipantes.any(
                            (p) =>
                                p.idUsuario ==
                                    solicitud.idUsuario &&
                                p.idPartida ==
                                    solicitud.idPartida,
                          );

                          if (existe) {
                            return;
                          }

                          testParticipantes.add(
                            ParticipantePartida(
                              id: testParticipantes.length + 1,
                              idUsuario: solicitud.idUsuario,
                              idPartida: solicitud.idPartida,
                            ),
                          );

                          setState(() {
                            solicitud.estado = 'Aceptada';
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Solicitud aceptada',
                              ),
                            ),
                          );
                        },
                        child: const Text('Aceptar'),
                      ),

                      ElevatedButton(
                        onPressed: () {

                          setState(() {
                            solicitud.estado = 'Rechazada';
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Solicitud rechazada',
                              ),
                            ),
                          );
                        },
                        child: const Text('Rechazar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }     
}
