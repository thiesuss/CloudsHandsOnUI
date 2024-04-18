//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ContractRes {
  /// Returns a new [ContractRes] instance.
  ContractRes({
    required this.id,
    this.rate,
    required this.customerId,
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
  });

  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? rate;

  String customerId;

  DateTime startDate;

  DateTime endDate;

  /// Minimum value: 1
  num coverage;

  String catName;

  Breed breed;

  Color color;

  DateTime birthDate;

  bool neutered;

  Personality personality;

  Environment environment;

  /// In Gramm
  ///
  /// Minimum value: 50
  num weight;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ContractRes &&
    other.id == id &&
    other.rate == rate &&
    other.customerId == customerId &&
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
    other.weight == weight;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (rate == null ? 0 : rate!.hashCode) +
    (customerId.hashCode) +
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
    (weight.hashCode);

  @override
  String toString() => 'ContractRes[id=$id, rate=$rate, customerId=$customerId, startDate=$startDate, endDate=$endDate, coverage=$coverage, catName=$catName, breed=$breed, color=$color, birthDate=$birthDate, neutered=$neutered, personality=$personality, environment=$environment, weight=$weight]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.rate != null) {
      json[r'rate'] = this.rate;
    } else {
      json[r'rate'] = null;
    }
      json[r'customerId'] = this.customerId;
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
    return json;
  }

  /// Returns a new [ContractRes] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ContractRes? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ContractRes[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ContractRes[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ContractRes(
        id: mapValueOfType<String>(json, r'id')!,
        rate: num.parse('${json[r'rate']}'),
        customerId: mapValueOfType<String>(json, r'customerId')!,
        startDate: mapDateTime(json, r'startDate', r'')!,
        endDate: mapDateTime(json, r'endDate', r'')!,
        coverage: num.parse('${json[r'coverage']}'),
        catName: mapValueOfType<String>(json, r'catName')!,
        breed: Breed.fromJson(json[r'breed'])!,
        color: Color.fromJson(json[r'color'])!,
        birthDate: mapDateTime(json, r'birthDate', r'')!,
        neutered: mapValueOfType<bool>(json, r'neutered')!,
        personality: Personality.fromJson(json[r'personality'])!,
        environment: Environment.fromJson(json[r'environment'])!,
        weight: num.parse('${json[r'weight']}'),
      );
    }
    return null;
  }

  static List<ContractRes> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ContractRes>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ContractRes.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ContractRes> mapFromJson(dynamic json) {
    final map = <String, ContractRes>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ContractRes.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ContractRes-objects as value to a dart map
  static Map<String, List<ContractRes>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ContractRes>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ContractRes.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'customerId',
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
  };
}

