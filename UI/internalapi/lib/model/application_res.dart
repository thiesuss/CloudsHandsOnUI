//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApplicationRes {
  /// Returns a new [ApplicationRes] instance.
  ApplicationRes({
    this.customer,
    this.contract,
    this.accepted,
    this.id,
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
  ContractReq? contract;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? accepted;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApplicationRes &&
    other.customer == customer &&
    other.contract == contract &&
    other.accepted == accepted &&
    other.id == id;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (customer == null ? 0 : customer!.hashCode) +
    (contract == null ? 0 : contract!.hashCode) +
    (accepted == null ? 0 : accepted!.hashCode) +
    (id == null ? 0 : id!.hashCode);

  @override
  String toString() => 'ApplicationRes[customer=$customer, contract=$contract, accepted=$accepted, id=$id]';

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
    if (this.accepted != null) {
      json[r'accepted'] = this.accepted;
    } else {
      json[r'accepted'] = null;
    }
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    return json;
  }

  /// Returns a new [ApplicationRes] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApplicationRes? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ApplicationRes[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ApplicationRes[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ApplicationRes(
        customer: CustomerReq.fromJson(json[r'customer']),
        contract: ContractReq.fromJson(json[r'contract']),
        accepted: mapValueOfType<bool>(json, r'accepted'),
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<ApplicationRes> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApplicationRes>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApplicationRes.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApplicationRes> mapFromJson(dynamic json) {
    final map = <String, ApplicationRes>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApplicationRes.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApplicationRes-objects as value to a dart map
  static Map<String, List<ApplicationRes>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApplicationRes>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApplicationRes.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

