// übersichtsseite für daten aus datenbank mit suchfunktion und hinzufügen zum warenkorb
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  final ipAddress = '10.0.2.2'; 
  final url = Uri.parse('http://$ipAddress/api.php');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData); // Process your data here
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error: $e');
  }
}