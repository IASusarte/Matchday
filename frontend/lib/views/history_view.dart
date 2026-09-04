import 'package:flutter/material.dart';
import '../data/session.dart';
//import '../utils/sports_utils.dart';
import '../api/api_user.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>{

  List<dynamic> historial = [];

  Future<void> cargarHistorial() async {
    final data = await UserApi.obtenerHistorial(Session.usuarioId!);
    setState(() {
      historial = data;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    if (historial.isEmpty) {
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

      ),

      body: historial.isEmpty
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
              itemCount: historial.length,
              itemBuilder: (context, index) {

                final partida = historial[index];

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
                    title: Text('Partida #${partida["id"]}'),
                    subtitle: Text(
                       'Estado: ${partida["estado"]}\n'
                       //'Organizador: ${organizador.nickname}\n'
                       //'Participantes: '
                       //'$cantParticipantes/${partida.cantJugadores}''\n'
                       //'Lugar: ${partida.lugar}\n'
                       'Fecha: ${partida["fecha"]}\n'
                       //'Hora: ${partida.hora}\n'
                       //'Descripción: ${partida.descripcion}\n',
                    ),
                  ),
                );
              },
            ),

    );
  }
}