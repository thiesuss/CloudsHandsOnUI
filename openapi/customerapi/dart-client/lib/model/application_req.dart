//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApplicationReq {
  /// Returns a new [ApplicationReq] instance.
  ApplicationReq({
    this.customer,
    this.contract,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CustomerReq? customer;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Contract? contract;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApplicationReq &&
    other.customer == customer &&
    other.contract == contract;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (customer == null ? 0 : customer!.hashCode) +
    (contract == null ? 0 : contract!.hashCode);

  @override
  String toString() => 'ApplicationReq[customer=$customer, contract=$contract]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.customer != null) {
      json[r'customer'] = this.customer;
    } else {
      json[r'customer'] = null;
    }
    if (this.contract != null) {
      json[r'contract'] = this.contract;
    } else {
      json[r'contract'] = null;
    }
    return json;
  }

  /// Returns a new [ApplicationReq] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApplicationReq? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ApplicationReq[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ApplicationReq[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ApplicationReq(
        customer: CustomerReq.fromJson(json[r'customer']),
        contract: Contract.fromJson(json[r'contract']),
      );
    }
    return null;
  }

  static List<ApplicationReq> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApplicationReq>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApplicationReq.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApplicationReq> mapFromJson(dynamic json) {
    final map = <String, ApplicationReq>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApplicationReq.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApplicationReq-objects as value to a dart map
  static Map<String, List<ApplicationReq>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApplicationReq>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApplicationReq.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

