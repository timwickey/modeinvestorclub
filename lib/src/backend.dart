import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Importing the http package
import 'package:http/browser_client.dart';
import 'package:flutter/foundation.dart';

// Conditional HTTP client depending on the platform (web or mobile)
http.Client createHttpClient() {
  if (kIsWeb) {
    return BrowserClient();
  } else {
    return http.Client();
  }
}

class BackEnd {
  String host = dotenv.env['POSTGRES_HOST'] ?? ''; // Default to an empty string
  String database = dotenv.env['POSTGRES_DATABASE'] ?? '';
  String username = dotenv.env['POSTGRES_USER'] ?? '';
  String password = dotenv.env['POSTGRES_PASSWORD'] ?? '';

  // Constructor to initialize with required parameters
  BackEnd();

  // Initialize resources or connections
  Future<void> init() async {
    // You could initialize a database connection here
    print('Initializing backend...$host');
    await Future.delayed(const Duration(seconds: 1)); // Simulate some delay
    // Perform any initialization tasks, like opening a database connection
    print('Backend initialized!');
  }

  // Any other backend-related methods or properties can be added here
}

// Define a class to represent the data you expect from the API
class ApiResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final String token;
  // create a list of investments
  List<Investment> investments;

  ApiResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.token,
    required this.investments,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var investmentsJson = json['investments'] as List;
    List<Investment> investmentsList =
        investmentsJson.map((i) => Investment.fromJson(i)).toList();

    return ApiResponse(
      id: json['user']['id'],
      firstName: json['user']['firstname'],
      lastName: json['user']['lastname'],
      email: json['user']['email'],
      message: json['message'],
      token: json['token'],
      investments: investmentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'message': message,
      'token': token,
      'investments': investments.map((i) => i.toJson()).toList(),
    };
  }

  int calculateTotalShares() {
    int totalShares = 0;
    for (var investment in investments) {
      totalShares += investment.shares + investment.bonusShares;
    }
    return totalShares;
  }
}

class Investment {
  final int id;
  final double price;
  final int shares;
  final DateTime date;
  final int bonusShares;
  final String round;
  final String shareClass;
  final double effectivePrice;
  final int userId;

  Investment({
    required this.id,
    required this.price,
    required this.shares,
    required this.date,
    required this.bonusShares,
    required this.round,
    required this.shareClass,
    required this.effectivePrice,
    required this.userId,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      shares: json['shares'],
      date: DateTime.parse(json['date']),
      bonusShares: json['bonus_shares'],
      round: json['round'],
      shareClass: json['class'],
      effectivePrice: (json['effective_price'] is String)
          ? double.parse(json['effective_price'])
          : json['effective_price'].toDouble(),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'shares': shares,
      'date': date.toIso8601String(),
      'bonus_shares': bonusShares,
      'round': round,
      'class': shareClass,
      'effective_price': effectivePrice,
      'user_id': userId,
    };
  }
}

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});
}

Future<ApiResult<ApiResponse>> asyncCallApiData(String endpointUrl,
    {String method = 'GET', Map<String, String>? body}) async {
  // Ensure endpointUrl is a valid String
  if (endpointUrl.isEmpty) {
    return ApiResult(error: 'Endpoint URL must be a non-empty string.');
  }

  // Ensure method is either 'GET' or 'POST'
  if (method != 'GET' && method != 'POST') {
    return ApiResult(error: 'Method must be either "GET" or "POST".');
  }

  Uri uri = Uri.parse(endpointUrl);
  final client = http.Client();
  http.Response response;

  try {
    if (method == 'GET') {
      response = await client.get(uri);
    } else {
      response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      ApiResponse data = ApiResponse.fromJson(jsonResponse);

      return ApiResult(data: data); // Return the parsed data
    } else {
      String errorBody = response.body;
      return ApiResult(
          error:
              'Failed to load data: ${response.reasonPhrase}. Error body: $errorBody');
    }
  } catch (e) {
    return ApiResult(error: 'Failed to load data: $e');
  } finally {
    client.close();
  }
}
