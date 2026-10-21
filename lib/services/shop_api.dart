import 'dart:convert';
import 'package:http/http.dart' as http;

/// Zentraler API-Zugriff für den Shop.

class ShopApi {
  ShopApi._();
  static final ShopApi instance = ShopApi._();

  static const String baseUrl = 'http://localhost/shop_api/api.php';

  /// Für diesen Starter bleibt der Token bis zum Beenden der App im Speicher.
  String? token;
  Map<String, dynamic>? currentUser;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<dynamic> request(
    String action, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      ...?query,
    });
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(body ?? <String, dynamic>{}))
        .timeout(const Duration(seconds: 15));

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

  Future<List<Map<String, dynamic>>> products() async {
    final result = await request('products');
    return List<Map<String, dynamic>>.from(result as List);
  }

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

  Future<Map<String, dynamic>> checkout() async =>
      Map<String, dynamic>.from(await request('checkout') as Map);

  Future<List<Map<String, dynamic>>> orders() async =>
      List<Map<String, dynamic>>.from(await request('orders') as List);
}
