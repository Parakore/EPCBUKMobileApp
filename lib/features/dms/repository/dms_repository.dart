import 'package:dio/dio.dart';
import '../model/document_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class DMSRepository {
  final Dio dio;

  DMSRepository(this.dio);

  Future<List<AppDocument>> getDocuments(String? appId) async {
    if (ApiConstants.useMockData) {
      // Mocking an API call
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockDocuments;
    }

    try {
      final response = await dio.get(
        appId != null ? ApiEndpoints.getDocuments(appId) : ApiEndpoints.dms,
      );
      final List<dynamic> data = response.data;
      return data.map((e) => AppDocument.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  Future<void> uploadDocument(String filePath, String category) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return;
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'category': category,
      });
      await dio.post(ApiEndpoints.uploadDocument, data: formData);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<AppDocument> get _mockDocuments => [
        AppDocument(
          id: 'TCA-DOC-101',
          name: 'Site Plan – Sahaspur',
          category: 'Layouts',
          date: '22 Mar 2025',
          status: 'Verified',
          size: '4.2 MB',
        ),
        AppDocument(
          id: 'TCA-DOC-102',
          name: 'Aadhaar Card',
          category: 'ID Proof',
          date: '22 Mar 2025',
          status: 'Verified',
          size: '1.1 MB',
        ),
        AppDocument(
          id: 'TCA-DOC-103',
          name: 'NOC from Panchayat',
          category: 'Clearances',
          date: '24 Mar 2025',
          status: 'Pending',
          size: '2.4 MB',
        ),
        AppDocument(
          id: 'TCA-DOC-104',
          name: 'Tree Inventory Report',
          category: 'Survey',
          date: '25 Mar 2025',
          status: 'Progress',
          size: '5.8 MB',
        ),
      ];
}
