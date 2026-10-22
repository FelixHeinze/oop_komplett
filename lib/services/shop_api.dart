
// Datenfluss:
// Flutter-Seite -> ShopApi -> HTTP/JSON -> api.php -> MariaDB

import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopApi {
  ShopApi._();
  static final ShopApi instance = ShopApi._();

  static const String baseUrl = 'http://localhost/shop_api/api.php';

  /// Für diesen Starter bleibt der Token bis zum Beenden der App im Speicher.
  /// Für dauerhafte Anmeldung kann später flutter_secure_storage ergänzt werden.
  // Nach erfolgreichem Login kommt dieses Token vom Server zurück.
  // Es wird als Bearer-Token an geschützte API-Aufrufe angehängt.
  String? token;
  // Profilkopie für UI-Entscheidungen; der Server bleibt die vertrauenswürdige Quelle.
  Map<String, dynamic>? currentUser;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  // Gemeinsame Methode für HTTP-Anfragen. 'action' wählt den PHP-Endpunkt aus.
  // body enthält die JSON-Daten, query optionale URL-Parameter.
  Future<dynamic> request(
    String action, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      ...?query,
    });
    // JSON wird im Request-Body gesendet. timeout verhindert endloses Warten,
    // falls Apache nicht läuft oder die API nicht antwortet.
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(body ?? <String, dynamic>{}))
        .timeout(const Duration(seconds: 15));

    // Die API sollte immer JSON liefern. Ungültiges HTML (z.B. PHP-Fehlerseite)
    // wird hier in eine verständliche Fehlermeldung umgewandelt.
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Die API hat kein gültiges JSON zurückgegeben. '
          'Prüfe Apache, URL und PHP-Fehler.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map
          ? decoded['error']?.toString() ?? 'HTTP ${response.statusCode}'
          : 'HTTP ${response.statusCode}';
      throw Exception(message);
    }
    if (decoded is Map && decoded['error'] != null) {
      throw Exception(decoded['error'].toString());
    }
    return decoded;
  }

  // Öffentlicher Endpunkt: Artikelliste laden. Jedes Produkt kommt als Map an.
  Future<List<Map<String, dynamic>>> products() async {
    final result = await request('products');
    return List<Map<String, dynamic>>.from(result as List);
  }

  // Registrierungsdaten an PHP senden. Die Datenbank speichert nur den Hash.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await request('register', body: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Login: Die API gibt Token und Profil zurück. Das Token wird für spätere
  // geschützte Aktionen verwendet.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final result = await request('login', body: {
      'email': email,
      'password': password,
    }) as Map<String, dynamic>;
    token = result['token'] as String;
    currentUser = Map<String, dynamic>.from(result['user'] as Map);
  }

  // Abmelden: Server-Session widerrufen und lokale Token-Daten entfernen.
  Future<void> logout() async {
    if (token != null) {
      try {
        await request('logout');
      } finally {
        token = null;
        currentUser = null;
      }
    } else {
      currentUser = null;
    }
  }

  Future<Map<String, dynamic>> profile() async =>
      Map<String, dynamic>.from(await request('profile') as Map);

  // Die API liefert nur Positionen des aktuell angemeldeten Nutzers zurück.
  Future<List<Map<String, dynamic>>> cart() async =>
      List<Map<String, dynamic>>.from(await request('cart') as List);

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    await request('cart_add', body: {
      'product_id': productId,
      'quantity': quantity,
    });
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    await request('cart_update', body: {
      'item_id': itemId,
      'quantity': quantity,
    });
  }

  Future<void> removeCartItem(int itemId) async {
    await request('cart_remove', body: {'item_id': itemId});
  }

  // Checkout erzeugt serverseitig eine Bestellung und leert den Warenkorb.
  Future<Map<String, dynamic>> checkout() async =>
      Map<String, dynamic>.from(await request('checkout') as Map);

  Future<List<Map<String, dynamic>>> orders() async =>
      List<Map<String, dynamic>>.from(await request('orders') as List);

  // Öffentliche, schreibgeschützte Ansichten der importierten Datenbanktabellen.
  // Die API verwendet dafür feste Aktionen und keine frei übergebenen SQL-Namen.
  Future<List<Map<String, dynamic>>> databaseTable(String action) async {
    const allowedActions = {
      'products',
      'db_kunden',
      'db_hersteller',
      'db_bestellungen',
      'db_bestellpositionen',
    };
    if (!allowedActions.contains(action)) {
      throw ArgumentError('Unbekannte Datenbankansicht: $action');
    }
    final result = await request(action);
    return List<Map<String, dynamic>>.from(result as List);
  }
}
