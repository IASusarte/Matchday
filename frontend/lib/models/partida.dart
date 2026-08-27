class Partida {
  final int id;
  final int idDeporte;
  final int idCreador;
  final DateTime fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final int cantJugadores;
  String estado;

  Partida({
    required this.id,
    required this.idDeporte,
    required this.idCreador,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.descripcion,
    required this.cantJugadores,
    required this.estado,
  });

}