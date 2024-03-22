//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class CustomerApi {
  CustomerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new customer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CustomerReq] customerReq (required):
  Future<Response> createCustomerWithHttpInfo(CustomerReq customerReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/customers';

    // ignore: prefer_final_locals
    Object? postBody = customerReq;

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

  /// Create a new customer
  ///
  /// Parameters:
  ///
  /// * [CustomerReq] customerReq (required):
  Future<CustomerRes?> createCustomer(CustomerReq customerReq,) async {
    final response = await createCustomerWithHttpInfo(customerReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CustomerRes',) as CustomerRes;
    
    }
    return null;
  }

  /// Delete a customer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  Future<Response> deleteCustomerWithHttpInfo(String customerId,) async {
    // ignore: prefer_const_declarations
    final path = r'/customers/{customerId}'
      .replaceAll('{customerId}', customerId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete a customer
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  Future<void> deleteCustomer(String customerId,) async {
    final response = await deleteCustomerWithHttpInfo(customerId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get customer details
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  Future<Response> getCustomerWithHttpInfo(String customerId,) async {
    // ignore: prefer_const_declarations
    final path = r'/customers/{customerId}'
      .replaceAll('{customerId}', customerId);

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

  /// Get customer details
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  Future<CustomerRes?> getCustomer(String customerId,) async {
    final response = await getCustomerWithHttpInfo(customerId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CustomerRes',) as CustomerRes;
    
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

  /// Get all customers
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<Response> getCustomersWithHttpInfo({ int? page, int? pageSize, }) async {
    // ignore: prefer_const_declarations
    final path = r'/customers';

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

  /// Get all customers
  ///
  /// Parameters:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<List<CustomerReq>?> getCustomers({ int? page, int? pageSize, }) async {
    final response = await getCustomersWithHttpInfo( page: page, pageSize: pageSize, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CustomerReq>') as List)
        .cast<CustomerReq>()
        .toList(growable: false);

    }
    return null;
  }

  /// Search for customers
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///
  /// * [String] lastName:
  ///
  /// * [String] address:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<Response> searchCustomersWithHttpInfo({ String? id, String? name, String? lastName, String? address, int? page, int? pageSize, }) async {
    // ignore: prefer_const_declarations
    final path = r'/customers/search';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (id != null) {
      queryParams.addAll(_queryParams('', 'id', id));
    }
    if (name != null) {
      queryParams.addAll(_queryParams('', 'name', name));
    }
    if (lastName != null) {
      queryParams.addAll(_queryParams('', 'lastName', lastName));
    }
    if (address != null) {
      queryParams.addAll(_queryParams('', 'address', address));
    }
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

  /// Search for customers
  ///
  /// Parameters:
  ///
  /// * [String] id:
  ///
  /// * [String] name:
  ///
  /// * [String] lastName:
  ///
  /// * [String] address:
  ///
  /// * [int] page:
  ///   Page number
  ///
  /// * [int] pageSize:
  ///   Items per page
  Future<List<CustomerRes>?> searchCustomers({ String? id, String? name, String? lastName, String? address, int? page, int? pageSize, }) async {
    final response = await searchCustomersWithHttpInfo( id: id, name: name, lastName: lastName, address: address, page: page, pageSize: pageSize, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CustomerRes>') as List)
        .cast<CustomerRes>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update a customer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  ///
  /// * [CustomerReq] customerReq (required):
  Future<Response> updateCustomerWithHttpInfo(String customerId, CustomerReq customerReq,) async {
    // ignore: prefer_const_declarations
    final path = r'/customers/{customerId}'
      .replaceAll('{customerId}', customerId);

    // ignore: prefer_final_locals
    Object? postBody = customerReq;

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

  /// Update a customer
  ///
  /// Parameters:
  ///
  /// * [String] customerId (required):
  ///
  /// * [CustomerReq] customerReq (required):
  Future<void> updateCustomer(String customerId, CustomerReq customerReq,) async {
    final response = await updateCustomerWithHttpInfo(customerId, customerReq,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
