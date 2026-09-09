import 'package:flutter/material.dart';
import 'match_detail_view.dart';
import '../api/api_user.dart';
import '../data/session.dart';
import '../utils/time_utils.dart';


class ActiveMatchesView extends StatefulWidget {
  const ActiveMatchesView({super.key});

  @override
  State<ActiveMatchesView> createState() => _ActiveMatchesViewState();
}

class _ActiveMatchesViewState extends State<ActiveMatchesView> {

    List<dynamic> partidas = [];
    List<dynamic> preferencias = [];
    bool cargando = true;
    int? deporteSeleccionado;

    Future<void> cargarPartidas() async {
      final prefs = await UserApi.obtenerPreferencias(
        Session.usuarioId!,
      );
      final prefsActivas = prefs.where(
        (p) => p["activo"] == true,
      ).toList();
      final data =
        await UserApi.obtenerPartidasVigentes(
          Session.usuarioId!,
        );
      setState(() {
        preferencias = prefsActivas;
        if (prefsActivas.isNotEmpty) {
          deporteSeleccionado =
              prefsActivas.first["id"];
        }
        partidas = data;
        cargando = false;
      });
    }


    @override
    void initState() {
      super.initState();
      cargarPartidas();
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

    final partidasFiltradas = partidas.where(
      (p) => p["id_deporte"] == deporteSeleccionado,
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas vigentes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarPartidas
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
                    label: Text(deporte["nombre"]),
                    selected:
                        deporteSeleccionado == deporte["id"],
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
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: partidasFiltradas.length,
              itemBuilder: (context, index) {

                final partida =
                    partidasFiltradas[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      'Partida #${partida["id"]}',
                    ),
                    subtitle: Text(
                      '📅 ${partida["fecha"]}\n'
                      '🕒 ${partida["hora"]}\n'
                      '📍 ${partida["lugar"]}\n\n'
                      '⏳ ${obtenerTiempoRestante(
                        partida["fecha"],
                        partida["hora"],
                      )}',
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward),
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
          ),
        ],
      ),
    );
  }
}