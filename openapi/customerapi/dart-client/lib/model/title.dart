//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Title {
  /// Instantiate a new enum with the provided [value].
  const Title._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const drPeriod = Title._(r'Dr.');
  static const profPeriodDrPeriod = Title._(r'Prof. Dr.');
  static const drPeriodDrPeriod = Title._(r'Dr. Dr.');
  static const profPeriodDrPeriodDr = Title._(r'Prof. Dr. Dr');

  /// List of all possible values in this [enum][Title].
  static const values = <Title>[
    drPeriod,
    profPeriodDrPeriod,
    drPeriodDrPeriod,
    profPeriodDrPeriodDr,
  ];

  static Title? fromJson(dynamic value) => TitleTypeTransformer().decode(value);

  static List<Title> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Title>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Title.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Title] to String,
/// and [decode] dynamic data back to [Title].
class TitleTypeTransformer {
  factory TitleTypeTransformer() => _instance ??= const TitleTypeTransformer._();

  const TitleTypeTransformer._();

  String encode(Title data) => data.value;

  /// Decodes a [dynamic value][data] to a Title.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Title? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Dr.': return Title.drPeriod;
        case r'Prof. Dr.': return Title.profPeriodDrPeriod;
        case r'Dr. Dr.': return Title.drPeriodDrPeriod;
        case r'Prof. Dr. Dr': return Title.profPeriodDrPeriodDr;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TitleTypeTransformer] instance.
  static TitleTypeTransformer? _instance;
}

