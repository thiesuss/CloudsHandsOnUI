# openapi.api.CustomerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://api.catinsurance.com/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCustomer**](CustomerApi.md#createcustomer) | **POST** /customers | Create a new customer
[**deleteCustomer**](CustomerApi.md#deletecustomer) | **DELETE** /customers/{customerId} | Delete a customer
[**getCustomer**](CustomerApi.md#getcustomer) | **GET** /customers/{customerId} | Get customer details
[**getCustomerContracts**](CustomerApi.md#getcustomercontracts) | **GET** /customers/{customerId}/contracts | Get customer contracts
[**getCustomers**](CustomerApi.md#getcustomers) | **GET** /customers | Get all customers
[**searchCustomers**](CustomerApi.md#searchcustomers) | **GET** /customers/search | Search for customers
[**updateCustomer**](CustomerApi.md#updatecustomer) | **PATCH** /customers/{customerId} | Update a customer


# **createCustomer**
> CustomerRes createCustomer(customerReq)

Create a new customer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final customerReq = CustomerReq(); // CustomerReq | 

try {
    final result = api_instance.createCustomer(customerReq);
    print(result);
} catch (e) {
    print('Exception when calling CustomerApi->createCustomer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customerReq** | [**CustomerReq**](CustomerReq.md)|  | 

### Return type

[**CustomerRes**](CustomerRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCustomer**
> deleteCustomer(customerId)

Delete a customer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteCustomer(customerId);
} catch (e) {
    print('Exception when calling CustomerApi->deleteCustomer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customerId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustomer**
> CustomerRes getCustomer(customerId)

Get customer details

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getCustomer(customerId);
    print(result);
} catch (e) {
    print('Exception when calling CustomerApi->getCustomer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customerId** | **String**|  | 

### Return type

[**CustomerRes**](CustomerRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustomerContracts**
> List<ContractRes> getCustomerContracts(customerId, page, pageSize)

Get customer contracts

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final page = 56; // int | Page number
final pageSize = 56; // int | Items per page

try {
    final result = api_instance.getCustomerContracts(customerId, page, pageSize);
    print(result);
} catch (e) {
    print('Exception when calling CustomerApi->getCustomerContracts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customerId** | **String**|  | 
 **page** | **int**| Page number | [optional] 
 **pageSize** | **int**| Items per page | [optional] 

### Return type

[**List<ContractRes>**](ContractRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCustomers**
> List<CustomerReq> getCustomers(page, pageSize)

Get all customers

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final page = 56; // int | Page number
final pageSize = 56; // int | Items per page

try {
    final result = api_instance.getCustomers(page, pageSize);
    print(result);
} catch (e) {
    print('Exception when calling CustomerApi->getCustomers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**| Page number | [optional] 
 **pageSize** | **int**| Items per page | [optional] 

### Return type

[**List<CustomerReq>**](CustomerReq.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchCustomers**
> List<CustomerRes> searchCustomers(id, name, lastName, address, page, pageSize)

Search for customers

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final name = name_example; // String | 
final lastName = lastName_example; // String | 
final address = address_example; // String | 
final page = 56; // int | Page number
final pageSize = 56; // int | Items per page

try {
    final result = api_instance.searchCustomers(id, name, lastName, address, page, pageSize);
    print(result);
} catch (e) {
    print('Exception when calling CustomerApi->searchCustomers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [optional] 
 **name** | **String**|  | [optional] 
 **lastName** | **String**|  | [optional] 
 **address** | **String**|  | [optional] 
 **page** | **int**| Page number | [optional] 
 **pageSize** | **int**| Items per page | [optional] 

### Return type

[**List<CustomerRes>**](CustomerRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCustomer**
> updateCustomer(customerId, customerReq)

Update a customer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = CustomerApi();
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final customerReq = CustomerReq(); // CustomerReq | 

try {
    api_instance.updateCustomer(customerId, customerReq);
} catch (e) {
    print('Exception when calling CustomerApi->updateCustomer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customerId** | **String**|  | 
 **customerReq** | [**CustomerReq**](CustomerReq.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

