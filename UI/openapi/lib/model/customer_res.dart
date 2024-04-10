//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CustomerRes {
  /// Returns a new [CustomerRes] instance.
  CustomerRes({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.title,
    required this.familyStatus,
    required this.birthDate,
    required this.socialSecurityNumber,
    required this.taxId,
    required this.address,
    required this.bankDetails,
  });

  String id;

  String email;

  String firstName;

  String lastName;

  CustomerResTitleEnum? title;

  CustomerResFamilyStatusEnum familyStatus;

  DateTime birthDate;

  String socialSecurityNumber;

  String taxId;

  Address address;

  BankDetails bankDetails;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CustomerRes &&
    other.id == id &&
    other.email == email &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.title == title &&
    other.familyStatus == familyStatus &&
    other.birthDate == birthDate &&
    other.socialSecurityNumber == socialSecurityNumber &&
    other.taxId == taxId &&
    other.address == address &&
    other.bankDetails == bankDetails;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (email.hashCode) +
    (firstName.hashCode) +
    (lastName.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (familyStatus.hashCode) +
    (birthDate.hashCode) +
    (socialSecurityNumber.hashCode) +
    (taxId.hashCode) +
    (address.hashCode) +
    (bankDetails.hashCode);

  @override
  String toString() => 'CustomerRes[id=$id, email=$email, firstName=$firstName, lastName=$lastName, title=$title, familyStatus=$familyStatus, birthDate=$birthDate, socialSecurityNumber=$socialSecurityNumber, taxId=$taxId, address=$address, bankDetails=$bankDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'email'] = this.email;
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
      json[r'familyStatus'] = this.familyStatus;
      json[r'birthDate'] = _dateFormatter.format(this.birthDate.toUtc());
      json[r'socialSecurityNumber'] = this.socialSecurityNumber;
      json[r'taxId'] = this.taxId;
      json[r'address'] = this.address;
      json[r'bankDetails'] = this.bankDetails;
    return json;
  }

  /// Returns a new [CustomerRes] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CustomerRes? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CustomerRes[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CustomerRes[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CustomerRes(
        id: mapValueOfType<String>(json, r'id')!,
        email: mapValueOfType<String>(json, r'email')!,
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        title: CustomerResTitleEnum.fromJson(json[r'title']),
        familyStatus: CustomerResFamilyStatusEnum.fromJson(json[r'familyStatus'])!,
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        socialSecurityNumber: mapValueOfType<String>(json, r'socialSecurityNumber')!,
        taxId: mapValueOfType<String>(json, r'taxId')!,
        address: Address.fromJson(json[r'address'])!,
        bankDetails: BankDetails.fromJson(json[r'bankDetails'])!,
      );
    }
    return null;
  }

  static List<CustomerRes> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerRes>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerRes.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CustomerRes> mapFromJson(dynamic json) {
    final map = <String, CustomerRes>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CustomerRes.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CustomerRes-objects as value to a dart map
  static Map<String, List<CustomerRes>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CustomerRes>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CustomerRes.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'email',
    'firstName',
    'lastName',
    'familyStatus',
    'birthDate',
    'socialSecurityNumber',
    'taxId',
    'address',
    'bankDetails',
  };
}


class CustomerResTitleEnum {
  /// Instantiate a new enum with the provided [value].
  const CustomerResTitleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const drPeriod = CustomerResTitleEnum._(r'Dr.');
  static const profPeriodDrPeriod = CustomerResTitleEnum._(r'Prof. Dr.');
  static const drPeriodDrPeriod = CustomerResTitleEnum._(r'Dr. Dr.');
  static const profPeriodDrPeriodDr = CustomerResTitleEnum._(r'Prof. Dr. Dr');

  /// List of all possible values in this [enum][CustomerResTitleEnum].
  static const values = <CustomerResTitleEnum>[
    drPeriod,
    profPeriodDrPeriod,
    drPeriodDrPeriod,
    profPeriodDrPeriodDr,
  ];

  static CustomerResTitleEnum? fromJson(dynamic value) => CustomerResTitleEnumTypeTransformer().decode(value);

  static List<CustomerResTitleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerResTitleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerResTitleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CustomerResTitleEnum] to String,
/// and [decode] dynamic data back to [CustomerResTitleEnum].
class CustomerResTitleEnumTypeTransformer {
  factory CustomerResTitleEnumTypeTransformer() => _instance ??= const CustomerResTitleEnumTypeTransformer._();

  const CustomerResTitleEnumTypeTransformer._();

  String encode(CustomerResTitleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CustomerResTitleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CustomerResTitleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Dr.': return CustomerResTitleEnum.drPeriod;
        case r'Prof. Dr.': return CustomerResTitleEnum.profPeriodDrPeriod;
        case r'Dr. Dr.': return CustomerResTitleEnum.drPeriodDrPeriod;
        case r'Prof. Dr. Dr': return CustomerResTitleEnum.profPeriodDrPeriodDr;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CustomerResTitleEnumTypeTransformer] instance.
  static CustomerResTitleEnumTypeTransformer? _instance;
}



class CustomerResFamilyStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CustomerResFamilyStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ledig = CustomerResFamilyStatusEnum._(r'ledig');
  static const verheiratet = CustomerResFamilyStatusEnum._(r'verheiratet');
  static const geschieden = CustomerResFamilyStatusEnum._(r'geschieden');
  static const verwitwet = CustomerResFamilyStatusEnum._(r'verwitwet');

  /// List of all possible values in this [enum][CustomerResFamilyStatusEnum].
  static const values = <CustomerResFamilyStatusEnum>[
    ledig,
    verheiratet,
    geschieden,
    verwitwet,
  ];

  static CustomerResFamilyStatusEnum? fromJson(dynamic value) => CustomerResFamilyStatusEnumTypeTransformer().decode(value);

  static List<CustomerResFamilyStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerResFamilyStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerResFamilyStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CustomerResFamilyStatusEnum] to String,
/// and [decode] dynamic data back to [CustomerResFamilyStatusEnum].
class CustomerResFamilyStatusEnumTypeTransformer {
  factory CustomerResFamilyStatusEnumTypeTransformer() => _instance ??= const CustomerResFamilyStatusEnumTypeTransformer._();

  const CustomerResFamilyStatusEnumTypeTransformer._();

  String encode(CustomerResFamilyStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CustomerResFamilyStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CustomerResFamilyStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ledig': return CustomerResFamilyStatusEnum.ledig;
        case r'verheiratet': return CustomerResFamilyStatusEnum.verheiratet;
        case r'geschieden': return CustomerResFamilyStatusEnum.geschieden;
        case r'verwitwet': return CustomerResFamilyStatusEnum.verwitwet;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CustomerResFamilyStatusEnumTypeTransformer] instance.
  static CustomerResFamilyStatusEnumTypeTransformer? _instance;
}


