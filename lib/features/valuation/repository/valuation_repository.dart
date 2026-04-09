import 'package:dio/dio.dart';
import '../model/tree_species.dart';
import '../model/valuation_result_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

abstract class ValuationRepository {
  static const List<TreeSpecies> speciesList = [
    TreeSpecies(
        id: 'teak',
        name: 'Teak (Tectona grandis)',
        marketRate: 32000,
        ecoFactor: 1.4),
    TreeSpecies(
        id: 'sal',
        name: 'Sal (Shorea robusta)',
        marketRate: 28000,
        ecoFactor: 1.3),
    TreeSpecies(
        id: 'pine',
        name: 'Chir Pine (Pinus roxburghii)',
        marketRate: 18000,
        ecoFactor: 1.1),
    TreeSpecies(
        id: 'deodar',
        name: 'Deodar (Cedrus deodara)',
        marketRate: 38000,
        ecoFactor: 1.5),
    TreeSpecies(
        id: 'oak',
        name: 'Oak (Quercus spp.)',
        marketRate: 22000,
        ecoFactor: 1.4),
    TreeSpecies(
        id: 'sissoo',
        name: 'Sissoo (Dalbergia sissoo)',
        marketRate: 25000,
        ecoFactor: 1.2),
    TreeSpecies(
        id: 'eucalyptus',
        name: 'Eucalyptus',
        marketRate: 12000,
        ecoFactor: 0.9),
  ];

  static const double baseRate = 15000.0;

  Future<ValuationResultModel> getValuationResult(String applicationId);
}

class ValuationRepositoryImpl implements ValuationRepository {
  final Dio dio;

  ValuationRepositoryImpl(this.dio);

  @override
  Future<ValuationResultModel> getValuationResult(String applicationId) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return ValuationResultModel.mock(applicationId);
    }

    try {
      final response =
          await dio.get(ApiEndpoints.valuationDetail(applicationId));
      return ValuationResultModel.fromJson(response.data);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
