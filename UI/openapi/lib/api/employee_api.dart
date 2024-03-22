//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmployeeApi {
  EmployeeApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeReq] employeeReq (required):
  Future<Response> createEmployeeWithHttpInfo(EmployeeReq employeeReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/employees';

    // ignore: prefer_final_locals
    Object? postBody = employeeReq;

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

  /// Create a new employee
  ///
  /// Parameters:
  ///
  /// * [EmployeeReq] employeeReq (required):
  Future<EmployeeRes?> createEmployee(EmployeeReq employeeReq,) async {
    final response = await createEmployeeWithHttpInfo(employeeReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeRes',) as EmployeeRes;
    
    }
    return null;
  }

  /// Get employee details
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] employeeId (required):
  Future<Response> getEmployeeWithHttpInfo(String employeeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/employees/{employeeId}'
      .replaceAll('{employeeId}', employeeId);

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

  /// Get employee details
  ///
  /// Parameters:
  ///
  /// * [String] employeeId (required):
  Future<EmployeeRes?> getEmployee(String employeeId,) async {
    final response = await getEmployeeWithHttpInfo(employeeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeRes',) as EmployeeRes;
    
    }
    return null;
  }

  /// Update an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeReq] employeeReq (required):
  Future<Response> updateEmployeeWithHttpInfo(EmployeeReq employeeReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/employees';

    // ignore: prefer_final_locals
    Object? postBody = employeeReq;

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

  /// Update an employee
  ///
  /// Parameters:
  ///
  /// * [EmployeeReq] employeeReq (required):
  Future<void> updateEmployee(EmployeeReq employeeReq,) async {
    final response = await updateEmployeeWithHttpInfo(employeeReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
