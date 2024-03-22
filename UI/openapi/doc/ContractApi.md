# openapi.api.ContractApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://api.catinsurance.com/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**calculateRate**](ContractApi.md#calculaterate) | **POST** /contracts/rate | Calculate rate
[**createContract**](ContractApi.md#createcontract) | **POST** /contracts | Create a new contract
[**getContract**](ContractApi.md#getcontract) | **GET** /contracts/{contractId} | 
[**getCustomerContracts**](ContractApi.md#getcustomercontracts) | **GET** /customers/{customerId}/contracts | Get customer contracts


# **calculateRate**
> RateRes calculateRate(rateCalculationReq)

Calculate rate

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ContractApi();
final rateCalculationReq = RateCalculationReq(); // RateCalculationReq | 

try {
    final result = api_instance.calculateRate(rateCalculationReq);
    print(result);
} catch (e) {
    print('Exception when calling ContractApi->calculateRate: $e\n');
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

# **createContract**
> ContractRes createContract(contractReq)

Create a new contract

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ContractApi();
final contractReq = ContractReq(); // ContractReq | 

try {
    final result = api_instance.createContract(contractReq);
    print(result);
} catch (e) {
    print('Exception when calling ContractApi->createContract: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contractReq** | [**ContractReq**](ContractReq.md)|  | 

### Return type

[**ContractRes**](ContractRes.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getContract**
> ContractRes getContract(contractId)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ContractApi();
final contractId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getContract(contractId);
    print(result);
} catch (e) {
    print('Exception when calling ContractApi->getContract: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contractId** | **String**|  | 

### Return type

[**ContractRes**](ContractRes.md)

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

final api_instance = ContractApi();
final customerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final page = 56; // int | Page number
final pageSize = 56; // int | Items per page

try {
    final result = api_instance.getCustomerContracts(customerId, page, pageSize);
    print(result);
} catch (e) {
    print('Exception when calling ContractApi->getCustomerContracts: $e\n');
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

