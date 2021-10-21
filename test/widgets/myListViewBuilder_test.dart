import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rapper_app/models/rapperModel.dart';
import 'package:rapper_app/widgets/myListViewBuilder.dart';

main() {
  group("myListViewBuilder Widget", () {
    testWidgets("Drake should be at top of list", (WidgetTester tester) async {
      List<Rapper> data = [
        Rapper(
            id: "1",
            name: "Kanye West",
            description: "Kanye Description",
            image: "Kanye Image"),
        Rapper(
            id: "2",
            name: "Drake",
            description: "Drake Description",
            image: "Drake Image"),
        Rapper(
            id: "3",
            name: "Kendrick Lamar",
            description: "Kendrick Description",
            image: "Kendrick Image"),
        Rapper(
            id: "4",
            name: "Future",
            description: "Future Description",
            image: "Future Image"),
        Rapper(
            id: "5",
            name: "J. Cole",
            description: "J. Cole Description",
            image: "J. Cole Image"),
      ];
      List<String> images = [
        "/data/user/0/com.example.rapper_app/app_flutter/Kanye West.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Drake.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kendrick Lamar.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Future.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/J. Cole.jpeg",
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: MyListViewBuilder(
            data: data,
            images: images,
          ),
        ),
      );

      // Don't scroll
      await tester.drag(find.byType(ListView), const Offset(0, 0));
      await tester.pump();

      // Because list will be sorted, Drake will be at the top
      final firstArtistFinder = find.text("Drake");
      expect(firstArtistFinder, findsOneWidget);
    });

    testWidgets("Should scroll to F's through J's",
        (WidgetTester tester) async {
      List<Rapper> data = [
        Rapper(
            id: "1",
            name: "Kanye West",
            description: "Kanye Description",
            image: "Kanye Image"),
        Rapper(
            id: "2",
            name: "Drake",
            description: "Drake Description",
            image: "Drake Image"),
        Rapper(
            id: "3",
            name: "Kendrick Lamar",
            description: "Kendrick Description",
            image: "Kendrick Image"),
        Rapper(
            id: "4",
            name: "Future",
            description: "Future Description",
            image: "Future Image"),
        Rapper(
            id: "5",
            name: "J. Cole",
            description: "J. Cole Description",
            image: "J. Cole Image"),
        Rapper(
            id: "6",
            name: "Kanye West",
            description: "Kanye Description",
            image: "Kanye Image"),
        Rapper(
            id: "7",
            name: "Kendrick Lamar",
            description: "Kendrick Description",
            image: "Kendrick Image"),
        Rapper(
            id: "8",
            name: "Future",
            description: "Future Description",
            image: "Future Image"),
        Rapper(
            id: "9",
            name: "J. Cole",
            description: "J. Cole Description",
            image: "J. Cole Image"),
        Rapper(
            id: "10",
            name: "Kanye West",
            description: "Kanye Description",
            image: "Kanye Image"),
        Rapper(
            id: "11",
            name: "Kendrick Lamar",
            description: "Kendrick Description",
            image: "Kendrick Image"),
        Rapper(
            id: "12",
            name: "Future",
            description: "Future Description",
            image: "Future Image"),
        Rapper(
            id: "13",
            name: "J. Cole",
            description: "J. Cole Description",
            image: "J. Cole Image"),
      ];
      List<String> images = [
        "/data/user/0/com.example.rapper_app/app_flutter/Kanye West.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Drake.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kendrick Lamar.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Future.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/J. Cole.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kanye West.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kendrick Lamar.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Future.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/J. Cole.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kanye West.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Kendrick Lamar.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/Future.jpeg",
        "/data/user/0/com.example.rapper_app/app_flutter/J. Cole.jpeg",
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: MyListViewBuilder(
            data: data,
            images: images,
          ),
        ),
      );

      // Scroll to position where F's through J's are displayed, but not A's through E's or K's thorugh Z's
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pump();

      final drakeFinder = find.text("Drake");
      final kanyeFinder = find.text("Kanye West");
      final futureFinder = find.text("Future");
      final kendrickFinder = find.text("Kendrick Lamar");
      final coleFinder = find.text("J. Cole");

      // Should not find kanye, drake, or kendrick lamar, because of alphabetical sorting
      expect(drakeFinder, findsNothing);
      expect(kanyeFinder, findsNothing);
      expect(kendrickFinder, findsNothing);
      // Should find j. cole and future because J's through F's are where ListView is scrolling to
      expect(coleFinder, findsWidgets);
      expect(futureFinder, findsWidgets);
    });
  });
}
