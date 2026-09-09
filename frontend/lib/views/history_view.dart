import 'package:flutter/material.dart';
import '../data/session.dart';
import '../api/api_user.dart';
import 'player_rating_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>{

  List<dynamic> historial = [];
  List<dynamic> preferencias = [];
  bool cargando = true;
  int? deporteSeleccionado;
  Map<String, dynamic>? reputacion;

  Future<void> cargarHistorial() async {
    final prefs =
        await UserApi.obtenerPreferencias(
      Session.usuarioId!,
    );
    final data =
        await UserApi.obtenerHistorial(
      Session.usuarioId!,
    );
    final prefsActivas = prefs.where(
      (p) => p["activo"] == true,
    ).toList();
    if (prefsActivas.isNotEmpty) {
      deporteSeleccionado =
          prefsActivas.first["id"];
      await cargarReputacion();
    }
    setState(() {
      preferencias = prefsActivas;
      historial = data;
      cargando = false;
    });
  }

  Future<void> cargarReputacion() async {
    if (deporteSeleccionado == null) {
      return;
    }
    final data =
        await UserApi.obtenerReputacionDeporte(
      Session.usuarioId!,
      deporteSeleccionado!,
    );
    setState(() {
      reputacion = data;
    });
  }


  @override
  void initState() {
    super.initState();
    cargarHistorial();
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

    final historialFiltrado = historial.where(
      (p) => p["id_deporte"] == deporteSeleccionado,
    ).toList();


    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text(
          'Historial de partidas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarHistorial
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: preferencias.length,
              itemBuilder: (context, index) {
                final deporte = preferencias[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      deporte["nombre"],
                    ),
                    selected:
                        deporteSeleccionado ==
                        deporte["id"],
                    onSelected: (selected) async {
                      setState(() {
                        deporteSeleccionado =
                            deporte["id"];
                      });
                      await cargarReputacion();
                    },
                  ),
                );
              },
            ),
          ),

          if (reputacion != null)
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child:
              reputacion![
                "cantidad_evaluaciones"
              ] == 0
                  ? const Text(
                      "Sin evaluaciones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    reputacion!["deporte"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Compromiso: ${reputacion!["compromiso"]}',
                  ),
                  Text(
                    'Puntualidad: ${reputacion!["puntualidad"]}',
                  ),
                  Text(
                    'Fair Play: ${reputacion!["fairplay"]}',
                  ),
                  Text(
                    'Nivel de Juego: ${reputacion!["nivel_juego"]}',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Evaluaciones: ${reputacion!["cantidad_evaluaciones"]}',
                  ),
                ],
              ),
            ),
          Expanded(
            child: historialFiltrado.isEmpty
                ? const Center(
                    child: Text(
                      'No posee partidas para este deporte',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 22,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: historialFiltrado.length,
                    itemBuilder: (context, index) {
                      final partida = historialFiltrado[index];
                      Color colorEstado;
                      switch (
                          partida["estado"]) {
                        case 'Finalizada':
                          colorEstado =
                              Colors.grey;
                          break;
                        case 'Completa':
                          colorEstado =
                              Colors.red;
                          break;
                        default:
                          colorEstado =
                              Colors.green;
                      }
                      return Card(
                        color:
                            colorEstado.withValues(
                          alpha: 0.15,
                        ),
                        margin:
                            const EdgeInsets.all(
                          10,
                        ),
                        child: ListTile(
                          title: Text(
                            'Partida #${partida["id"]}',
                          ),
                          subtitle: Text(
                            'Estado: ${partida["estado"]}\n'
                            'Fecha: ${partida["fecha"]}',
                          ),
                          trailing:
                              partida["estado"] == "Finalizada" &&
                              partida["pendiente_puntuar"] == true
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PlayerRatingView(
                                              idPartida:
                                                  partida["id"],
                                            ),
                                          ),
                                        );
                                        await cargarHistorial();
                                      },
                                      child: const Text(
                                        'Puntuar',
                                      ),
                                    )
                                  : null,
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