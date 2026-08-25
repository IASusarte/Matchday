import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../data/session.dart';
import '../utils/sports_utils.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>{


  @override
  Widget build(BuildContext context) {

    final misParticipaciones = testParticipantes.where(
      (p) => p.idUsuario == usuarioLogueado?.id,
    ).toList();

    final misPartidas = 
      testPartidas.where(
        (partida) => 
          misParticipaciones.any(
            (participacion) => 
              participacion.idPartida == 
              partida.id,
          ),
    ).toList();

    misPartidas.sort((a, b) => b.fecha.compareTo(a.fecha));

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
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Volver'),
            ),
          ),
        ],
      ),

      body: misPartidas.isEmpty
            ? const Center(
              child: Text(
                'No posee ninguna partida registrada',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: misPartidas.length,
              itemBuilder: (context, index) {

                final partida = misPartidas[index];

                final organizador = testUsuarios.firstWhere(
                  (u) => u.id == partida.idCreador
                );

                final cantParticipantes = testParticipantes.where(
                  (p) => p.idPartida == partida.id
                ).length;

                Color colorEstado;
                switch (partida.estado){

                  case 'Finalizada':
                    colorEstado = Colors.grey;
                    break;

                  case 'Completa':
                    colorEstado = Colors.red;
                    break;

                  default: 
                    colorEstado = Colors.green;
                }

                return Card(
                  color: colorEstado.withValues(alpha: 0.15),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      obtenerNombreDeporte(partida.idDeporte),
                    ),
                    subtitle: Text(
                       'Estado: ${partida.estado}\n'
                       'Organizador: ${organizador.nickname}\n'
                       'Participantes: '
                       '$cantParticipantes/${partida.cantJugadores}''\n'
                       'Lugar: ${partida.lugar}\n'
                       'Fecha: ${partida.fecha}\n'
                       'Hora: ${partida.hora}\n'
                       'Descripción: ${partida.descripcion}\n',
                    ),
                  ),
                );
              },
            ),

    );
  }
}