//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeReq {
  /// Returns a new [EmployeeReq] instance.
  EmployeeReq({
    required this.firstName,
    required this.lastName,
    required this.address,
  });

  String firstName;

  String lastName;

  Address address;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeReq &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.address == address;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (firstName.hashCode) +
    (lastName.hashCode) +
    (address.hashCode);

  @override
  String toString() => 'EmployeeReq[firstName=$firstName, lastName=$lastName, address=$address]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
      json[r'address'] = this.address;
    return json;
  }

  /// Returns a new [EmployeeReq] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeReq? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeReq[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeReq[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeReq(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        address: Address.fromJson(json[r'address'])!,
      );
    }
    return null;
  }

  static List<EmployeeReq> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeReq>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeReq.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeReq> mapFromJson(dynamic json) {
    final map = <String, EmployeeReq>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeReq.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeReq-objects as value to a dart map
  static Map<String, List<EmployeeReq>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeReq>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeReq.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'firstName',
    'lastName',
    'address',
  };
}

