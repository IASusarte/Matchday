import 'package:flutter/material.dart';
import 'match_detail_view.dart';

class ActiveMatchesView extends StatelessWidget {
  const ActiveMatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas vigentes'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          Card(
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
          ),
        ],
      ),
    );
  }
}