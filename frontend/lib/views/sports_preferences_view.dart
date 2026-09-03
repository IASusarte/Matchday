import 'package:flutter/material.dart';
import '../api/api_sports.dart';
import '../api/api_preference.dart';
import '../api/api_user.dart';
import '../data/session.dart';

class SportsPreferencesView extends StatefulWidget {
  const SportsPreferencesView({super.key});

  @override
  State<SportsPreferencesView> createState() =>
      _SportsPreferencesViewState();
}

class _SportsPreferencesViewState
    extends State<SportsPreferencesView> {

      String obtenerImagen(int idDeporte) {

        switch (idDeporte) {
          case 1:
            return 'assets/images/futbol.png';
          case 2:
            return 'assets/images/tenis.png';
          case 3:
            return 'assets/images/basquet.png';
          case 4:
            return 'assets/images/volei.png';
          default:
            return 'assets/images/futbol.png';
        }
      }

    List<dynamic> deportes = [];
    List<int> seleccionados = [];

    Future<void> cargarDeportes() async {

      final data = await ApiSports.obtenerDeportes();

      setState(() {
        deportes = data;
      });
    }

    Future<void> cargarPreferencias() async {

      final data = await ApiPreference.obtenerPreferencias(
        Session.usuarioId!,
      );

      setState(() {

        seleccionados =
            data.map<int>(
          (d) => d["id"] as int,
        ).toList();

      });

    }

  //bool futbol = true;
  //bool tenis = true;
  //bool basquet = false;
  //bool volei = false;
  @override
  void initState() {
    super.initState();
    cargarDeportes();
    cargarPreferencias();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text('Preferencias deportivas'),
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
                      children: deportes.map((deporte) {

                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                obtenerImagen(
                                  deporte["id"],
                                ),
                                width: 90,
                                height: 90,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                deporte["nombre"],
                              ),
                              Checkbox(
                                value: seleccionados.contains(
                                  deporte["id"],
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      seleccionados.add(
                                        deporte["id"],
                                      );
                                    } else {
                                      seleccionados.remove(
                                        deporte["id"],
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),                
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                if (seleccionados.isEmpty) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Debe seleccionar al menos un deporte",
                      ),
                    ),
                  );

                  return;
                }

                final actuales =
                    await ApiPreference.obtenerPreferencias(
                  Session.usuarioId!,
                );

                for (final deporte in actuales) {

                  await ApiPreference.eliminarPreferencia(
                    Session.usuarioId!,
                    deporte["id"],
                  );

                }

                for (final idDeporte
                    in seleccionados) {

                  await UserApi.agregarPreferencia(
                    Session.usuarioId!,
                    idDeporte,
                  );

                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Preferencias actualizadas",
                    ),
                  ),
                );

              },
              child: const Text('Guardar preferencias'),
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