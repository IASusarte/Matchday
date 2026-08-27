String obtenerNombreDeporte(int idDeporte) {
  switch (idDeporte) {
    case 1:
      return '⚽ Fútbol';

    case 2:
      return '🎾 Tenis';

    case 3:
      return '🏀 Básquetbol';

    case 4:
      return '🏐 Voleibol';

    default:
      return 'Deporte no identificado';

  }
}