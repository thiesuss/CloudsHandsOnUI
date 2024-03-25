import 'package:openapi/api.dart';

extension EmployeeExtension on EmployeeRes {
  String get fullName => '$firstName $lastName';
}
