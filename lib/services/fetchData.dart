import 'package:http/http.dart' as http;

// fetchData function to gather data of the rappers from the URL
Future<String> fetchData() async {
  // HTTP GET call on the api with json data
  final response = await http.get(
    Uri.parse(
      'http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json',
    ),
  );

  // Response code 200 means OK, so we parse the json data
  if (response.statusCode == 200) {
    return response.body;
  } else {
    // Throw exception if not OK
    throw Exception('Error: No data found.');
  }
}
