import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/add_transaction.dart';

class TransactionService {
  static const String baseUrl = 'https://googlespreadsheet.tindecken.xyz/api';

  static Future<AddTransactionResponse> addTransaction(
    AddTransaction transaction,
  ) async {
    try {
      final body = jsonEncode(transaction.toJson());
      print('Request body: $body');

      final response = await http.post(
        Uri.parse('$baseUrl/addTransaction'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AddTransactionResponse.fromJson(jsonResponse);
      } else {
        return AddTransactionResponse(
          success: false,
          message: 'Failed to add transaction: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AddTransactionResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<PerDayResponse> getPerDay() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/perDay'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PerDayResponse.fromJson(jsonResponse);
      } else {
        return PerDayResponse(
          success: false,
          message: 'Failed to get per day: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PerDayResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<Last5TransactionsResponse> getLast5Transactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/last5Transactions'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Last5TransactionsResponse.fromJson(jsonResponse);
      } else {
        return Last5TransactionsResponse(
          success: false,
          message: 'Failed to get transactions: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Last5TransactionsResponse(success: false, message: 'Error: $e');
    }
  }
}
