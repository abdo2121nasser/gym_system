class ExcerciesModel {
  List<Excercies>? excercies;

  ExcerciesModel({this.excercies});

  ExcerciesModel.fromJson(Map<String, dynamic> json) {
    if (json['excercies'] != null) {
      excercies = <Excercies>[];
      json['excercies'].forEach((v) {
        excercies!.add(new Excercies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.excercies != null) {
      data['excercies'] = this.excercies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Excercies {
  String? bodyPart;
  String? equipment;
  String? gifUrl;
  String? id;
  String? name;
  String? target;
  List<String>? secondaryMuscles;
  List<String>? instructions;

  Excercies(
      {this.bodyPart,
        this.equipment,
        this.gifUrl,
        this.id,
        this.name,
        this.target,
        this.secondaryMuscles,
        this.instructions});

  Excercies.fromJson(Map<String, dynamic> json) {
    bodyPart = json['bodyPart'];
    equipment = json['equipment'];
    gifUrl = json['gifUrl'];
    id = json['id'];
    name = json['name'];
    target = json['target'];
    secondaryMuscles = json['secondaryMuscles'].cast<String>();
    instructions = json['instructions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bodyPart'] = this.bodyPart;
    data['equipment'] = this.equipment;
    data['gifUrl'] = this.gifUrl;
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    data['secondaryMuscles'] = this.secondaryMuscles;
    data['instructions'] = this.instructions;
    return data;
  }
}
