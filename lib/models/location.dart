class Location {
  String adress;
  String street;
  String postalCode;

  Location(this.adress, this.street, this.postalCode);

  Map<String, dynamic> toJson() {
    return {"adress": adress, "street": street, "postalCode": postalCode};
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(json["adress"] as String, json["street"] as String,
        json["postalCode"] as String);
  }
}
