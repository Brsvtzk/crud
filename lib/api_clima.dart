import 'package:http/http.dart' as http;
import 'dart:convert';

class Main {
  var temperatura;
  double temp;
  double feelsLike;
  int tempMin;
  double tempMax;
  int pressure;
  int humidity;

  Main(
      {this.temp,
      this.feelsLike,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['temp_min'] = this.tempMin;
    data['temp_max'] = this.tempMax;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    return data;
  }

  buscaTemp() async {
    var url =
        'http://api.openweathermap.org/data/2.5/weather?q=sao%20borja&units=metric&lang=pt_br&appid=a4df9586d6404c5d0917ec7f220f9a5a';
    var response = await http.get(url);
    var parsedJson = jsonDecode(response.body);
    print('${parsedJson.runtimeType} : $parsedJson');
    var main = parsedJson['main'];
    var temp = main['temp'];
    this.temperatura = temp;
    print('$temp');
  }
}
