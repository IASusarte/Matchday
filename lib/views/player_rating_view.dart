import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../models/partida.dart';
import 'rate_players_view.dart';

class PlayerRatingView extends StatelessWidget {
  final Partida partida;
  final int idUsuario;

  const PlayerRatingView({
    super.key, 
    required this.partida,
    required this.idUsuario,
  });

  @override
  Widget build(BuildContext context) {

    final participantes = testParticipantes.where(
      (p) => p.idPartida == partida.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Seleccionar jugador'),
      ),
      body: ListView.builder(
        itemCount: participantes.length,
        itemBuilder: (context, index) {
          final participante = participantes[index];
          final usuario = testUsuarios.firstWhere(
            (u) => u.id == participante.idUsuario
          );
          return Card(
            child: ListTile(
              title: Text(usuario.nickname),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatePlayersView(idUsuario: participante.idUsuario),
                    ),
                  );
                },
                child: const Text('Evaluar'),
              ),
            ),
          );
        },
      )

    );
  }
}