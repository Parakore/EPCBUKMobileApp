import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/payment_model.dart';
import '../repository/payment_repository.dart';
import '../../../providers/providers.dart';

class PaymentViewModel extends AsyncNotifier<List<PaymentModel>> {
  late final PaymentRepository _repository;

  @override
  Future<List<PaymentModel>> build() async {
    _repository = ref.watch(paymentRepositoryProvider);
    return _fetchPayments();
  }

  Future<List<PaymentModel>> _fetchPayments() async {
    return await _repository.getPayments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPayments());
    // Also invalidate the summary provider
    ref.invalidate(paymentSummaryProvider);
  }
}
