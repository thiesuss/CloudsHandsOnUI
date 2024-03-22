//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CustomerReq {
  /// Returns a new [CustomerReq] instance.
  CustomerReq({
    required this.firstName,
    required this.lastName,
    this.title,
    required this.familyStatus,
    required this.birthDate,
    required this.socialSecurityNumber,
    required this.taxId,
    required this.jobStatus,
    required this.address,
    required this.bankDetails,
  });

  String firstName;

  String lastName;

  CustomerReqTitleEnum? title;

  CustomerReqFamilyStatusEnum familyStatus;

  DateTime birthDate;

  String socialSecurityNumber;

  String taxId;

  CustomerReqJobStatusEnum jobStatus;

  Address address;

  BankDetails bankDetails;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CustomerReq &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.title == title &&
    other.familyStatus == familyStatus &&
    other.birthDate == birthDate &&
    other.socialSecurityNumber == socialSecurityNumber &&
    other.taxId == taxId &&
    other.jobStatus == jobStatus &&
    other.address == address &&
    other.bankDetails == bankDetails;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (firstName.hashCode) +
    (lastName.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (familyStatus.hashCode) +
    (birthDate.hashCode) +
    (socialSecurityNumber.hashCode) +
    (taxId.hashCode) +
    (jobStatus.hashCode) +
    (address.hashCode) +
    (bankDetails.hashCode);

  @override
  String toString() => 'CustomerReq[firstName=$firstName, lastName=$lastName, title=$title, familyStatus=$familyStatus, birthDate=$birthDate, socialSecurityNumber=$socialSecurityNumber, taxId=$taxId, jobStatus=$jobStatus, address=$address, bankDetails=$bankDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'jobStatus'] = this.jobStatus;
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
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        title: CustomerReqTitleEnum.fromJson(json[r'title']),
        familyStatus: CustomerReqFamilyStatusEnum.fromJson(json[r'familyStatus'])!,
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        socialSecurityNumber: mapValueOfType<String>(json, r'socialSecurityNumber')!,
        taxId: mapValueOfType<String>(json, r'taxId')!,
        jobStatus: CustomerReqJobStatusEnum.fromJson(json[r'jobStatus'])!,
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
    'firstName',
    'lastName',
    'familyStatus',
    'birthDate',
    'socialSecurityNumber',
    'taxId',
    'jobStatus',
    'address',
    'bankDetails',
  };
}


class CustomerReqTitleEnum {
  /// Instantiate a new enum with the provided [value].
  const CustomerReqTitleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const drPeriod = CustomerReqTitleEnum._(r'Dr.');
  static const profPeriodDrPeriod = CustomerReqTitleEnum._(r'Prof. Dr.');
  static const drPeriodDrPeriod = CustomerReqTitleEnum._(r'Dr. Dr.');
  static const profPeriodDrPeriodDr = CustomerReqTitleEnum._(r'Prof. Dr. Dr');

  /// List of all possible values in this [enum][CustomerReqTitleEnum].
  static const values = <CustomerReqTitleEnum>[
    drPeriod,
    profPeriodDrPeriod,
    drPeriodDrPeriod,
    profPeriodDrPeriodDr,
  ];

  static CustomerReqTitleEnum? fromJson(dynamic value) => CustomerReqTitleEnumTypeTransformer().decode(value);

  static List<CustomerReqTitleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerReqTitleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerReqTitleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CustomerReqTitleEnum] to String,
/// and [decode] dynamic data back to [CustomerReqTitleEnum].
class CustomerReqTitleEnumTypeTransformer {
  factory CustomerReqTitleEnumTypeTransformer() => _instance ??= const CustomerReqTitleEnumTypeTransformer._();

  const CustomerReqTitleEnumTypeTransformer._();

  String encode(CustomerReqTitleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CustomerReqTitleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CustomerReqTitleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Dr.': return CustomerReqTitleEnum.drPeriod;
        case r'Prof. Dr.': return CustomerReqTitleEnum.profPeriodDrPeriod;
        case r'Dr. Dr.': return CustomerReqTitleEnum.drPeriodDrPeriod;
        case r'Prof. Dr. Dr': return CustomerReqTitleEnum.profPeriodDrPeriodDr;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CustomerReqTitleEnumTypeTransformer] instance.
  static CustomerReqTitleEnumTypeTransformer? _instance;
}



class CustomerReqFamilyStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CustomerReqFamilyStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ledig = CustomerReqFamilyStatusEnum._(r'ledig');
  static const verheiratet = CustomerReqFamilyStatusEnum._(r'verheiratet');
  static const geschieden = CustomerReqFamilyStatusEnum._(r'geschieden');
  static const verwitwet = CustomerReqFamilyStatusEnum._(r'verwitwet');

  /// List of all possible values in this [enum][CustomerReqFamilyStatusEnum].
  static const values = <CustomerReqFamilyStatusEnum>[
    ledig,
    verheiratet,
    geschieden,
    verwitwet,
  ];

  static CustomerReqFamilyStatusEnum? fromJson(dynamic value) => CustomerReqFamilyStatusEnumTypeTransformer().decode(value);

  static List<CustomerReqFamilyStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerReqFamilyStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerReqFamilyStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CustomerReqFamilyStatusEnum] to String,
/// and [decode] dynamic data back to [CustomerReqFamilyStatusEnum].
class CustomerReqFamilyStatusEnumTypeTransformer {
  factory CustomerReqFamilyStatusEnumTypeTransformer() => _instance ??= const CustomerReqFamilyStatusEnumTypeTransformer._();

  const CustomerReqFamilyStatusEnumTypeTransformer._();

  String encode(CustomerReqFamilyStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CustomerReqFamilyStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CustomerReqFamilyStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ledig': return CustomerReqFamilyStatusEnum.ledig;
        case r'verheiratet': return CustomerReqFamilyStatusEnum.verheiratet;
        case r'geschieden': return CustomerReqFamilyStatusEnum.geschieden;
        case r'verwitwet': return CustomerReqFamilyStatusEnum.verwitwet;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CustomerReqFamilyStatusEnumTypeTransformer] instance.
  static CustomerReqFamilyStatusEnumTypeTransformer? _instance;
}



class CustomerReqJobStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CustomerReqJobStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const arbeitslos = CustomerReqJobStatusEnum._(r'arbeitslos');
  static const schueler = CustomerReqJobStatusEnum._(r'Schueler');
  static const student = CustomerReqJobStatusEnum._(r'Student');
  static const vollzeit = CustomerReqJobStatusEnum._(r'Vollzeit');
  static const teilzeit = CustomerReqJobStatusEnum._(r'Teilzeit');
  static const minijob = CustomerReqJobStatusEnum._(r'Minijob');
  static const werkstudent = CustomerReqJobStatusEnum._(r'Werkstudent');

  /// List of all possible values in this [enum][CustomerReqJobStatusEnum].
  static const values = <CustomerReqJobStatusEnum>[
    arbeitslos,
    schueler,
    student,
    vollzeit,
    teilzeit,
    minijob,
    werkstudent,
  ];

  static CustomerReqJobStatusEnum? fromJson(dynamic value) => CustomerReqJobStatusEnumTypeTransformer().decode(value);

  static List<CustomerReqJobStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CustomerReqJobStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CustomerReqJobStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CustomerReqJobStatusEnum] to String,
/// and [decode] dynamic data back to [CustomerReqJobStatusEnum].
class CustomerReqJobStatusEnumTypeTransformer {
  factory CustomerReqJobStatusEnumTypeTransformer() => _instance ??= const CustomerReqJobStatusEnumTypeTransformer._();

  const CustomerReqJobStatusEnumTypeTransformer._();

  String encode(CustomerReqJobStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CustomerReqJobStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CustomerReqJobStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'arbeitslos': return CustomerReqJobStatusEnum.arbeitslos;
        case r'Schueler': return CustomerReqJobStatusEnum.schueler;
        case r'Student': return CustomerReqJobStatusEnum.student;
        case r'Vollzeit': return CustomerReqJobStatusEnum.vollzeit;
        case r'Teilzeit': return CustomerReqJobStatusEnum.teilzeit;
        case r'Minijob': return CustomerReqJobStatusEnum.minijob;
        case r'Werkstudent': return CustomerReqJobStatusEnum.werkstudent;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CustomerReqJobStatusEnumTypeTransformer] instance.
  static CustomerReqJobStatusEnumTypeTransformer? _instance;
}


