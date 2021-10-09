import 'dart:convert';

// Use this function to parse the json data from api
Json allFromJson(String str) => Json.fromJson(jsonDecode(str));

// Json class maps the 'artists' from json, into a map of mulitple Artist's (the class) which has multiple attributes
class Json {
  Json({
    required this.artists,
  });

  List<Artist> artists;

  factory Json.fromJson(Map<String, dynamic> json) => Json(
        artists: List<Artist>.from(
          json["artists"].map((x) => Artist.fromJson(x)),
        ),
      );
}

// As mentioned above, the attributes are id, name, description, and image; there is one of each for each rapper
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
