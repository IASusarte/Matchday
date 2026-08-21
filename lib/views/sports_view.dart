import 'package:flutter/material.dart';
import 'login_view.dart';

class SportsView extends StatefulWidget {
  const SportsView({super.key});

  @override
  State<SportsView> createState() => _SportsViewState();
}

class _SportsViewState extends State<SportsView> {

  bool futbol = false;
  bool tenis = false;
  bool basquet = false;
  bool voleibol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 40),

            const Text(
              'Registro de usuario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
                height: 500,

            
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                children: [

                  deporteCard(
                    'assets/images/futbol.png',
                    futbol,
                    (v) => setState(() => futbol = v!),
                  ),

                  deporteCard(
                    'assets/images/tenis.png',
                    tenis,
                    (v) => setState(() => tenis = v!),
                  ),

                  deporteCard(
                    'assets/images/basquet.png',
                    basquet,
                    (v) => setState(() => basquet = v!),
                  ),

                  deporteCard(
                    'assets/images/volei.png',
                    voleibol,
                    (v) => setState(() => voleibol = v!),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Registro'),
                    content: const Text(
                      'Usuario registrado correctamente',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                ),
                                (route) => false,
                            );
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Registrar'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

Widget deporteCard(
  String imagen,
  bool value,
  Function(bool?) onChanged,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        imagen,
        width: 90,
        height: 90,
        fit: BoxFit.contain,
      ),
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}
}