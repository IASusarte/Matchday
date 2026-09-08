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

  Future<void> cargarHistorial() async {
    final prefs = await UserApi.obtenerPreferencias(Session.usuarioId!);
    final data = await UserApi.obtenerHistorial(Session.usuarioId!);
    final prefsActivas = prefs.where(
      (p) => p["activo"] == true,
    ).toList();

    setState(() {

      preferencias = prefsActivas;

      if (prefsActivas.isNotEmpty) {
        deporteSeleccionado =
            prefsActivas.first["id"];
      }

      historial = data;

      cargando = false;
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
                    onSelected: (selected) {
                      setState(() {
                        deporteSeleccionado =
                            deporte["id"];
                      });
                    },
                  ),
                );
              },
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