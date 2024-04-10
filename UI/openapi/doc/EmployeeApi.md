# openapi.api.EmployeeApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://api.catinsurance.com/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEmployee**](EmployeeApi.md#createemployee) | **POST** /employees | Create a new employee
[**getEmployee**](EmployeeApi.md#getemployee) | **GET** /employees/{employeeId} | Get employee details
[**updateEmployee**](EmployeeApi.md#updateemployee) | **PATCH** /employees | Update an employee


# **createEmployee**
> EmployeeRes createEmployee(employeeReq)

Create a new employee

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = EmployeeApi();
final employeeReq = EmployeeReq(); // EmployeeReq | 

try {
    final result = api_instance.createEmployee(employeeReq);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeApi->createEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeReq** | [**EmployeeReq**](EmployeeReq.md)|  | 

### Return type

[**EmployeeRes**](EmployeeRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEmployee**
> EmployeeRes getEmployee(employeeId)

Get employee details

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = EmployeeApi();
final employeeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getEmployee(employeeId);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeApi->getEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **String**|  | 

### Return type

[**EmployeeRes**](EmployeeRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEmployee**
> updateEmployee(employeeReq)

Update an employee

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = EmployeeApi();
final employeeReq = EmployeeReq(); // EmployeeReq | 

try {
    api_instance.updateEmployee(employeeReq);
} catch (e) {
    print('Exception when calling EmployeeApi->updateEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeReq** | [**EmployeeReq**](EmployeeReq.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

