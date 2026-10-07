import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/failure/app_failure.dart';
import '../../../privacy/domain/entities/redaction_result.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../models/analyze_response.dart';

/// The live Khutwa API (#54). The URL and key come from the build config,
/// never from the repository.
class ApiAnalysisRepository implements AnalysisRepository {
  ApiAnalysisRepository({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
    this.timeout = const Duration(seconds: 40),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String apiKey;
  final Duration timeout;
  final http.Client _client;

  @override
  Future<AnalysisResult> analyze(RedactionResult redaction) async {
    final uri = Uri.parse(baseUrl).resolve('/v1/analyze');
    final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            // Only the redacted text ever leaves the phone.
            body: jsonEncode({'text': redaction.redacted}),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const AppFailure(FailureKind.timeout);
    } on SocketException catch (e) {
      throw AppFailure(FailureKind.network, e.message);
    } on http.ClientException catch (e) {
      throw AppFailure(FailureKind.network, e.message);
    }

    return switch (response.statusCode) {
      // Real names go back in here, on the phone, after the response arrives.
      200 => AnalyzeResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      ).restoredWith(redaction),
      401 || 403 => throw const AppFailure(FailureKind.unauthorized),
      _ => throw AppFailure(FailureKind.server, 'HTTP ${response.statusCode}'),
    };
  }
}
