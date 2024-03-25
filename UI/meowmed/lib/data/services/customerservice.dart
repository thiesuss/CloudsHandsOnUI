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
  Repo<CustomerRes> repo = Repo<CustomerRes>();

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

  Future<void> updateCustomer(CustomerReq customerReq) async {
    //TODO: UpdateCustomer hat keine ID?
    // await customerApi.updateCustomer(customerReq.id, customerReq);
    throw UnimplementedError("UpdateCustomer hat keine ID?");
  }
}
