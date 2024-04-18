//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ContractApi {
  ContractApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Calculate rate
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RateCalculationReq] rateCalculationReq (required):
  Future<Response> calculateRateWithHttpInfo(RateCalculationReq rateCalculationReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/contracts/rate';

    // ignore: prefer_final_locals
    Object? postBody = rateCalculationReq;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Calculate rate
  ///
  /// Parameters:
  ///
  /// * [RateCalculationReq] rateCalculationReq (required):
  Future<RateRes?> calculateRate(RateCalculationReq rateCalculationReq,) async {
    final response = await calculateRateWithHttpInfo(rateCalculationReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RateRes',) as RateRes;
    
    }
    return null;
  }

  /// Create a new contract
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ContractReq] contractReq (required):
  Future<Response> createContractWithHttpInfo(ContractReq contractReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/contracts';

    // ignore: prefer_final_locals
    Object? postBody = contractReq;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new contract
  ///
  /// Parameters:
  ///
  /// * [ContractReq] contractReq (required):
  Future<ContractRes?> createContract(ContractReq contractReq,) async {
    final response = await createContractWithHttpInfo(contractReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ContractRes',) as ContractRes;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /contracts/{contractId}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] contractId (required):
  Future<Response> getContractWithHttpInfo(String contractId,) async {
    // ignore: prefer_const_declarations
    final path = r'/contracts/{contractId}'
      .replaceAll('{contractId}', contractId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] contractId (required):
  Future<ContractRes?> getContract(String contractId,) async {
    final response = await getContractWithHttpInfo(contractId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ContractRes',) as ContractRes;
    
    }
    return null;
  }

  /// Get customer contracts
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<Response> getCustomerContractsWithHttpInfo(String customerId, { int? page, int? pageSize, }) async {
    // ignore: prefer_const_declarations
    final path = r'/customers/{customerId}/contracts'
      .replaceAll('{customerId}', customerId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (pageSize != null) {
      queryParams.addAll(_queryParams('', 'pageSize', pageSize));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get customer contracts
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<List<ContractRes>?> getCustomerContracts(String customerId, { int? page, int? pageSize, }) async {
    final response = await getCustomerContractsWithHttpInfo(customerId,  page: page, pageSize: pageSize, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ContractRes>') as List)
        .cast<ContractRes>()
        .toList(growable: false);

    }
    return null;
  }
}
