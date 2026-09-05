import 'package:flutter/material.dart';
import 'match_detail_view.dart';
import '../api/api_match.dart';


class ActiveMatchesView extends StatefulWidget {
  const ActiveMatchesView({super.key});

  @override
  State<ActiveMatchesView> createState() => _ActiveMatchesViewState();
}

class _ActiveMatchesViewState extends State<ActiveMatchesView> {

    List<dynamic> partidas = [];
    bool cargando = true;

    Future<void> cargarPartidas() async {
      final data = await MatchApi.obtenerPartidas();
      setState(() {
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

    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas vigentes'),
      ),

      

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
            itemCount: partidas.length,
            itemBuilder: (context, index) {
              final partida = partidas[index];
              return Card(
                child: ListTile(
                  title: Text('Partida #${partida["id"]}'),
                  subtitle: Text(
                    '${partida["fecha"]}\n'
                    '${partida["hora"]}\n'
                    '${partida["lugar"]}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchDetailView(idPartida: partida["id"]),
                      ),
                    );
                  },
                ),
              );
            },
          )

          /*Card(
            child: ListTile(
              title: const Text('Partido de Fútbol'),
              subtitle: const Text(
                '20/07/2026 - 18:00\nEstadio Municipal',
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MatchDetailView(),
                  ),
                );
              },
            ),
          ),*/
        
      );
  }
}