import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Importing the http package
import 'package:http/browser_client.dart';
import 'package:flutter/foundation.dart';
import '../src/data/globals.dart';

// Conditional HTTP client depending on the platform (web or mobile)
http.Client createHttpClient() {
  if (kIsWeb) {
    return BrowserClient();
  } else {
    return http.Client();
  }
}

class BackEnd {
  // Constructor to initialize with required parameters
  BackEnd();

  Future<int> checkPasswordSet(String email) async {
    String url = '${ApiUrl}/check_new_user';
    int isPasswordSet = 0; // 0 = not set, 1 = set, 2 = user not found.
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['passwordSet'] == false) {
          isPasswordSet = 0;
        } else if (data['passwordSet'] == true) {
          isPasswordSet = 1;
        }
      } else if (response.statusCode == 404) {
        // throw Exception('User not found');
        isPasswordSet = 2;
      } else {
        // throw Exception('Failed to check password');
        isPasswordSet = 0;
      }
    } catch (error) {
      // print('Error checking if password is set: $error');
      isPasswordSet = 0;
    }
    return isPasswordSet;
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

  Future<ApiResult> changePassword(
      String email, String token, String newPassword) async {
    String url = '${ApiUrl}/change_pword';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'email': email, 'token': token, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        return ApiResult(
            data: 'Password changed successfully'); // Success message
      } else {
        String errorBody = response.body;
        return ApiResult(
            error:
                'Failed to change password: ${response.reasonPhrase}. Error body: $errorBody');
      }
    } catch (error) {
      return ApiResult(error: 'Failed to change password: $error');
    }
  }
}

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});
}

class ApiResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final String token;
  final bool forcePassChange;
  final String toShareholderId;
  final String toAccessCode;
  final bool toRegistered;
  final String toRegisterUrl;
  final String toUrl;
  final String address;
  final bool admin;
  List<Investment> investments;
  List<Deal> deals;
  List<Event> events;
  List<Option> options;
  List<StockPriceHistory> stockPriceHistory;

  ApiResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.token,
    required this.forcePassChange,
    required this.toShareholderId,
    required this.toAccessCode,
    required this.toRegistered,
    required this.toRegisterUrl,
    required this.toUrl,
    required this.address,
    required this.admin,
    required this.investments,
    required this.deals,
    required this.events,
    required this.options,
    required this.stockPriceHistory,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var investmentsJson = json['investments'] as List;
    List<Investment> investmentsList =
        investmentsJson.map((i) => Investment.fromJson(i)).toList();

    var dealsJson = json['deals'] as List;
    List<Deal> dealsList = dealsJson.map((d) => Deal.fromJson(d)).toList();

    var eventsJson = json['events'] as List;
    List<Event> eventsList = eventsJson.map((e) => Event.fromJson(e)).toList();

    var optionsJson = json['options'] as List;
    List<Option> optionsList =
        optionsJson.map((o) => Option.fromJson(o)).toList();

    var stockPriceHistoryJson = json['stockPriceHistory'] as List;
    List<StockPriceHistory> stockPriceHistoryList = stockPriceHistoryJson
        .map((sph) => StockPriceHistory.fromJson(sph))
        .toList();

    return ApiResponse(
      id: json['user']['id'],
      firstName: json['user']['first_name'],
      lastName: json['user']['last_name'],
      email: json['user']['email'],
      message: json['message'],
      token: json['token'],
      forcePassChange: json['user']['force_pass_change'] ?? false,
      toShareholderId: json['user']['to_shareholder_id'] ?? '',
      toAccessCode: json['user']['to_access_code'] ?? '',
      toRegistered: json['user']['to_registered'] ?? false,
      toRegisterUrl: json['user']['to_register_url'] ?? '',
      toUrl: json['user']['to_url'] ?? '',
      address: json['user']['address'] ?? '',
      admin: json['user']['admin'] ?? false,
      investments: investmentsList,
      deals: dealsList,
      events: eventsList,
      options: optionsList,
      stockPriceHistory: stockPriceHistoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'message': message,
      'token': token,
      'force_pass_change': forcePassChange,
      'to_shareholder_id': toShareholderId,
      'to_access_code': toAccessCode,
      'to_registered': toRegistered,
      'to_register_url': toRegisterUrl,
      'to_url': toUrl,
      'address': address,
      'admin': admin,
      'investments': investments.map((i) => i.toJson()).toList(),
      'deals': deals.map((d) => d.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'options': options.map((o) => o.toJson()).toList(),
      'stockPriceHistory':
          stockPriceHistory.map((sph) => sph.toJson()).toList(),
    };
  }

  int calculateTotalShares() {
    return investments.fold(
        0,
        (total, investment) =>
            total + investment.shares + investment.bonusShares);
  }

  double getSharePrice() {
    if (stockPriceHistory.isNotEmpty) {
      var sortedStockPriceHistory =
          List<StockPriceHistory>.from(stockPriceHistory);
      sortedStockPriceHistory
          .sort((a, b) => a.actualDate.compareTo(b.actualDate));
      return sortedStockPriceHistory.last.price;
    }
    return 0.0;
  }

  double getPortfolioValue() {
    int totalShares = calculateTotalShares();
    double sharePrice = getSharePrice();
    return totalShares * sharePrice;
  }

  double getCost() {
    return investments.fold(0.0,
        (total, investment) => total + (investment.price * investment.shares));
  }

  int getBonusShares() {
    return investments.fold(
        0, (total, investment) => total + investment.bonusShares);
  }

  double getPricePerShareWithBonus() {
    int totalSharesWithBonus = calculateTotalShares();
    if (totalSharesWithBonus == 0) return 0.0;
    double totalCostWithBonus = investments.fold(
        0.0,
        (total, investment) =>
            total +
            (investment.price * (investment.shares + investment.bonusShares)));
    return totalCostWithBonus / totalSharesWithBonus;
  }

  double getPricePerShareWithoutBonus() {
    int totalShares =
        investments.fold(0, (total, investment) => total + investment.shares);
    if (totalShares == 0) return 0.0;
    double totalCost = investments.fold(0.0,
        (total, investment) => total + (investment.price * investment.shares));
    return totalCost / totalShares;
  }

  double getGain() {
    return getPortfolioValue() - getCost();
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

class Deal {
  final int id;
  final String title;
  final String? image;
  final String partnerName;
  final double price;
  final double originalPrice;
  final String url;

  Deal({
    required this.id,
    required this.title,
    this.image,
    required this.partnerName,
    required this.price,
    required this.originalPrice,
    required this.url,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      partnerName: json['partner_name'],
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      originalPrice: (json['original_price'] is String)
          ? double.parse(json['original_price'])
          : json['original_price'].toDouble(),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'partner_name': partnerName,
      'price': price,
      'original_price': originalPrice,
      'url': url,
    };
  }
}

class Event {
  final int id;
  final String title;
  final String? image;
  final String partnerName;
  final DateTime date;
  final String description;
  final String url;
  final bool active;

  Event({
    required this.id,
    required this.title,
    this.image,
    required this.partnerName,
    required this.date,
    required this.description,
    required this.url,
    required this.active,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      partnerName: json['partner_name'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      url: json['url'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'partner_name': partnerName,
      'date': date.toIso8601String(),
      'description': description,
      'url': url,
      'active': active,
    };
  }
}

class Option {
  final int id;
  final int investmentId;
  final DateTime startDate;
  final Map<String, dynamic> cliffDuration;
  final Map<String, dynamic> vestingDuration;
  final Map<String, dynamic> vestingFrequency;
  final double cliffAmount;
  final double monthlyVestingAmount;

  Option({
    required this.id,
    required this.investmentId,
    required this.startDate,
    required this.cliffDuration,
    required this.vestingDuration,
    required this.vestingFrequency,
    required this.cliffAmount,
    required this.monthlyVestingAmount,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      investmentId: json['investment_id'],
      startDate: DateTime.parse(json['start_date']),
      cliffDuration: json['cliff_duration'],
      vestingDuration: json['vesting_duration'],
      vestingFrequency: json['vesting_frequency'],
      cliffAmount: (json['cliff_amount'] is String)
          ? double.parse(json['cliff_amount'])
          : json['cliff_amount'].toDouble(),
      monthlyVestingAmount: (json['monthly_vesting_amount'] is String)
          ? double.parse(json['monthly_vesting_amount'])
          : json['monthly_vesting_amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investment_id': investmentId,
      'start_date': startDate.toIso8601String(),
      'cliff_duration': cliffDuration,
      'vesting_duration': vestingDuration,
      'vesting_frequency': vestingFrequency,
      'cliff_amount': cliffAmount,
      'monthly_vesting_amount': monthlyVestingAmount,
    };
  }
}

class StockPriceHistory {
  final int id;
  final String title;
  final double price;
  final DateTime displayDate;
  final DateTime actualDate;

  StockPriceHistory({
    required this.id,
    required this.title,
    required this.price,
    required this.displayDate,
    required this.actualDate,
  });

  factory StockPriceHistory.fromJson(Map<String, dynamic> json) {
    return StockPriceHistory(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      displayDate: DateTime.parse(json['display_date']),
      actualDate: DateTime.parse(json['actual_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'display_date': displayDate.toIso8601String(),
      'actual_date': actualDate.toIso8601String(),
    };
  }
}
