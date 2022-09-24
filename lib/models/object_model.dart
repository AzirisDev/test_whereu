class ObjectModel {
  String latitude;
  String longitude;
  String altitude;
  String identifier;
  String timestamp;
  String floorLabel;
  String horizontalAccuracy;
  String verticalAccuracy;
  String confidenceInLocationAccuracy;
  String activity;

  ObjectModel(
      {this.latitude,
      this.longitude,
      this.altitude,
      this.identifier,
      this.timestamp,
      this.floorLabel,
      this.horizontalAccuracy,
      this.verticalAccuracy,
      this.confidenceInLocationAccuracy,
      this.activity});

  ObjectModel.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    altitude = json['Altitude'];
    identifier = json['Identifier'];
    timestamp = json['Timestamp'];
    floorLabel = json['Floor label'];
    horizontalAccuracy = json['Horizontal accuracy'];
    verticalAccuracy = json['Vertical accuracy'];
    confidenceInLocationAccuracy = json['Confidence in location accuracy'];
    activity = json['Activity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['Altitude'] = this.altitude;
    data['Identifier'] = this.identifier;
    data['Timestamp'] = this.timestamp;
    data['Floor label'] = this.floorLabel;
    data['Horizontal accuracy'] = this.horizontalAccuracy;
    data['Vertical accuracy'] = this.verticalAccuracy;
    data['Confidence in location accuracy'] = this.confidenceInLocationAccuracy;
    data['Activity'] = this.activity;
    return data;
  }
}
