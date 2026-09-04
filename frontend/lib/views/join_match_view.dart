import 'package:flutter/material.dart';
import '../api/api_match.dart';
import 'match_detail_view.dart';

class JoinMatchView extends StatefulWidget {
  const JoinMatchView({super.key});

  @override
  State<JoinMatchView> createState() => _JoinMatchViewState();
}

class _JoinMatchViewState extends State<JoinMatchView> {

  List<dynamic> partidas = [];

  Future<void> cargarPartidas() async {
    final data = await MatchApi.obtenerPartidasActivas();
    setState(() {
      partidas = data;
    });
  }
  @override
  void initState() {
    super.initState();
    cargarPartidas();
  }

  @override
  Widget build(BuildContext context) {

    if (partidas.isEmpty) {
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
        title: const Text('Partidas disponibles'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Partidas disponibles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: partidas.length,
              itemBuilder: (context, index) {
                final partida = partidas[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      'Partida #${partida["id"]}',
                    ),
                    subtitle: Text(
                      'Lugar: ${partida["lugar"]}\n'
                      'Fecha: ${partida["fecha"]}\n'
                      'Hora: ${partida["hora"]}',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                    ),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailView(
                            idPartida: partida["id"],
                          ),
                        ),
                      );

                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
  }
