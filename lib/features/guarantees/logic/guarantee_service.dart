import 'package:http/http.dart' as http;
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'guarantee_request_model.dart';

class GuaranteeService {
  // TODO: replace with your real .NET Web API base URL / shared ApiClient
  static const _baseUrl = 'https://YOUR_API_BASE_URL/api/guarantees';

  Future<void> submitGuaranteeRequest(GuaranteeRequestModel model) async {
    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    request.fields.addAll({
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
      request.files.add(
        await http.MultipartFile.fromPath('signedContract', model.signedContractFile!.path),
      );
    }
    if (model.letterOfAwardFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('letterOfAward', model.letterOfAwardFile!.path),
      );
    }
    for (var i = 0; i < model.otherDocuments.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath('otherDocuments[$i]', model.otherDocuments[i].path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to submit guarantee request: ${response.body}');
    }
  }
}