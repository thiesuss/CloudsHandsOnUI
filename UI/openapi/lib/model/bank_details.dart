//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BankDetails {
  /// Returns a new [BankDetails] instance.
  BankDetails({
    required this.iban,
    required this.bic,
    required this.name,
  });

  String iban;

  String bic;

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BankDetails &&
    other.iban == iban &&
    other.bic == bic &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (iban.hashCode) +
    (bic.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'BankDetails[iban=$iban, bic=$bic, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'iban'] = this.iban;
      json[r'bic'] = this.bic;
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [BankDetails] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BankDetails? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BankDetails[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BankDetails[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BankDetails(
        iban: mapValueOfType<String>(json, r'iban')!,
        bic: mapValueOfType<String>(json, r'bic')!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<BankDetails> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BankDetails>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BankDetails.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BankDetails> mapFromJson(dynamic json) {
    final map = <String, BankDetails>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BankDetails.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BankDetails-objects as value to a dart map
  static Map<String, List<BankDetails>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BankDetails>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BankDetails.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'iban',
    'bic',
    'name',
  };
}

