import '../model/payment_model.dart';

class PaymentRepository {
  Future<List<PaymentModel>> getPayments() async {
    // Mocking API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      PaymentModel(
        id: 'CHL-98441',
        type: 'Timber Compensation',
        amount: 52480.0,
        status: PaymentStatus.paid,
        date: DateTime(2025, 4, 2),
        challanNo: 'CH-25-00389',
      ),
      PaymentModel(
        id: 'CHL-98442',
        type: 'Environmental & NPV',
        amount: 36500.0,
        status: PaymentStatus.pending,
        date: DateTime(2025, 4, 5),
        challanNo: 'CH-25-00412',
      ),
      PaymentModel(
        id: 'CHL-98321',
        type: 'Afforestation Fund',
        amount: 15744.0,
        status: PaymentStatus.processing,
        date: DateTime(2025, 4, 4),
        challanNo: 'CH-25-00398',
      ),
      PaymentModel(
        id: 'CHL-98210',
        type: 'Administrative Charges',
        amount: 8200.0,
        status: PaymentStatus.paid,
        date: DateTime(2025, 3, 28),
        challanNo: 'CH-25-00350',
      ),
    ];
  }

  Future<PaymentSummary> getPaymentSummary() async {
    // Mocking API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return PaymentSummary(
      totalDisbursed: 152480.0,
      pendingAmount: 36500.0,
      totalChallans: 4,
      monthlyTrend: [1.2, 1.8, 1.4, 2.1, 1.9, 2.4, 2.1, 2.8, 2.5, 3.2, 2.9, 3.5], // in ₹ Cr equivalent or L
      fundAllocation: {
        'CAMPA': 30,
        'Afforestation': 20,
        'NPV': 25,
        'Timber': 18,
        'Admin': 7,
      },
    );
  }
}
