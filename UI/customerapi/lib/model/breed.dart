//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Breed {
  /// Instantiate a new enum with the provided [value].
  const Breed._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const bengal = Breed._(r'Bengal');
  static const siamese = Breed._(r'Siamese');
  static const perser = Breed._(r'Perser');
  static const maineCoon = Breed._(r'Maine Coon');
  static const sphynx = Breed._(r'Sphynx');
  static const scottishFold = Breed._(r'Scottish Fold');
  static const britishShorthair = Breed._(r'British Shorthair');
  static const abyssinian = Breed._(r'Abyssinian');
  static const ragdoll = Breed._(r'Ragdoll');

  /// List of all possible values in this [enum][Breed].
  static const values = <Breed>[
    bengal,
    siamese,
    perser,
    maineCoon,
    sphynx,
    scottishFold,
    britishShorthair,
    abyssinian,
    ragdoll,
  ];

  static Breed? fromJson(dynamic value) => BreedTypeTransformer().decode(value);

  static List<Breed> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Breed>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Breed.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Breed] to String,
/// and [decode] dynamic data back to [Breed].
class BreedTypeTransformer {
  factory BreedTypeTransformer() => _instance ??= const BreedTypeTransformer._();

  const BreedTypeTransformer._();

  String encode(Breed data) => data.value;

  /// Decodes a [dynamic value][data] to a Breed.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Breed? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Bengal': return Breed.bengal;
        case r'Siamese': return Breed.siamese;
        case r'Perser': return Breed.perser;
        case r'Maine Coon': return Breed.maineCoon;
        case r'Sphynx': return Breed.sphynx;
        case r'Scottish Fold': return Breed.scottishFold;
        case r'British Shorthair': return Breed.britishShorthair;
        case r'Abyssinian': return Breed.abyssinian;
        case r'Ragdoll': return Breed.ragdoll;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BreedTypeTransformer] instance.
  static BreedTypeTransformer? _instance;
}

