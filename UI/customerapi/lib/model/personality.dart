//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Personality {
  /// Instantiate a new enum with the provided [value].
  const Personality._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const spielerisch = Personality._(r'Spielerisch');
  static const anhnglich = Personality._(r'Anhänglich');

  /// List of all possible values in this [enum][Personality].
  static const values = <Personality>[
    spielerisch,
    anhnglich,
  ];

  static Personality? fromJson(dynamic value) => PersonalityTypeTransformer().decode(value);

  static List<Personality> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Personality>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Personality.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Personality] to String,
/// and [decode] dynamic data back to [Personality].
class PersonalityTypeTransformer {
  factory PersonalityTypeTransformer() => _instance ??= const PersonalityTypeTransformer._();

  const PersonalityTypeTransformer._();

  String encode(Personality data) => data.value;

  /// Decodes a [dynamic value][data] to a Personality.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Personality? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Spielerisch': return Personality.spielerisch;
        case r'Anhänglich': return Personality.anhnglich;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PersonalityTypeTransformer] instance.
  static PersonalityTypeTransformer? _instance;
}

