String obtenerTiempoRestante(
  String fecha,
  String hora,
) {
  final fechaHora = DateTime.parse('${fecha}T${hora}');
  final ahora = DateTime.now();
  final diferencia = fechaHora.difference(ahora);
  if (diferencia.isNegative) {
    final termino = fechaHora.add(
      const Duration(hours: 2),
    );
    if (ahora.isBefore(termino)) {
      return '🟢 Partida en curso';
    }
    return '✅ Finalizada';
  }
  final dias = diferencia.inDays;
  final horas = diferencia.inHours % 24;
  final minutos = diferencia.inMinutes % 60;
  if (dias > 0) {
    return '$dias día(s), $horas hora(s)';
  }
  if (horas > 0) {
    return '$horas hora(s), $minutos minuto(s)';
  }
  return '$minutos minuto(s)';
}