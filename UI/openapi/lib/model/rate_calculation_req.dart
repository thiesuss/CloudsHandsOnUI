//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RateCalculationReq {
  /// Returns a new [RateCalculationReq] instance.
  RateCalculationReq({
    required this.coverage,
    required this.breed,
    required this.color,
    required this.birthDate,
    required this.neutered,
    required this.personality,
    required this.environment,
    required this.weight,
    required this.zipCode,
  });

  /// Minimum value: 1
  num coverage;

  String breed;

  String color;

  DateTime birthDate;

  bool neutered;

  String personality;

  String environment;

  /// In Gramm
  ///
  /// Minimum value: 50
  num weight;

  /// Minimum value: 0
  /// Maximum value: 99999
  num zipCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RateCalculationReq &&
    other.coverage == coverage &&
    other.breed == breed &&
    other.color == color &&
    other.birthDate == birthDate &&
    other.neutered == neutered &&
    other.personality == personality &&
    other.environment == environment &&
    other.weight == weight &&
    other.zipCode == zipCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coverage.hashCode) +
    (breed.hashCode) +
    (color.hashCode) +
    (birthDate.hashCode) +
    (neutered.hashCode) +
    (personality.hashCode) +
    (environment.hashCode) +
    (weight.hashCode) +
    (zipCode.hashCode);

  @override
  String toString() => 'RateCalculationReq[coverage=$coverage, breed=$breed, color=$color, birthDate=$birthDate, neutered=$neutered, personality=$personality, environment=$environment, weight=$weight, zipCode=$zipCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'coverage'] = this.coverage;
      json[r'breed'] = this.breed;
      json[r'color'] = this.color;
      json[r'birthDate'] = _dateFormatter.format(this.birthDate.toUtc());
      json[r'neutered'] = this.neutered;
      json[r'personality'] = this.personality;
      json[r'environment'] = this.environment;
      json[r'weight'] = this.weight;
      json[r'zipCode'] = this.zipCode;
    return json;
  }

  /// Returns a new [RateCalculationReq] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RateCalculationReq? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RateCalculationReq[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RateCalculationReq[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RateCalculationReq(
        coverage: num.parse('${json[r'coverage']}'),
        breed: mapValueOfType<String>(json, r'breed')!,
        color: mapValueOfType<String>(json, r'color')!,
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        neutered: mapValueOfType<bool>(json, r'neutered')!,
        personality: mapValueOfType<String>(json, r'personality')!,
        environment: mapValueOfType<String>(json, r'environment')!,
        weight: num.parse('${json[r'weight']}'),
        zipCode: num.parse('${json[r'zipCode']}'),
      );
    }
    return null;
  }

  static List<RateCalculationReq> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RateCalculationReq>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RateCalculationReq.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RateCalculationReq> mapFromJson(dynamic json) {
    final map = <String, RateCalculationReq>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RateCalculationReq.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RateCalculationReq-objects as value to a dart map
  static Map<String, List<RateCalculationReq>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RateCalculationReq>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RateCalculationReq.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coverage',
    'breed',
    'color',
    'birthDate',
    'neutered',
    'personality',
    'environment',
    'weight',
    'zipCode',
  };
}

