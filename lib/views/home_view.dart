import 'package:flutter/material.dart';
import 'personal_data_view.dart';
import 'sports_preferences_view.dart';
import 'history_view.dart';
import 'login_view.dart';
import 'create_match_view.dart';
import 'join_match_view.dart';
import 'active_matches_view.dart';
import 'requests_view.dart';
import '../data/session.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF43AAE8),
              ),
              child: Text(
                usuarioLogueado?.nickname ?? 'Invitado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Datos personales'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PersonalDataView(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Preferencias deportivas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SportsPreferencesView(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de partidas'),
              onTap: () 
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryView(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {             
                Navigator.pushAndRemoveUntil(
                context,
                  MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Partida',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateMatchView(),
                  ),
                );
              },
              child: const Text('Crear'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JoinMatchView(),
                  ),
                );
              },
              child: const Text('Unirse'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActiveMatchesView(),
                  ),
                );
              },
              child: const Text('Partidas vigentes'),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RequestsView(),
                  ),
                );
              },
              child: const Text('Solicitudes'),
            ),

            const SizedBox(height: 30),
            ],
            ),
            ),
            
    );
    
  }
}