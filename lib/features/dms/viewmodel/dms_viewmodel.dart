import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/document_model.dart';
import '../repository/dms_repository.dart';

final dmsRepositoryProvider = Provider<DMSRepository>((ref) {
  return DMSRepository();
});

class DMSViewModel extends AsyncNotifier<List<AppDocument>> {
  @override
  Future<List<AppDocument>> build() async {
    return _fetchDocuments();
  }

  Future<List<AppDocument>> _fetchDocuments() async {
    return ref.read(dmsRepositoryProvider).getDocuments();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDocuments());
  }
}

final dmsViewModelProvider = AsyncNotifierProvider<DMSViewModel, List<AppDocument>>(() {
  return DMSViewModel();
});
