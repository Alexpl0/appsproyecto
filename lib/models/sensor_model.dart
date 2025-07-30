/// Representa el conjunto de datos recibidos desde los sensores Bluetooth.
class SensorData {
  final String temperaturaLM35;
  final String temperaturaDHT;
  final String humedad;
  final String luz;

  SensorData({
    this.temperaturaLM35 = '-',
    this.temperaturaDHT = '-',
    this.humedad = '-',
    this.luz = '-',
  });

  /// Factory constructor para crear una instancia de SensorData desde una trama de texto.
  /// Ejemplo de trama: "25.5|26.0|60.2|85.1"
  factory SensorData.fromRawData(String rawData) {
    final parts = rawData.trim().split('|');
    if (parts.length >= 4) {
      return SensorData(
        temperaturaLM35: parts[0],
        temperaturaDHT: parts[1],
        humedad: parts[2],
        luz: parts[3],
      );
    }
    // Devuelve datos por defecto si la trama no es válida
    return SensorData();
  }
}
