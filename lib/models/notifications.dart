List<Nitifications> mynotificationsFromJson(dynamic str) =>
    List<Nitifications>.from(
      (str).map(
        (e) => Nitifications.fromJson(e),
      ),
    );

class Nitifications {
  String? sId;
  String? name;
  String? description;

  int? iV;

  Nitifications({this.sId, this.name, this.description, this.iV});

  Nitifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];

    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;

    data['__v'] = this.iV;
    return data;
  }
}
