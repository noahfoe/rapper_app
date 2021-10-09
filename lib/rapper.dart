// To parse this JSON data, do
//
//     final json = allFromJson(jsonString);

import 'dart:convert';

Json allFromJson(String str) => Json.fromJson(jsonDecode(str));

class Json {
  Json({
    required this.artists,
  });

  List<Artist> artists;

  factory Json.fromJson(Map<String, dynamic> json) => Json(
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
      );
}

class Artist {
  Artist({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  String id;
  String name;
  String description;
  String image;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
      );
}
