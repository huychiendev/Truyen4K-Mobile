// models/payment_models.dart

class PaymentOrder {
  final String userId;
  final double amount;
  final String title;
  final String description;
  final String bankCode;
  final List<OrderItem> items;

  PaymentOrder({
    required this.userId,
    required this.amount,
    required this.title,
    required this.description,
    required this.bankCode,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'amount': amount,
    'title': title,
    'description': description,
    'bank_code': bankCode,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class OrderItem {
  final String id;
  final String name;
  final String type;
  final int duration;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'duration': duration,
    'price': price,
  };
}

class PaymentResponse {
  final String transactionId;
  final String orderUrl;

  PaymentResponse({
    required this.transactionId,
    required this.orderUrl,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      transactionId: json['app_trans_id'],
      orderUrl: json['order_url'],
    );
  }
}

class PaymentResult {
  final bool success;
  final String? message;
  final PaymentResponse? data;

  PaymentResult({
    required this.success,
    this.message,
    this.data,
  });
}

// premium/models/payment_models.dart

class PaymentStatus {
  final bool isComplete;
  final String status;
  final String message;

  PaymentStatus({
    required this.isComplete,
    required this.status,
    required this.message,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      isComplete: json['isComplete'] ?? false,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}