import 'package:flutter/material.dart';

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
        children: const [

          Center(
            child: Text(
              'No posee ninguna partida registrada en este deporte',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: Text(
              'No posee ninguna partida registrada en este deporte',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}