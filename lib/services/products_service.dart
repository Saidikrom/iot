
class Status {
  String? status;

  Status({
    this.status,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json["status"],
      );
}

class Services {
    int? humidity;
    int? moisture;
    double? temperature;

    Services({
        this.humidity,
        this.moisture,
        this.temperature,
    });

    factory Services.fromJson(Map<String, dynamic> json) => Services(
        humidity: json["Humidity"],
        moisture: json["Moisture"],
        temperature: json["Temperature"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Humidity": humidity,
        "Moisture": moisture,
        "Temperature": temperature,
    };
}
