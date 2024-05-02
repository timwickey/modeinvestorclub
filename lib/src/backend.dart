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
  // interger type
  final int id;
  final String firstName;

  // Constructor
  ApiResponse({required this.id, required this.firstName});

  // A factory method to create an ApiResponse from a JSON object
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json['id'], // Adjust the field names to match your API response
      firstName: json['first_name'],
    );
  }
}

// Define a function to call the API
Future<List<ApiResponse>> fetchApiData(String endpointUrl) async {
  // Ensure endpointUrl is a valid String
  if (endpointUrl.isEmpty) {
    throw ArgumentError('Endpoint URL must be a non-empty string.');
  }
  Uri uri = Uri.parse(endpointUrl);

  // Make an HTTP GET request to the specified endpoint
  final client = createHttpClient();
  final response = await client.get(uri);

  print(response.body);

  if (response.statusCode == 200) {
    // Check if the request was successful
    // Parse the response body to a list of JSON objects
    List<dynamic> jsonList = json.decode(response.body);

    // Map each JSON object to an instance of ApiResponse
    List<ApiResponse> data = jsonList.map((json) {
      return ApiResponse.fromJson(json);
    }).toList();

    return data; // Return the list of parsed data
  } else {
    // Handle errors appropriately
    throw Exception('Failed to load data: ${response.reasonPhrase}');
  }
}
