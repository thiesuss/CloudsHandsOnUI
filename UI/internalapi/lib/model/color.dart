//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Color {
  /// Instantiate a new enum with the provided [value].
  const Color._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const schwarz = Color._(r'Schwarz');
  static const wei = Color._(r'Weiß');
  static const grau = Color._(r'Grau');
  static const blau = Color._(r'Blau');
  static const seal = Color._(r'Seal');
  static const lilac = Color._(r'Lilac');
  static const creme = Color._(r'Creme');
  static const schildpatt = Color._(r'Schildpatt');
  static const braun = Color._(r'Braun');
  static const rot = Color._(r'Rot');
  static const zimt = Color._(r'Zimt');

  /// List of all possible values in this [enum][Color].
  static const values = <Color>[
    schwarz,
    wei,
    grau,
    blau,
    seal,
    lilac,
    creme,
    schildpatt,
    braun,
    rot,
    zimt,
  ];

  static Color? fromJson(dynamic value) => ColorTypeTransformer().decode(value);

  static List<Color> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Color>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Color.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Color] to String,
/// and [decode] dynamic data back to [Color].
class ColorTypeTransformer {
  factory ColorTypeTransformer() => _instance ??= const ColorTypeTransformer._();

  const ColorTypeTransformer._();

  String encode(Color data) => data.value;

  /// Decodes a [dynamic value][data] to a Color.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Color? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Schwarz': return Color.schwarz;
        case r'Weiß': return Color.wei;
        case r'Grau': return Color.grau;
        case r'Blau': return Color.blau;
        case r'Seal': return Color.seal;
        case r'Lilac': return Color.lilac;
        case r'Creme': return Color.creme;
        case r'Schildpatt': return Color.schildpatt;
        case r'Braun': return Color.braun;
        case r'Rot': return Color.rot;
        case r'Zimt': return Color.zimt;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ColorTypeTransformer] instance.
  static ColorTypeTransformer? _instance;
}

