import 'package:flutter/material.dart';
import '../api/api_request.dart';

import '../data/session.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {

  List<dynamic> solicitudes = [];

  Future<void> cargarSolicitudes() async {
    final data = await RequestApi.obtenerSolicitudesRecibidas(Session.usuarioId!);
    setState(() {
      solicitudes = data.where(
        (s) => s["estado"] == "Pendiente",
      ).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    cargarSolicitudes();
  }

  @override
  Widget build(BuildContext context) {


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
        'Solicitudes pendientes: ${solicitudes.length}',
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
        itemCount: solicitudes.length,
        itemBuilder: (context, index) {

          final solicitud = solicitudes[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    solicitud["nickname"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text('Partida: ${solicitud["id_partida"]}'),
                  Text('Lugar: ${solicitud["lugar"]}'),
                  Text('Estado: ${solicitud["estado"]}'),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [

                      ElevatedButton(
                        onPressed: () async {
                          final res = await RequestApi.aceptarSolicitud(
                            solicitud["id_partida"],
                            solicitud["id_solicitud"],
                          );
                          if (!context.mounted) return;
                          if (res?["ok"] == false) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  res?["mensaje"] ??
                                  "No fue posible aceptar la solicitud",
                                ),
                              ),
                            );
                            return;
                          }
                          await cargarSolicitudes();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Solicitud aceptada',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Aceptar',
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          final res = await RequestApi.rechazarSolicitud(
                            solicitud["id_partida"],
                            solicitud["id_solicitud"],
                          );
                          if (!context.mounted) return;
                          if (res?["ok"] == false) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  res?["mensaje"] ??
                                  "No fue posible rechazar la solicitud",
                                ),
                              ),
                            );
                            return;
                          }

                          await cargarSolicitudes();
                          if (!context.mounted) return;
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
