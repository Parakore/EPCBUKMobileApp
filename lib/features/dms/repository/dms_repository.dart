import '../model/document_model.dart';

class DMSRepository {
  Future<List<AppDocument>> getDocuments() async {
    // Mocking an API call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
}
