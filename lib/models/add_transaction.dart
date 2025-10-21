class AddTransaction {
  final String day;
  final String note;
  final double price;
  final bool isPaybyCash;

  AddTransaction({
    required this.day,
    required this.note,
    required this.price,
    required this.isPaybyCash,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'note': note,
      'price': price,
      'isPaybyCash': isPaybyCash,
    };
  }
}

class AddTransactionResponse {
  final bool success;
  final String message;
  final AddTransactionData? data;

  AddTransactionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddTransactionResponse.fromJson(Map<String, dynamic> json) {
    return AddTransactionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AddTransactionData.fromJson(json['data'])
          : null,
    );
  }
}

class AddTransactionData {
  final String sheet;
  final String cell;
  final int day;
  final String note;
  final double price;
  final bool isPaybyCash;
  final String perDayBefore;
  final String perDayAfter;

  AddTransactionData({
    required this.sheet,
    required this.cell,
    required this.day,
    required this.note,
    required this.price,
    required this.isPaybyCash,
    required this.perDayBefore,
    required this.perDayAfter,
  });

  factory AddTransactionData.fromJson(Map<String, dynamic> json) {
    return AddTransactionData(
      sheet: json['sheet']?.toString() ?? '',
      cell: json['cell']?.toString() ?? '',
      day: json['day'] is int
          ? json['day']
          : int.tryParse(json['day']?.toString() ?? '0') ?? 0,
      note: json['note']?.toString() ?? '',
      price: json['price'] is double
          ? json['price']
          : (json['price'] is int
                ? (json['price'] as int).toDouble()
                : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0),
      isPaybyCash: json['isPaybyCash'] ?? false,
      perDayBefore: json['perDayBefore']?.toString() ?? '',
      perDayAfter: json['perDayAfter']?.toString() ?? '',
    );
  }
}

class PerDayResponse {
  final bool success;
  final String message;
  final PerDayData? data;

  PerDayResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PerDayResponse.fromJson(Map<String, dynamic> json) {
    return PerDayResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PerDayData.fromJson(json['data']) : null,
    );
  }
}

class PerDayData {
  final String perDay;

  PerDayData({required this.perDay});

  factory PerDayData.fromJson(Map<String, dynamic> json) {
    return PerDayData(
      perDay: json['perDay']?.toString() ?? '0',
    );
  }
}

class Last5TransactionsResponse {
  final bool success;
  final String message;
  final List<Transaction>? data;

  Last5TransactionsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory Last5TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return Last5TransactionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Transaction.fromJson(item))
              .toList()
          : null,
    );
  }
}

class Transaction {
  final String date;
  final String note;
  final String price;
  final bool isCashed;

  Transaction({
    required this.date,
    required this.note,
    required this.price,
    required this.isCashed,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      isCashed: json['isCashed'] ?? false,
    );
  }
}
