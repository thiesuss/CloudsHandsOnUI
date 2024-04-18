# internalapi.api.ApplicationApi

## Load the API package
```dart
import 'package:internalapi/api.dart';
```

All URIs are relative to *https://api.meowmed.de/interal*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getApplication**](ApplicationApi.md#getapplication) | **GET** /applications/{applicationId} | Get an specific Application
[**nextApplication**](ApplicationApi.md#nextapplication) | **GET** /nextapplication | Get next application
[**updateApplication**](ApplicationApi.md#updateapplication) | **PATCH** /applications/{applicationId} | Update an Application


# **getApplication**
> ApplicationRes getApplication(applicationId)

Get an specific Application

### Example
```dart
import 'package:internalapi/api.dart';

final api_instance = ApplicationApi();
final applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getApplication(applicationId);
    print(result);
} catch (e) {
    print('Exception when calling ApplicationApi->getApplication: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 

### Return type

[**ApplicationRes**](ApplicationRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **nextApplication**
> ApplicationRes nextApplication()

Get next application

### Example
```dart
import 'package:internalapi/api.dart';

final api_instance = ApplicationApi();

try {
    final result = api_instance.nextApplication();
    print(result);
} catch (e) {
    print('Exception when calling ApplicationApi->nextApplication: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApplicationRes**](ApplicationRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateApplication**
> updateApplication(applicationId, applicationRes)

Update an Application

### Example
```dart
import 'package:internalapi/api.dart';

final api_instance = ApplicationApi();
final applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final applicationRes = ApplicationRes(); // ApplicationRes | 

try {
    api_instance.updateApplication(applicationId, applicationRes);
} catch (e) {
    print('Exception when calling ApplicationApi->updateApplication: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**|  | 
 **applicationRes** | [**ApplicationRes**](ApplicationRes.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

