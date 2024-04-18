# customerapi.api.DefaultApi

## Load the API package
```dart
import 'package:customerapi/api.dart';
```

All URIs are relative to *https://api.meowmed.de/customer*

Method | HTTP request | Description
------------- | ------------- | -------------
[**calculateRate**](DefaultApi.md#calculaterate) | **POST** /rate | Calculate rate
[**createApplication**](DefaultApi.md#createapplication) | **POST** /apply | New Customer can apply for a new contract


# **calculateRate**
> RateRes calculateRate(rateCalculationReq)

Calculate rate

### Example
```dart
import 'package:customerapi/api.dart';

final api_instance = DefaultApi();
final rateCalculationReq = RateCalculationReq(); // RateCalculationReq | 

try {
    final result = api_instance.calculateRate(rateCalculationReq);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->calculateRate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **rateCalculationReq** | [**RateCalculationReq**](RateCalculationReq.md)|  | 

### Return type

[**RateRes**](RateRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createApplication**
> String createApplication(applicationReq)

New Customer can apply for a new contract

### Example
```dart
import 'package:customerapi/api.dart';

final api_instance = DefaultApi();
final applicationReq = ApplicationReq(); // ApplicationReq | 

try {
    final result = api_instance.createApplication(applicationReq);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createApplication: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationReq** | [**ApplicationReq**](ApplicationReq.md)|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

