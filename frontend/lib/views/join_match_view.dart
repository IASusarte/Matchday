import 'package:flutter/material.dart';
import '../api/api_match.dart';
import 'match_detail_view.dart';
import '../data/session.dart';
import '../api/api_user.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../api/api_location.dart';
import '../utils/time_utils.dart';

class JoinMatchView extends StatefulWidget {
  const JoinMatchView({super.key});

  @override
  State<JoinMatchView> createState() => _JoinMatchViewState();
}

class _JoinMatchViewState extends State<JoinMatchView> {

  List<dynamic> partidas = [];
  bool cargando = true;
  List<dynamic> ubicaciones = [];

  Future<void> cargarPartidas() async {
    final data = await MatchApi.obtenerPartidasActivas();
    final preferencias = await UserApi.obtenerPreferencias(Session.usuarioId!);
    final deportesPermitidos =
        preferencias.map<int>(
          (p) => p["id"],
        ).toList();
    final filtradas = data.where(
      (p) =>
          p["id_creador"] != Session.usuarioId &&
          deportesPermitidos.contains(
            p["id_deporte"],
          ),
    ).toList();
    setState(() {
      partidas = filtradas;
      cargando = false;
    });
  }

  Future<void> cargarUbicaciones() async {
    final data =
        await LocationApi.obtenerUbicaciones();
    setState(() {
      ubicaciones = data;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarPartidas();
    cargarUbicaciones();
  }

  @override
  Widget build(BuildContext context) {

    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
            
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarPartidas
          ),
        ],
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
              child: FlutterMap(
                options: MapOptions(
                initialCenter: LatLng(
                  -34.982,
                  -71.239,
                ),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: partidas.map(
                      (p) {
                        final ubicacion = ubicaciones.firstWhere(
                          (u) =>
                            u["id"] ==
                            p["id_ubicacion"],
                        );
                        return Marker(
                          point: LatLng(
                            ubicacion["latitud"],
                            ubicacion["longitud"],
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                    MatchDetailView(
                                      idPartida: p["id"],
                                    ),
                                ),
                              );
                              await cargarPartidas();
                            },
                            child: const Icon(
                              Icons.sports_soccer,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                ],
              )
            ),

            const SizedBox(height: 20),

            

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: partidas.length,
              itemBuilder: (context, index) {
                final partida = partidas[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      'Partida #${partida["id"]}',
                    ),
                    subtitle: Text(
                      '📍 ${partida["lugar"]}\n'
                      '📅 ${partida["fecha"]}\n'
                      '🕒 ${partida["hora"]}\n\n'
                      '⏳ ${obtenerTiempoRestante(
                        partida["fecha"],
                        partida["hora"],
                      )}',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                    ),
                    onTap: () async {

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailView(
                            idPartida: partida["id"],
                          ),
                        ),
                      );
                      await cargarPartidas();
                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
  }
