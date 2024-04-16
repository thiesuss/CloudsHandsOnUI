import 'package:internalapi/api.dart';
import 'package:meowmed/data/exeptions/crud.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:meowmed/data/services/repo.dart';

class ContractService implements StatefullObj {
  ContractService(ApiClient client) {
    this.client = client;
    this.contractApi = ContractApi(client);
  }

  late ApiClient client;
  late ContractApi contractApi;
  Repo<ContractRes> repo = Repo<ContractRes>(
      (json) => ContractRes.fromJson(json)!,
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

  Future<List<CachedObj<ContractRes>>> getContractsForCustomer(
    String customerID, {
    int? page,
    int? pageSize,
  }) async {
    pageSize = pageSize ?? 10;
    page = page ?? 1;
    final contractRes = await contractApi.getCustomerContracts(customerID,
        page: page, pageSize: pageSize);
    if (contractRes == null) {
      throw ReadFailed("Contract read failed");
    }
    List<CachedObj<ContractRes>> cachedObjs = [];
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

  Future<RateRes> getRate(RateCalculationReq rateCalcReq) async {
    final rateRes = await contractApi.calculateRate(rateCalcReq);
    if (rateRes == null) {
      throw ReadFailed("Rate read failed");
    }
    return rateRes;
  }

  Future<void> injectContract(CachedObj<ContractRes> contract) async {
    repo.add(contract);
  }
}
