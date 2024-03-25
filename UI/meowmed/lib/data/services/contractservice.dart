import 'package:meowmed/data/exeptions/crud.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:meowmed/data/services/repo.dart';
import 'package:openapi/api.dart';

class ContractService implements StatefullObj {
  ContractService(ApiClient client) {
    this.client = client;
    this.contractApi = ContractApi(client);
  }

  late ApiClient client;
  late ContractApi contractApi;
  Repo<ContractRes> repo = Repo<ContractRes>();

  @override
  Future<void> dispose() async {
    await repo.dispose();
  }

  @override
  Future<void> init() {
    throw UnimplementedError();
  }

  Future<List<CachedObj>> getContractsForCustomer(String customerID) async {
    final contractRes = await contractApi.getCustomerContracts(customerID);
    if (contractRes == null) {
      throw ReadFailed("Contract read failed");
    }
    List<CachedObj> cachedObjs = [];
    for (var contract in contractRes) {
      final cachedObj = CachedObj<ContractRes>(contract.id, contract);
      repo.add(cachedObj);
      cachedObjs.add(cachedObj);
    }

    return cachedObjs;
  }

  Future<CachedObj<ContractRes>> getContract(String id) async {
    final contractRes = await contractApi.getContract(id);
    if (contractRes == null) {
      throw ReadFailed("Contract read failed");
    }
    final cachedObj = CachedObj<ContractRes>(contractRes.id, contractRes);
    repo.add(cachedObj);
    return cachedObj;
  }

  Future<CachedObj<ContractRes>> createContract(ContractReq contractReq) async {
    final contractRes = await contractApi.createContract(contractReq);
    if (contractRes == null) {
      throw CreateFailed("Contract creation failed");
    }
    final cachedObj = CachedObj<ContractRes>(contractRes.id, contractRes);
    repo.add(cachedObj);
    return cachedObj;
  }
}
