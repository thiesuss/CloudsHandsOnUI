//diese Klasse enthält sämtliche Enums für String Werte von Katzen Attributen (Rasse, Farbe, Persönlichkeit, Umgebung)
//toString methoden auch enthalten

class CatBreedEnum {
  const CatBreedEnum._(this.value);

  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const siamese = CatBreedEnum._(r'Siamese');
  static const perser = CatBreedEnum._(r'Perser');
  static const bengal = CatBreedEnum._(r'Bengal');
  static const mainecoon = CatBreedEnum._(r'Maine Coon');
  static const sphynx = CatBreedEnum._(r'Sphynx');
  static const scottishfold = CatBreedEnum._(r'Scottish Fold');
  static const britishshorthair = CatBreedEnum._(r'British Shorthair');
  static const abyssinian = CatBreedEnum._(r'Abyssinian');
  static const ragdoll = CatBreedEnum._(r'Ragdoll');

  static const values = <CatBreedEnum>[
    siamese,
    perser,
    bengal,
    mainecoon,
    sphynx,
    scottishfold,
    britishshorthair,
    abyssinian,
    ragdoll,
  ];

  static String breedToString(CatBreedEnum breed) {
    switch (breed) {
      case (CatBreedEnum.siamese):
        return 'Siamese';
      case (CatBreedEnum.perser):
        return 'Perser';
      case (CatBreedEnum.bengal):
        return 'Bengal';
      case (CatBreedEnum.mainecoon):
        return 'Maine Coon';
      case (CatBreedEnum.sphynx):
        return 'Sphynx';
      case (CatBreedEnum.scottishfold):
        return 'Scottish Fold';
      case (CatBreedEnum.britishshorthair):
        return 'British Shorthair';
      case (CatBreedEnum.abyssinian):
        return 'Abyssinian';
      case (CatBreedEnum.ragdoll):
        return 'Ragdoll';
      default:
        throw 'Keine Rasse vorhanden';
    }
  }
}

class CatColorEnum {
  const CatColorEnum._(this.value);

  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const blau = CatColorEnum._(r'Blau');
  static const grau = CatColorEnum._(r'Grau');
  static const seal = CatColorEnum._(r'Seal');
  static const lilac = CatColorEnum._(r'Lilac');
  static const creme = CatColorEnum._(r'Creme');
  static const weiss = CatColorEnum._(r'Weiß');
  static const schildpatt = CatColorEnum._(r'Schildpatt');
  static const schwarz = CatColorEnum._(r'Schwarz');
  static const braun = CatColorEnum._(r'Braun');
  static const rot = CatColorEnum._(r'Rot');
  static const zimt = CatColorEnum._(r'Zimt');

  static const values = <CatColorEnum>[
    blau,
    grau,
    seal,
    lilac,
    creme,
    weiss,
    schildpatt,
    schwarz,
    braun,
    rot,
    zimt
  ];

  static String colorToString(CatColorEnum color) {
    switch (color) {
      case (CatColorEnum.blau):
        return 'Blau';
      case (CatColorEnum.grau):
        return 'Grau';
      case (CatColorEnum.seal):
        return 'Seal';
      case (CatColorEnum.lilac):
        return 'Lilac';
      case (CatColorEnum.creme):
        return 'Creme';
      case (CatColorEnum.weiss):
        return 'Weiß';
      case (CatColorEnum.schildpatt):
        return 'Schildpatt';
      case (CatColorEnum.schwarz):
        return 'Schwarz';
      case (CatColorEnum.braun):
        return 'Braun';
      case (CatColorEnum.rot):
        return 'Rot';
      case (CatColorEnum.zimt):
        return 'Zimt';
      default:
        throw 'Keine Farbe vorhanden';
    }
  }
}

class CatPersonalityEnum {
  const CatPersonalityEnum._(this.value);

  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const anhaenglich = CatPersonalityEnum._(r'Anhänglich');
  static const spielerisch = CatPersonalityEnum._(r'Spielerisch');
  static const besonderVerspielt = CatPersonalityEnum._(r'Besonders verspielt');

  static const values = <CatPersonalityEnum>[
    anhaenglich,
    spielerisch,
    besonderVerspielt,
  ];

  static String personalityToString(CatPersonalityEnum personality) {
    switch (personality) {
      case (CatPersonalityEnum.anhaenglich):
        return 'Anhänglich';
      case (CatPersonalityEnum.spielerisch):
        return 'Spielerisch';
      case (CatPersonalityEnum.besonderVerspielt):
        return 'Besonders verspielt';
      default:
        throw 'Keine Persönlichkeit vorhanden';
    }
  }
}

class CatEnvironmentEnum {
  const CatEnvironmentEnum._(this.value);

  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const drinnen = CatEnvironmentEnum._(r'Drinnen');
  static const draussen = CatEnvironmentEnum._(r'Draußen');

  static const values = <CatEnvironmentEnum>[
    drinnen,
    draussen,
  ];

  static String environmentToString(CatEnvironmentEnum personality) {
    switch (personality) {
      case (CatEnvironmentEnum.drinnen):
        return 'Drinnen';
      case (CatEnvironmentEnum.draussen):
        return 'Draußen';
      default:
        throw 'Keine Persönlichkeit vorhanden';
    }
  }
}



// hier ist die Template für die enums
// class CatEnum{
//   const CatEnum._(this.value);

//   final String value;

//   @override
//   String toString() => value;

//   String toJson() => value;

//   static const  = CatEnum._(r'');
  

//   static const values = <CatEnum>[
    
//   ];
// }

