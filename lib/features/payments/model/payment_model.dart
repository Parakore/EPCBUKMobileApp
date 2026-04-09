import 'dart:convert';

enum PaymentStatus {
  paid,
  pending,
  processing,
  failed;

  String get label {
    switch (this) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }
}

class PaymentModel {
  final String id;
  final String type;
  final double amount;
  final PaymentStatus status;
  final DateTime date;
  final String? challanNo;

  PaymentModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    this.challanNo,
  });

  PaymentModel copyWith({
    String? id,
    String? type,
    double? amount,
    PaymentStatus? status,
    DateTime? date,
    String? challanNo,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      date: date ?? this.date,
      challanNo: challanNo ?? this.challanNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'amount': amount,
      'status': status.name,
      'date': date.millisecondsSinceEpoch,
      'challanNo': challanNo,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as String,
      type: map['type'] as String,
      amount: map['amount'] as double,
      status: PaymentStatus.values.byName(map['status'] as String),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      challanNo: map['challanNo'] != null ? map['challanNo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PaymentSummary {
  final double totalDisbursed;
  final double pendingAmount;
  final int totalChallans;
  final List<double> monthlyTrend;
  final Map<String, double> fundAllocation;

  PaymentSummary({
    required this.totalDisbursed,
    required this.pendingAmount,
    required this.totalChallans,
    required this.monthlyTrend,
    required this.fundAllocation,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalDisbursed: json['totalDisbursed'],
      pendingAmount: json['pendingAmount'],
      totalChallans: json['totalChallans'],
      monthlyTrend: json['monthlyTrend'].cast<double>(),
      fundAllocation: json['fundAllocation'].cast<String, double>(),
    );
  }
}
