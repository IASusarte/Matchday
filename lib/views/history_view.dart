import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../data/session.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2, // fútbol y tenis
      vsync: this,
    );
  }

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

    final partidasFutbol = misPartidas.where(
      (p) => p.idDeporte == 1,
    ).toList();

    final partidasTenis = misPartidas.where(
      (p) => p.idDeporte == 2,
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

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/futbol.png',
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text('Fútbol'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/tenis.png',
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text('Tenis'),
                ],
              ),
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          partidasFutbol.isEmpty
            ? const Center(
              child: Text(
                'No posee ninguna partida registrada en este deporte',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: partidasFutbol.length,
              itemBuilder: (context, index) {

                final partida = partidasFutbol[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      'Partida ${partida.id}',
                    ),
                    subtitle: Text(
                       'Lugar: ${partida.lugar}\n'
                       'Fecha: ${partida.fecha}\n'
                       'Hora: ${partida.hora}',
                    ),
                  ),
                );
              },
            ),

          partidasTenis.isEmpty
          ? const Center(
              child: Text(
                'No posee ninguna partida registrada en este deporte',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
            itemCount: partidasTenis.length,
            itemBuilder: (context, index) {

              final partida = partidasTenis[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'Partida ${partida.id}',
                  ),
                  subtitle: Text(
                    'Lugar: ${partida.lugar}\n'
                    'Fecha: ${partida.fecha}\n'
                    'Hora: ${partida.hora}',
                  ),
                  ),
                );
                },
              )
        ],
      ),
    );
  }
}