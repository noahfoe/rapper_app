import 'package:flutter_test/flutter_test.dart';
import 'package:rapper_app/services/fetchData.dart';
import 'package:rapper_app/services/services.dart';

main() {
  group("Services", () {
    test("Testing Data From fetchData()", () async {
      // Arrange
      List<String> allNames = [
        "Kanye West",
        "Drake",
        "Kendrick Lamar",
        "Future",
        "J. Cole"
      ];
      List<Artist> allArtists = [];

      // Act
      await fetchData().then((data) {
        Json json = allFromJson(data);
        allArtists = json.artists;
      });
      // Assert
      for (int i = 0; i < allNames.length; i++)
        expect(allNames[0], allArtists[0].name);
    });
  });
}
