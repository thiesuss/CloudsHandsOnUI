import 'package:meowmed/data/exeptions/crud.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/customer.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:meowmed/data/services/repo.dart';
import 'package:meowmed/screens/customer.dart';
import 'package:openapi/api.dart';

class CustomerService implements StatefullObj {
  CustomerService(ApiClient client) {
    this.client = client;
    this.customerApi = CustomerApi(client);
  }

  late ApiClient client;
  late CustomerApi customerApi;
  Repo<CustomerRes> repo = Repo<CustomerRes>(
      (json) => CustomerRes.fromJson(json)!,
      (obj) => {
            ...obj.getObj().toJson(),
            "id": obj.getId(),
          }.toString());

  @override
  Future<void> dispose() async {
    await repo.dispose();
  }

  @override
  Future<void> init() {
    throw UnimplementedError();
  }

  Future<CachedObj<CustomerRes>> createCustomer(CustomerReq customerReq) async {
    final customerRes = await customerApi.createCustomer(customerReq);
    if (customerRes == null) {
      throw CreateFailed("Customer creation failed");
    }
    final cachedObj = CachedObj<CustomerRes>(customerRes.id, customerRes);
    repo.add(cachedObj);
    return cachedObj;
  }

  Future<CachedObj<CustomerRes>> getCustomer(String id) async {
    final customerRes = await customerApi.getCustomer(id);
    if (customerRes == null) {
      throw ReadFailed("Customer read failed");
    }
    final cachedObj = CachedObj<CustomerRes>(customerRes.id, customerRes);
    repo.add(cachedObj);
    return cachedObj;
  }

  Future<void> deleteCustomer(
    String customerId,
  ) async {
    await customerApi.deleteCustomer(customerId);
    await repo.delete(customerId);
  }

  Future<void> updateCustomer(String id, CustomerReq customerReq) async {
    // hoffentlich kein TODO: UpdateCustomer hat keine ID?
    await customerApi.updateCustomer(id, customerReq);
    // throw UnimplementedError("UpdateCustomer hat keine ID?");
  }

  Future<List<CachedObj<CustomerRes>>> getCustomers(
      {int? pageSize, int? page}) async {
    pageSize = pageSize ?? 10;
    page = page ?? 1;
    final customerResList =
        await customerApi.getCustomers(pageSize: pageSize, page: page);
    if (customerResList == null) {
      throw ReadFailed("Customer read failed");
    }
    final cachedObjList = <CachedObj<CustomerRes>>[];
    for (final customerRes in customerResList) {
      final cachedObj = CachedObj<CustomerRes>(customerRes.id, customerRes);
      cachedObjList.add(cachedObj);
      repo.add(cachedObj);
    }
    return cachedObjList;
  }

  Future<List<CachedObj<CustomerRes>>> searchCustomers(
    String text, {
    int? pageSize,
    int? page,
  }) async {
    pageSize = pageSize ?? 10;
    page = page ?? 1;
    final customerResList =
        await customerApi.searchCustomers(text, pageSize: pageSize, page: page);
    if (customerResList == null) {
      throw ReadFailed("Customer search failed");
    }
    final cachedObjList = <CachedObj<CustomerRes>>[];
    for (final customerRes in customerResList) {
      final cachedObj = CachedObj<CustomerRes>(customerRes.id, customerRes);
      cachedObjList.add(cachedObj);
      repo.add(cachedObj);
    }
    
    return cachedObjList;
  }

  Future<void> injectCustomer(CachedObj<CustomerRes> customerRes) async {
    repo.add(customerRes);
  }

  static String familienStatustoString(CustomerReqFamilyStatusEnum familyEnum) {
    switch (familyEnum) {
      case (CustomerReqFamilyStatusEnum.geschieden):
        return 'Geschieden';
      case (CustomerReqFamilyStatusEnum.ledig):
        return 'Ledig';
      case (CustomerReqFamilyStatusEnum.verheiratet):
        return 'Verheiratet';
      case (CustomerReqFamilyStatusEnum.verwitwet):
        return 'Verwitwet';
      default:
        throw 'Kein Familienstatus verfügbar';
    }
  }

  static String titleEnumToString(CustomerReqTitleEnum? titleEnum) {
    switch (titleEnum) {
      case (CustomerReqTitleEnum.drPeriod):
        return 'Dr.';
      case (CustomerReqTitleEnum.drPeriodDrPeriod):
        return 'Dr. Dr.';
      case (CustomerReqTitleEnum.profPeriodDrPeriod):
        return 'Prof. Dr.';
      case (CustomerReqTitleEnum.profPeriodDrPeriodDr):
        return 'Prof. Dr. Dr.';
      case (null):
        return '';
      default:
        throw 'Kein Titel Vorhanden';
    }
  }

  static CustomerReqFamilyStatusEnum familyStatusResToReq(
      CustomerResFamilyStatusEnum familystatus) {
    switch (familystatus) {
      case (CustomerResFamilyStatusEnum.geschieden):
        return CustomerReqFamilyStatusEnum.geschieden;
      case (CustomerResFamilyStatusEnum.ledig):
        return CustomerReqFamilyStatusEnum.ledig;
      case (CustomerResFamilyStatusEnum.verheiratet):
        return CustomerReqFamilyStatusEnum.verheiratet;
      case (CustomerResFamilyStatusEnum.verwitwet):
        return CustomerReqFamilyStatusEnum.verwitwet;
      default:
        throw 'Kein Familienstatus vorhanden';
    }
  }

  static CustomerReqTitleEnum? titleResToReq(CustomerResTitleEnum? titleEnum) {
    switch (titleEnum) {
      case (CustomerResTitleEnum.drPeriod):
        return CustomerReqTitleEnum.drPeriod;
      case (CustomerResTitleEnum.drPeriodDrPeriod):
        return CustomerReqTitleEnum.drPeriodDrPeriod;
      case (CustomerResTitleEnum.profPeriodDrPeriod):
        return CustomerReqTitleEnum.profPeriodDrPeriod;
      case (CustomerResTitleEnum.profPeriodDrPeriodDr):
        return CustomerReqTitleEnum.profPeriodDrPeriodDr;
      case (null):
        return null;
      default:
        throw 'Kein Titel vorhanden';
    }
  }
}
