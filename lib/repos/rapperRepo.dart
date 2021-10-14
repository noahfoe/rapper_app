import 'package:http/http.dart' as http;
import 'package:rapper_app/models/rapperModel.dart';

class RapperRepo {
// fetchData function to gather data of the rappers from the URL
  Future<RapperModel> fetchData() async {
    // HTTP GET call on the api with json data
    final response = await http.get(
      Uri.parse(
        'http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json',
      ),
    );

    // Response code 200 means OK, so we parse the json data
    if (response.statusCode != 200)
      // Throw exception if not OK
      throw Exception('Error: No data found.');
    return parsedJson(response.body);
  }

  RapperModel parsedJson(final response) {
    final jsonDecoded = allFromJson(response);
    print("Paresed Json - " + jsonDecoded.toString());
    return jsonDecoded;
  }
}
