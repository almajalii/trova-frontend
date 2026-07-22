import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeService {
  final Dio dio;
  GuaranteeService({required this.dio});

  /// GET /guarantees/prefill — auto-fills Steps 1, 2 and 4 for the given
  /// project. Throws ApiException (with a human-readable message) if the
  /// project isn't found, the bid isn't confirmed yet, or the contractor
  /// hasn't completed Company Details.
  Future<GuaranteeRequestModel> fetchPrefill(String projectId) async {
    try {
      final response = await dio.get(
        '/guarantees/prefill',
        queryParameters: {'projectId': projectId},
      );
      return GuaranteeRequestModel.fromPrefillJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// POST /guarantees — submits the full application as multipart/form-data.
  /// Returns the new `guaranteeApplicationId` on success.
  Future<String> submitGuaranteeRequest(GuaranteeRequestModel model) async {
    try {
      final formData = FormData.fromMap({
        'contractorId': model.contractorId ?? '',
        'projectId': model.projectId ?? '',
        'guaranteeType': model.guaranteeType?.name ?? '',
        'guaranteedAmount': model.guaranteedAmount?.toString() ?? '',
        'currency': model.currency,
        'validityStart': model.validityStart?.toIso8601String() ?? '',
        'validityExpiry': model.validityExpiry?.toIso8601String() ?? '',
        'specialConditions': model.specialConditions ?? '',
        'beneficiaryId': model.beneficiaryId ?? '',
        'confirmAccurate': model.confirmAccurate.toString(),
        'agreeIndemnify': model.agreeIndemnify.toString(),
        'acceptTerms': model.acceptTerms.toString(),
        'signatureName': model.signatureName ?? '',
      });

      if (model.signedContractFile != null) {
        formData.files.add(MapEntry(
          'signedContract',
          await MultipartFile.fromFile(model.signedContractFile!.path),
        ));
      }
      if (model.letterOfAwardFile != null) {
        formData.files.add(MapEntry(
          'letterOfAward',
          await MultipartFile.fromFile(model.letterOfAwardFile!.path),
        ));
      }
      for (var i = 0; i < model.otherDocuments.length; i++) {
        formData.files.add(MapEntry(
          'otherDocuments[$i]',
          await MultipartFile.fromFile(model.otherDocuments[i].path),
        ));
      }

      final response = await dio.post('/guarantees', data: formData);
      final data = response.data['data'] as Map<String, dynamic>?;
      return data?['guaranteeApplicationId'] as String? ?? '';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
