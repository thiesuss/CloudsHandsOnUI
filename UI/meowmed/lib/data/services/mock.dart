import 'package:meowmed/data/models/cachedObj.dart';
import 'package:meowmed/data/states/login/loggedIn.dart';
import 'package:openapi/api.dart';

class MockService {
  Future<void> mock(LoggedInState loggedInState) async {
    final contractS = loggedInState.contractService;
    final customerS = loggedInState.customerService;
    final employeeS = loggedInState.employeeService;

    final employeeList = [
      EmployeeRes(
          id: "ID1234567890",
          firstName: "John",
          lastName: "Doe",
          address: Address(
              street: "Limmerstr",
              houseNumber: "1",
              zipCode: 30519,
              city: "Hannover")),
      EmployeeRes(
          id: "ID1234567891",
          firstName: "Jane",
          lastName: "Doe",
          address: Address(
              street: "Limmerstr",
              houseNumber: "1",
              zipCode: 30519,
              city: "Hannover")),
      EmployeeRes(
          id: "ID1234567892",
          firstName: "Max",
          lastName: "Mustermann",
          address: Address(
              street: "Limmerstr",
              houseNumber: "1",
              zipCode: 30519,
              city: "Hannover")),
    ];

    final customerList = [
      CustomerRes(
        id: "1",
        familyStatus: CustomerResFamilyStatusEnum.geschieden,
        birthDate: DateTime.now(),
        socialSecurityNumber: "1234567890",
        taxId: "1234567890",
        jobStatus: CustomerResJobStatusEnum.arbeitslos,
        bankDetails: BankDetails(iban: "asd", bic: "ad", name: "asd"),
        firstName: "Max",
        lastName: "Mustermann",
        address: Address(
            city: "Musterstadt",
            houseNumber: "1",
            street: "Musterstraße",
            zipCode: 12345),
      ),
      CustomerRes(
        id: "2",
        familyStatus: CustomerResFamilyStatusEnum.geschieden,
        birthDate: DateTime.now(),
        socialSecurityNumber: "1234567890",
        taxId: "1234567890",
        jobStatus: CustomerResJobStatusEnum.arbeitslos,
        bankDetails: BankDetails(iban: "asd", bic: "ad", name: "asd"),
        firstName: "Till",
        lastName: "Lindemann",
        address: Address(
            city: "Musterstadt",
            houseNumber: "1",
            street: "Musterstraße",
            zipCode: 12345),
      ),
      CustomerRes(
        id: "3",
        familyStatus: CustomerResFamilyStatusEnum.geschieden,
        birthDate: DateTime.now(),
        socialSecurityNumber: "1234567890",
        taxId: "1234567890",
        jobStatus: CustomerResJobStatusEnum.arbeitslos,
        bankDetails: BankDetails(iban: "asd", bic: "ad", name: "asd"),
        firstName: "Katy",
        lastName: "Perry",
        address: Address(
            city: "Musterstadt",
            houseNumber: "1",
            street: "Musterstraße",
            zipCode: 12345),
      ),
    ];

    final contractList = [
      ContractRes(
        id: "1",
        customerId: "1",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        coverage: 4,
        catName: 'Butt Nugget',
        breed: 'Tiger',
        color: 'weiß',
        birthDate: DateTime.now(),
        neutered: true,
        personality: 'Schulabbrecher',
        environment: 'Wallstreetbets',
        weight: 6000,
      ),
      ContractRes(
        id: "2",
        customerId: "2",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        coverage: 4,
        catName: 'Big Poo',
        breed: 'Löwe',
        color: 'weiß',
        birthDate: DateTime.now(),
        neutered: true,
        personality: 'dumm',
        environment: 'Wallstreetbets',
        weight: 6000,
      ),
      ContractRes(
        id: "3",
        customerId: "2",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        coverage: 4,
        catName: 'Kitty',
        breed: 'Tiger',
        color: 'weiß',
        birthDate: DateTime.now(),
        neutered: true,
        personality: 'Schulabbrecher',
        environment: 'Wallstreetbets',
        weight: 6000,
      ),
    ];

    for (final employee in employeeList) {
      final cachedObj = CachedObj<EmployeeRes>(employee.id, employee);
      employeeS.injectEmployee(cachedObj);
    }
    for (final customer in customerList) {
      final cachedObj = CachedObj<CustomerRes>(customer.id, customer);
      customerS.injectCustomer(cachedObj);
    }
    for (final contract in contractList) {
      final cachedObj = CachedObj<ContractRes>(contract.id, contract);
      contractS.injectContract(cachedObj);
    }
  }
}
