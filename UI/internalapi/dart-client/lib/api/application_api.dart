//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ApplicationApi {
  ApplicationApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get an specific Application
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] applicationId (required):
  Future<Response> getApplicationWithHttpInfo(String applicationId,) async {
    // ignore: prefer_const_declarations
    final path = r'/applications/{applicationId}'
      .replaceAll('{applicationId}', applicationId);

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

  /// Get an specific Application
  ///
  /// Parameters:
  ///
  /// * [String] applicationId (required):
  Future<ApplicationRes?> getApplication(String applicationId,) async {
    final response = await getApplicationWithHttpInfo(applicationId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApplicationRes',) as ApplicationRes;
    
    }
    return null;
  }

  /// Get next application
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> nextApplicationWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/nextapplication';

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

  /// Get next application
  Future<ApplicationRes?> nextApplication() async {
    final response = await nextApplicationWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ApplicationRes',) as ApplicationRes;
    
    }
    return null;
  }

  /// Update an Application
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] applicationId (required):
  ///
  /// * [ApplicationRes] applicationRes (required):
  Future<Response> updateApplicationWithHttpInfo(String applicationId, ApplicationRes applicationRes,) async {
    // ignore: prefer_const_declarations
    final path = r'/applications/{applicationId}'
      .replaceAll('{applicationId}', applicationId);

    // ignore: prefer_final_locals
    Object? postBody = applicationRes;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an Application
  ///
  /// Parameters:
  ///
  /// * [String] applicationId (required):
  ///
  /// * [ApplicationRes] applicationRes (required):
  Future<void> updateApplication(String applicationId, ApplicationRes applicationRes,) async {
    final response = await updateApplicationWithHttpInfo(applicationId, applicationRes,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
