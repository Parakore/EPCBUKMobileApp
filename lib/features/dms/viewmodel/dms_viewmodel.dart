import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/document_model.dart';
import '../../../providers/providers.dart';

class DMSViewModel extends FamilyAsyncNotifier<List<AppDocument>, String> {
  @override
  Future<List<AppDocument>> build(String arg) async {
    return _fetchDocuments(arg);
  }

  Future<List<AppDocument>> _fetchDocuments(String appId) async {
    return ref.read(dmsRepositoryProvider).getDocuments(appId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDocuments(arg));
  }
}
