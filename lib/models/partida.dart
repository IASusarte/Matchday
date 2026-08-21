class Partida {
  final int id;
  final int idDeporte;
  final DateTime fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final int cantJugadores;
  final String estado;

  Partida({
    required this.id,
    required this.idDeporte,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.descripcion,
    required this.cantJugadores,
    required this.estado,
  });

}