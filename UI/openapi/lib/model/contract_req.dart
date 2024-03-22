//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ContractReq {
  /// Returns a new [ContractReq] instance.
  ContractReq({
    required this.startDate,
    required this.endDate,
    required this.coverage,
    required this.catName,
    required this.breed,
    required this.color,
    required this.birthDate,
    required this.neutered,
    required this.personality,
    required this.environment,
    required this.weight,
    required this.customerId,
  });

  DateTime startDate;

  DateTime endDate;

  /// Minimum value: 1
  num coverage;

  String catName;

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

  String customerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ContractReq &&
    other.startDate == startDate &&
    other.endDate == endDate &&
    other.coverage == coverage &&
    other.catName == catName &&
    other.breed == breed &&
    other.color == color &&
    other.birthDate == birthDate &&
    other.neutered == neutered &&
    other.personality == personality &&
    other.environment == environment &&
    other.weight == weight &&
    other.customerId == customerId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (startDate.hashCode) +
    (endDate.hashCode) +
    (coverage.hashCode) +
    (catName.hashCode) +
    (breed.hashCode) +
    (color.hashCode) +
    (birthDate.hashCode) +
    (neutered.hashCode) +
    (personality.hashCode) +
    (environment.hashCode) +
    (weight.hashCode) +
    (customerId.hashCode);

  @override
  String toString() => 'ContractReq[startDate=$startDate, endDate=$endDate, coverage=$coverage, catName=$catName, breed=$breed, color=$color, birthDate=$birthDate, neutered=$neutered, personality=$personality, environment=$environment, weight=$weight, customerId=$customerId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'startDate'] = _dateFormatter.format(this.startDate.toUtc());
      json[r'endDate'] = _dateFormatter.format(this.endDate.toUtc());
      json[r'coverage'] = this.coverage;
      json[r'catName'] = this.catName;
      json[r'breed'] = this.breed;
      json[r'color'] = this.color;
      json[r'birthDate'] = _dateFormatter.format(this.birthDate.toUtc());
      json[r'neutered'] = this.neutered;
      json[r'personality'] = this.personality;
      json[r'environment'] = this.environment;
      json[r'weight'] = this.weight;
      json[r'customerId'] = this.customerId;
    return json;
  }

  /// Returns a new [ContractReq] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ContractReq? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ContractReq[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ContractReq[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ContractReq(
        startDate: mapDateTime(json, r'startDate', r'')!,
        endDate: mapDateTime(json, r'endDate', r'')!,
        coverage: num.parse('${json[r'coverage']}'),
        catName: mapValueOfType<String>(json, r'catName')!,
        breed: mapValueOfType<String>(json, r'breed')!,
        color: mapValueOfType<String>(json, r'color')!,
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        neutered: mapValueOfType<bool>(json, r'neutered')!,
        personality: mapValueOfType<String>(json, r'personality')!,
        environment: mapValueOfType<String>(json, r'environment')!,
        weight: num.parse('${json[r'weight']}'),
        customerId: mapValueOfType<String>(json, r'customerId')!,
      );
    }
    return null;
  }

  static List<ContractReq> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ContractReq>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ContractReq.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ContractReq> mapFromJson(dynamic json) {
    final map = <String, ContractReq>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ContractReq.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ContractReq-objects as value to a dart map
  static Map<String, List<ContractReq>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ContractReq>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ContractReq.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'startDate',
    'endDate',
    'coverage',
    'catName',
    'breed',
    'color',
    'birthDate',
    'neutered',
    'personality',
    'environment',
    'weight',
    'customerId',
  };
}

