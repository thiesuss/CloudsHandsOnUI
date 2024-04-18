//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Environment {
  /// Instantiate a new enum with the provided [value].
  const Environment._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const drinnen = Environment._(r'Drinnen');
  static const drauen = Environment._(r'Draußen');

  /// List of all possible values in this [enum][Environment].
  static const values = <Environment>[
    drinnen,
    drauen,
  ];

  static Environment? fromJson(dynamic value) => EnvironmentTypeTransformer().decode(value);

  static List<Environment> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Environment>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Environment.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Environment] to String,
/// and [decode] dynamic data back to [Environment].
class EnvironmentTypeTransformer {
  factory EnvironmentTypeTransformer() => _instance ??= const EnvironmentTypeTransformer._();

  const EnvironmentTypeTransformer._();

  String encode(Environment data) => data.value;

  /// Decodes a [dynamic value][data] to a Environment.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Environment? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Drinnen': return Environment.drinnen;
        case r'Draußen': return Environment.drauen;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EnvironmentTypeTransformer] instance.
  static EnvironmentTypeTransformer? _instance;
}

