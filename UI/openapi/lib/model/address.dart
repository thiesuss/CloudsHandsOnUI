//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Address {
  /// Returns a new [Address] instance.
  Address({
    required this.street,
    required this.houseNumber,
    required this.zipCode,
    required this.city,
  });

  String street;

  String houseNumber;

  /// Minimum value: 0
  /// Maximum value: 99999
  num zipCode;

  String city;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Address &&
    other.street == street &&
    other.houseNumber == houseNumber &&
    other.zipCode == zipCode &&
    other.city == city;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (street.hashCode) +
    (houseNumber.hashCode) +
    (zipCode.hashCode) +
    (city.hashCode);

  @override
  String toString() => 'Address[street=$street, houseNumber=$houseNumber, zipCode=$zipCode, city=$city]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'street'] = this.street;
      json[r'houseNumber'] = this.houseNumber;
      json[r'zipCode'] = this.zipCode;
      json[r'city'] = this.city;
    return json;
  }

  /// Returns a new [Address] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Address? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Address[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Address[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Address(
        street: mapValueOfType<String>(json, r'street')!,
        houseNumber: mapValueOfType<String>(json, r'houseNumber')!,
        zipCode: num.parse('${json[r'zipCode']}'),
        city: mapValueOfType<String>(json, r'city')!,
      );
    }
    return null;
  }

  static List<Address> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Address>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Address.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Address> mapFromJson(dynamic json) {
    final map = <String, Address>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Address.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Address-objects as value to a dart map
  static Map<String, List<Address>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Address>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Address.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'street',
    'houseNumber',
    'zipCode',
    'city',
  };
}

