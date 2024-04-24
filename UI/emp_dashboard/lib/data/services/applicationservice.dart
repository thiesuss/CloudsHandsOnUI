import 'package:internalapi/api.dart';
import 'package:meowmed/data/exeptions/crud.dart';
import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/models/service.dart';
import 'package:meowmed/data/services/contractservice.dart';
import 'package:meowmed/data/services/repo.dart';
import 'package:meowmed/data/states/login/context.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';

class ApplicationService implements StatefullObj {
  ApplicationService(ApiClient client) {
    this.client = client;
    this.applicationApi = ApplicationApi(client);
  }

  late ApiClient client;
  late ApplicationApi applicationApi;
  Repo<ApplicationRes> repo = Repo<ApplicationRes>(
      (json) => ApplicationRes.fromJson(json)!,
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

  Future<CachedObj<ApplicationRes>?> nextApplication() async {
    final applicationRes = await applicationApi.nextApplication();
    if (applicationRes == null) {
      return null;
    }
    final cachedObj =
        CachedObj<ApplicationRes>(applicationRes.id!, applicationRes);
    repo.add(cachedObj);
    return cachedObj;
  }

  Future<void> updateApplication(CachedObj<ApplicationRes> application) async {
    final applicationRes = application.getObj();
    applicationRes.contract!.startDate = applicationRes.contract!.startDate.add(Duration(days: 1));
    applicationRes.contract!.endDate = applicationRes.contract!.endDate.add(Duration(days: 1));
    applicationRes.contract!.birthDate.add(Duration(days: 1)); //cat
    applicationRes.customer!.birthDate.add(Duration(days: 1)); //cus
    await applicationApi.updateApplication(applicationRes.id!, applicationRes);
    repo.add(application);
  }

  Future<CachedObj<ApplicationRes>> getApplication(String id) async {
    final applicationRes = await applicationApi.getApplication(id);
    if (applicationRes == null) {
      throw ReadFailed("Application read failed");
    }
    final cachedObj =
        CachedObj<ApplicationRes>(applicationRes.id!, applicationRes);
    repo.add(cachedObj);
    return cachedObj;
  }

  Future<void> acceptApplication(CachedObj<ApplicationRes> cachedObj) async {
    cachedObj.getObj().accepted = true;
    await updateApplication(cachedObj);
  }

  Future<void> declineApplication(CachedObj<ApplicationRes> cachedObj) async {
    cachedObj.getObj().accepted = false;
    await updateApplication(cachedObj);
  }

  Future<double> getRateForApplication(
      CachedObj<ApplicationRes> applicationRes) async {
    ContractService contractService =
        (LoginStateContext.getInstance().state as LoggedInState)
            .contractService;

    final appRes = applicationRes.getObj();

    RateCalculationReq rateCalculationReq = RateCalculationReq(
        coverage: appRes.contract!.coverage,
        breed: appRes.contract!.breed,
        color: appRes.contract!.color,
        birthDate: appRes.contract!.birthDate,
        neutered: appRes.contract!.neutered,
        personality: appRes.contract!.personality,
        environment: appRes.contract!.environment,
        weight: appRes.contract!.weight,
        zipCode: appRes.customer!.address.zipCode);

    final rate = await contractService.getRate(rateCalculationReq);
    return double.parse(rate.rate!.toString());
  }
}
