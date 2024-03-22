//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DbIdObj {
  /// Returns a new [DbIdObj] instance.
  DbIdObj({
    required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DbIdObj &&
    other.id == id;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode);

  @override
  String toString() => 'DbIdObj[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    return json;
  }

  /// Returns a new [DbIdObj] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DbIdObj? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DbIdObj[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DbIdObj[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DbIdObj(
        id: mapValueOfType<String>(json, r'id')!,
      );
    }
    return null;
  }

  static List<DbIdObj> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DbIdObj>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DbIdObj.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DbIdObj> mapFromJson(dynamic json) {
    final map = <String, DbIdObj>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DbIdObj.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DbIdObj-objects as value to a dart map
  static Map<String, List<DbIdObj>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DbIdObj>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DbIdObj.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

