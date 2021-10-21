import 'dart:convert';

// Use this function to parse the json data from api
RapperModel allFromJson(String str) => RapperModel.fromJson(jsonDecode(str));

// Json class maps the 'artists' from json, into a map of mulitple Artist's (the class) which has multiple attributes
class RapperModel {
  RapperModel({
    required this.artists,
  });

  List<Rapper> artists;

  factory RapperModel.fromJson(Map<String, dynamic> json) => RapperModel(
        artists: List<Rapper>.from(
          json["artists"].map((x) => Rapper.fromJson(x)),
        ),
      );
}

// As mentioned above, the attributes are id, name, description, and image; there is one of each for each rapper
class Rapper {
  Rapper({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  String id;
  String name;
  String description;
  String image;

  factory Rapper.fromJson(Map<String, dynamic> json) => Rapper(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
      );
}
