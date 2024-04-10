// import 'package:meowmed/data/exeptions/crud.dart';
// import 'package:meowmed/data/models/cachedObj.dart';
// import 'package:meowmed/data/models/employee.dart';
// import 'package:meowmed/data/models/service.dart';
// import 'package:meowmed/data/services/repo.dart';
// import 'package:openapi/api.dart';

// class EmployeeService implements StatefullObj {
//   EmployeeService(ApiClient client) {
//     this.client = client;
//     this.employeeApi = EmployeeApi(client);
//   }

//   late ApiClient client;
//   late EmployeeApi employeeApi;
//   Repo<EmployeeRes> repo = Repo<EmployeeRes>();

//   @override
//   Future<void> dispose() async {
//     await repo.dispose();
//   }

//   @override
//   Future<void> init() {
//     // TODO: implement init
//     throw UnimplementedError();
//   }

//   Future<CachedObj<EmployeeRes>> createEmployee(EmployeeReq employeeReq) async {
//     final employeeRes = await employeeApi.createEmployee(employeeReq);
//     if (employeeRes == null) {
//       throw CreateFailed("Employee creation failed");
//     }
//     final cachedObj = CachedObj<EmployeeRes>(employeeRes.id, employeeRes);
//     repo.add(cachedObj);
//     return cachedObj;
//   }

//   Future<CachedObj<EmployeeRes>> getEmployee(String id) async {
//     final employeeRes = await employeeApi.getEmployee(id);
//     if (employeeRes == null) {
//       throw ReadFailed("Employee read failed");
//     }
//     final cachedObj = CachedObj<EmployeeRes>(employeeRes.id, employeeRes);
//     repo.add(cachedObj);
//     return cachedObj;
//   }

//   Future<void> updateEmployee(EmployeeReq employeeReq) async {
//     await employeeApi.updateEmployee(employeeReq);
//     // TODO: UpdateEmployee hat keine ID?
//     // repo.add();
//     throw UnimplementedError("UpdateEmployee hat keine ID?");
//   }

//   Future<void> injectEmployee(CachedObj<EmployeeRes> employeeRes) async {
//     repo.add(employeeRes);
//   }
// }
