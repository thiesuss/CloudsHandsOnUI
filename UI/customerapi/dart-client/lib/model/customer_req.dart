//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CustomerReq {
  /// Returns a new [CustomerReq] instance.
  CustomerReq({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.title,
    required this.birthDate,
    required this.socialSecurityNumber,
    required this.taxId,
    required this.address,
    required this.bankDetails,
  });

  String email;

  String firstName;

  String lastName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Title? title;

  DateTime birthDate;

  String socialSecurityNumber;

  String taxId;

  Address address;

  BankDetails bankDetails;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CustomerReq &&
    other.email == email &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.title == title &&
    other.birthDate == birthDate &&
    other.socialSecurityNumber == socialSecurityNumber &&
    other.taxId == taxId &&
    other.address == address &&
    other.bankDetails == bankDetails;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (email.hashCode) +
    (firstName.hashCode) +
    (lastName.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (birthDate.hashCode) +
    (socialSecurityNumber.hashCode) +
    (taxId.hashCode) +
    (address.hashCode) +
    (bankDetails.hashCode);

  @override
  String toString() => 'CustomerReq[email=$email, firstName=$firstName, lastName=$lastName, title=$title, birthDate=$birthDate, socialSecurityNumber=$socialSecurityNumber, taxId=$taxId, address=$address, bankDetails=$bankDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'email'] = this.email;
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
      json[r'birthDate'] = _dateFormatter.format(this.birthDate.toUtc());
      json[r'socialSecurityNumber'] = this.socialSecurityNumber;
      json[r'taxId'] = this.taxId;
      json[r'address'] = this.address;
      json[r'bankDetails'] = this.bankDetails;
    return json;
  }

  /// Returns a new [CustomerReq] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CustomerReq? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CustomerReq[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CustomerReq[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CustomerReq(
        email: mapValueOfType<String>(json, r'email')!,
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        title: Title.fromJson(json[r'title']),
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        socialSecurityNumber: mapValueOfType<String>(json, r'socialSecurityNumber')!,
        taxId: mapValueOfType<String>(json, r'taxId')!,
        address: Address.fromJson(json[r'address'])!,
        bankDetails: BankDetails.fromJson(json[r'bankDetails'])!,
      );
    }
    return null;
  }

  static List<CustomerReq> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerReq>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerReq.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CustomerReq> mapFromJson(dynamic json) {
    final map = <String, CustomerReq>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CustomerReq.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CustomerReq-objects as value to a dart map
  static Map<String, List<CustomerReq>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CustomerReq>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CustomerReq.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'email',
    'firstName',
    'lastName',
    'birthDate',
    'socialSecurityNumber',
    'taxId',
    'address',
    'bankDetails',
  };
}

