//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeRes {
  /// Returns a new [EmployeeRes] instance.
  EmployeeRes({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
  });

  String id;

  String firstName;

  String lastName;

  Address address;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeRes &&
    other.id == id &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.address == address;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (firstName.hashCode) +
    (lastName.hashCode) +
    (address.hashCode);

  @override
  String toString() => 'EmployeeRes[id=$id, firstName=$firstName, lastName=$lastName, address=$address]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
      json[r'address'] = this.address;
    return json;
  }

  /// Returns a new [EmployeeRes] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeRes? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeRes[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeRes[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeRes(
        id: mapValueOfType<String>(json, r'id')!,
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        address: Address.fromJson(json[r'address'])!,
      );
    }
    return null;
  }

  static List<EmployeeRes> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRes>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRes.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeRes> mapFromJson(dynamic json) {
    final map = <String, EmployeeRes>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeRes.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeRes-objects as value to a dart map
  static Map<String, List<EmployeeRes>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeRes>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeRes.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'firstName',
    'lastName',
    'address',
  };
}

