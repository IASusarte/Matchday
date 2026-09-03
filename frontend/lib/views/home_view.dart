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
import '../data/test_data.dart';
import '../api/api_user.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();

}
class _HomeViewState extends State<HomeView> {

  Map<String, dynamic>? usuario;
  Future<void> cargarUsuario() async {

  final data = await UserApi.obtenerUsuario(Session.usuarioId!);

  if (data == null) return;

  setState(() {
    usuario = data;
  });
}

@override
void initState() {
  super.initState();
  cargarUsuario();
}

  @override
  Widget build(BuildContext context) {

    if (usuario == null) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    }


    final partidasCreadas = testPartidas.where(
      (p) => p.idCreador == Session.usuarioId).length;

    final partidasJugadas = testParticipantes.where(
      (p) => p.idUsuario == Session.usuarioId).length;

    final solicitudesPendientes = testSolicitudes.where(
      (s) => s.idUsuario == Session.usuarioId && 
             s.estado == 'Pendiente').length;

    final evaluaciones = testEvaluaciones.where(
      (e) => e.idEvaluado == Session.usuarioId).toList();

    double reputacion = 0;
      if (evaluaciones.isNotEmpty) {
        double suma = 0;
        for (var e in evaluaciones) {
          suma += (
            e.compromiso +
            e.puntualidad + 
            e.fairplay +
            e.niveldejuego
            ) /4;
        }
        reputacion = suma / evaluaciones.length;
      }

    
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
                usuario != null
                ? "Bienvenido ${usuario!["nickname"]}"
                : "Bienvenido ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: Text(
                  'Reputación: ${reputacion.toStringAsFixed(1)} ⭐'
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.sports_soccer),
                title: Text(
                  'Partidas creadas: $partidasCreadas'
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.groups),
                title: Text(
                  'Partidas jugadas: $partidasJugadas'
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.sports_soccer),
                title: Text(
                  'Solicitudes pendientes: $solicitudesPendientes'
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
                Session.usuarioId = null;        
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