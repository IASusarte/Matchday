import 'package:flutter/material.dart';

class SportsPreferencesView extends StatefulWidget {
  const SportsPreferencesView({super.key});

  @override
  State<SportsPreferencesView> createState() =>
      _SportsPreferencesViewState();
}

class _SportsPreferencesViewState
    extends State<SportsPreferencesView> {

  bool futbol = true;
  bool tenis = true;
  bool basquet = false;
  bool volei = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text('Preferencias deportivas'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Volver'),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Preferencias deportivas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
                    volei,
                    (v) => setState(() => volei = v!),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Editar'),
            ),

            const SizedBox(height: 20),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagen,
          width: 90,
          height: 90,
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}