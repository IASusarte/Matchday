import 'package:flutter/material.dart';
import 'home_view.dart';
import '../api/api_user.dart';
import '../api/api_evaluation.dart';
import '../data/session.dart';

class RatePlayersView extends StatefulWidget {

  final int idUsuario;
  final int idPartida;
  const RatePlayersView({super.key, required this.idUsuario, required this.idPartida});

  @override
  State<RatePlayersView> createState() => _RatePlayersViewState();
}

class _RatePlayersViewState extends State<RatePlayersView> {

  Map<String, dynamic>? usuario;

  Future<void> cargarUsuario() async {

    final data = await UserApi.obtenerUsuario(widget.idUsuario);
    if (data == null) return;
    setState(() {
      usuario = data;
    });
  }


  double compromiso = 0;
  double puntualidad = 0;
  double fairplay = 0;
  double nivelJuego = 0;

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

    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        elevation: 0,
        title: const Text(
          'Evaluar jugador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              usuario!["nickname"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            criterio(
              'Compromiso',
              'Qué tan comprometido está con la participación.',
              compromiso,
              (valor) {
                setState(() {
                  compromiso = valor;
                });
              },
            ),

            criterio(
              'Puntualidad',
              'Qué tan puntual llega a la hora acordada.',
              puntualidad,
              (valor) {
                setState(() {
                  puntualidad = valor;
                });
              },
            ),

            criterio(
              'Fair Play',
              'Juego limpio y comportamiento dentro del partido.',
              fairplay,
              (valor) {
                setState(() {
                  fairplay = valor;
                });
              },
            ),

            criterio(
              'Nivel de juego',
              'Nivel técnico y habilidades deportivas.',
              nivelJuego,
              (valor) {
                setState(() {
                  nivelJuego = valor;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 200,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5850EC),
                ),
                onPressed: () async {
                  if (
                    compromiso == 0 ||
                    puntualidad == 0 ||
                    fairplay == 0 ||
                    nivelJuego == 0
                  ) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Debe evaluar todos los criterios',
                        ),
                      ),
                    );

                    return;
                  }
                  final res = await EvaluationApi.crearEvaluacion(
                    idPartida: widget.idPartida,
                    idEvaluador: Session.usuarioId!,
                    idEvaluado: widget.idUsuario,
                    compromiso: compromiso.toInt(),
                    puntualidad: puntualidad.toInt(),
                    fairplay: fairplay.toInt(),
                    nivelJuego: nivelJuego.toInt()
                  );
                  if (!context.mounted) return;
                  if (res?["ok"] == false) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No fue posible guardar la evaluación'
                        ),
                      ),
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Evaluación enviada'),
                      content: const Text('La evaluación fue registrada correctamente.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const HomeView(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Aceptar',
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Enviar evaluación',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget criterio(
    String titulo,
    String descripcion,
    double valorActual,
    Function(double) onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    onChanged((index + 1).toDouble());
                  },
                  icon: Icon(
                    index < valorActual
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
              ),
            ),

            Text(
              '${valorActual.toInt()} / 5 estrellas',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}