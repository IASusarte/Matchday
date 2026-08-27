import 'package:flutter/material.dart';
import 'match_detail_view.dart';
//import '../models/partida.dart';
//import '../data/test_data.dart';
import '../utils/sports_utils.dart';
import '../repos/partida_repo.dart';

class ActiveMatchesView extends StatelessWidget {
  const ActiveMatchesView({super.key});

  @override
  Widget build(BuildContext context) {

    final partidaRepo = PartidaRepo();
    final partidas = partidaRepo.obtenerPartidas();

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
                  title: Text(obtenerNombreDeporte(partida.idDeporte)),
                  subtitle: Text(
                    '${partida.fecha}\n'
                    '${partida.hora}\n'
                    '${partida.descripcion}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchDetailView(partida: partida),
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