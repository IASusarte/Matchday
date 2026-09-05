import 'package:flutter/material.dart';
import 'rate_players_view.dart';
import '../api/api_match.dart';
import '../data/session.dart';

class PlayerRatingView extends StatefulWidget {
  final int idPartida;

  const PlayerRatingView({
    super.key, 
    required this.idPartida,
  });

  @override
  State<PlayerRatingView> createState() =>
      _PlayerRatingViewState();
  }

  class _PlayerRatingViewState
      extends State<PlayerRatingView> {

        List<dynamic> participantes = [];
        bool cargando = true;

        Future<void> cargarParticipantes() async {
          final data = await MatchApi.obtenerParticipantesDetalle(widget.idPartida);
            setState(() {
              participantes = data.where(
                (p) =>
                    p["id_usuario"] !=
                    Session.usuarioId,
              ).toList();
              cargando = false;
            });
        }

  @override
  void initState() {
    super.initState();
    cargarParticipantes();
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
    if (participantes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Seleccionar jugador',
          ),
        ),
        body: const Center(
          child: Text(
            'No existen jugadores para evaluar',
          ),
        ),
      );

    }

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
          return Card(
            child: ListTile(
              title: Text(participante["nickname"]),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatePlayersView(idUsuario: participante["id_usuario"], idPartida: widget.idPartida),
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