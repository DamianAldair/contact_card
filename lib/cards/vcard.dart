import 'package:contact_card/contact_card.dart';

/// vCard identifiers
enum VCardIdentifier {
  /// Identifier for address, label and telephone
  home('HOME'),

  /// Identifier for address, label and telephone
  work('WORK'),

  /// Identifier for address and label
  postal('POSTAL'),

  /// Identifier for address and label
  parcel('PARCEL'),

  /// Identifier for label
  intl('INTL'),

  /// Describes the sensitivity of the information in the vCard.
  public('PUBLIC'),

  /// Describes the sensitivity of the information in the vCard.
  private('PRIVATE'),

  /// Describes the sensitivity of the information in the vCard.
  confidential('CONFIDENTIAL'),

  /// Identifier for address and telephone
  cell('CELL'),

  /// Identifier for address and telephone
  pager('PAGER'),

  /// Identifier for address and telephone
  video('VIDEO'),

  /// Identifier for address and telephone
  fax('FAX'),

  /// Identifier for address and telephone
  voice('VOICE'),

  /// Identifier for address and telephone
  msg('MSG');

  final String identifier;
  const VCardIdentifier(this.identifier);
  factory VCardIdentifier.fromText(String identifier) =>
      values.firstWhere((e) => e.name.toUpperCase() == identifier.toUpperCase());
  @override
  String toString() => name.toUpperCase();
}

/// A structured representation of the physical delivery address for the vCard object.
class VCardAddress {
  /// Identifier that can be "HOME", "WORK", "POSTAL or "PARCEL".
  final VCardIdentifier? identifier;

  /// Indicates if the address is preferred
  final bool preferred;

  /// Line 1 of the street address.
  /// It is an arbitrary text string that does not describe the street itself.
  final String? auxLine1;

  /// Line 2 of the street address.
  /// It is an arbitrary text string that does not describe the street itself.
  final String? auxLine2;

  /// Street address
  final String street;

  /// City or town
  final String city;

  /// State or region
  final String? state;

  /// Zip Code
  final String? zipCode;

  /// Country
  final String country;

  /// Default constructor
  VCardAddress({
    this.identifier,
    this.preferred = false,
    this.auxLine1,
    this.auxLine2,
    required this.street,
    required this.city,
    this.state,
    this.zipCode,
    required this.country,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple: ADR;TYPE=home:;;123 Main St.;Springfield;IL;12345;USA
  factory VCardAddress.fromPlainText(String plainText) {
    if (!plainText.startsWith('ADR')) {
      throw VCardParsingError('Property "address" must starts with "ADR"');
    }
    final texts = plainText.split(':');
    VCardIdentifier? type;
    bool pref = false;
    String? aux1;
    String? aux2;
    String street;
    String city;
    String? state;
    String? zip;
    String country;
    final t1 = texts.first.split(';');
    if (t1.contains(VCardIdentifier.home.toString()) || t1.contains('TYPE=${VCardIdentifier.home.toString()}')) {
      type = VCardIdentifier.home;
    } else if (t1.contains(VCardIdentifier.work.toString()) || t1.contains('TYPE=${VCardIdentifier.work.toString()}')) {
      type = VCardIdentifier.work;
    } else if (t1.contains(VCardIdentifier.postal.toString()) ||
        t1.contains('TYPE=${VCardIdentifier.postal.toString()}')) {
      type = VCardIdentifier.postal;
    } else if (t1.contains(VCardIdentifier.parcel.toString()) ||
        t1.contains('TYPE=${VCardIdentifier.parcel.toString()}')) {
      type = VCardIdentifier.parcel;
    }
    pref = t1.contains('PREF');
    final t2 = texts[1].split(';');
    if (t2.length != 7) {
      throw VCardParsingError('This text is not recognized as a correct structure');
    }
    aux1 = t2[0].isNotEmpty ? t2[0] : null;
    aux2 = t2[1].isNotEmpty ? t2[1] : null;
    street = t2[2];
    city = t2[3];
    state = t2[4].isNotEmpty ? t2[4] : null;
    zip = t2[5].isNotEmpty ? t2[5] : null;
    country = t2[6];
    return VCardAddress(
      identifier: type,
      preferred: pref,
      auxLine1: aux1,
      auxLine2: aux2,
      street: street,
      city: city,
      state: state,
      zipCode: zip,
      country: country,
    );
  }

  /// Creates a copy of this `VCardAddress` but with the given fields replaced with the new values.
  VCardAddress copyWith({
    VCardIdentifier? identifier,
    bool? preferred,
    String? auxLine1,
    String? auxLine2,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) =>
      VCardAddress(
        identifier: identifier ?? this.identifier,
        preferred: preferred ?? this.preferred,
        auxLine1: auxLine1 ?? this.auxLine1,
        auxLine2: auxLine2 ?? this.auxLine2,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
      );

  /// A plain text representation of the `VCardAddress`.
  String toPlainText([VCardVersion version = VCardVersion.v3]) {
    final String type;
    switch (identifier) {
      case VCardIdentifier.home:
      case VCardIdentifier.work:
      case VCardIdentifier.postal:
      case VCardIdentifier.parcel:
        final newVersions = (version == VCardVersion.v3 || version == VCardVersion.v4);
        type = ';${newVersions ? 'TYPE=' : ''}${identifier.toString()}';
        break;
      default:
        type = '';
        break;
    }
    final pref = preferred ? ';PREF' : '';
    final a1 = auxLine1 != null ? auxLine1! : '';
    final a2 = auxLine2 != null ? auxLine2! : '';
    return 'ADR$type$pref:$a1;$a2;$street;$city;$state;$zipCode;$country';
  }

  @override
  String toString() {
    final s = state != null ? ', $state' : '';
    final z = zipCode != null ? ', $zipCode' : '';
    return 'Type: $identifier\nPreferred: $preferred\n$street, $city$s$z, $country';
  }
}

/// Defines the person's gender.
///
/// Example: GENDER:F
enum VCardGender {
  /// Defines that the person is male
  m('M'),

  /// Defines that the person is female
  f('F');

  final String gender;
  const VCardGender(this.gender);
  factory VCardGender.fromText(String gender) => values.firstWhere((e) => e.name.toUpperCase() == gender.toUpperCase());
  @override
  String toString() => name.toUpperCase();
}

/// Specifies a latitude and longitude.
class VCardGeo {
  /// Specifies a latitude
  final double latitude;

  /// Specifies a longitude
  final double longitude;

  /// Specifies if the vCard is version 4.0
  final VCardVersion? version;

  /// Default constructor
  VCardGeo({
    required this.latitude,
    required this.longitude,
    this.version,
  });

  /// Constructor from the plain text.
  ///
  /// Examples:
  ///
  /// 2.1, 3.0: GEO:39.95;-75.1667
  ///
  /// 4.0: GEO:geo:39.95,-75.1667
  factory VCardGeo.fromPlainText(String plainText) {
    if (!plainText.startsWith('GEO:')) {
      throw VCardParsingError('Property "Geo" must starts with "GEO:"');
    }
    String text = plainText.substring(4);
    bool v4 = false;
    if (text.contains(',')) {
      v4 = true;
      text = text.substring(4);
    }
    final ll = text.split(!v4 ? ';' : ',');
    final lat = double.tryParse(ll[0]);
    final long = double.tryParse(ll[1]);
    if (lat == null || long == null) {
      throw VCardParsingError('Property "GEO" does not comply with the recognized structure');
    }
    return VCardGeo(
      latitude: lat,
      longitude: long,
      version: v4 ? VCardVersion.v4 : null,
    );
  }

  /// Creates a copy of this `VCardGeo` but with the given fields replaced with the new values.
  VCardGeo copyWith({
    double? latitude,
    double? longitude,
    VCardVersion? version,
  }) =>
      VCardGeo(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        version: version ?? this.version,
      );

  /// A plain text representation of the `VCardGeo`.
  String toPlainText() {
    final v4 = version == VCardVersion.v4;
    final geo = !v4 ? '' : 'geo:';
    final separator = !v4 ? ';' : ',';
    return 'GEO:$geo$latitude$separator$longitude';
  }

  @override
  String toString() => 'Latitude: $latitude\nLongitude: $longitude';
}

/// Defines an instant messenger handle.
///
/// This property was introduced in a separate RFC when the latest vCard version was 3.0.
/// Therefore, 3.0 vCards might use this property without otherwise declaring it.
class VCardInstantMessenger {
  /// Defines the instant messenger handler
  final String handler;

  /// Defines the instant messenger username
  final String username;

  /// Default constructor
  VCardInstantMessenger({
    required this.handler,
    required this.username,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple: IMPP:aim:johndoe@aol.com
  factory VCardInstantMessenger.fromPlainText(String plainText) {
    if (!plainText.startsWith('IMPP:')) {
      throw VCardParsingError('Property "Instant Messaging and Presence Protocol" must starts with "IMPP:"');
    }
    final texts = plainText.substring(5).split(':');
    if (texts.length != 2) {
      throw VCardParsingError(
          'Property "Instant Messaging and Presence Protocol" does not comply with the recognized structure');
    }
    return VCardInstantMessenger(
      handler: texts[0],
      username: texts[1],
    );
  }

  /// Creates a copy of this `VCardInstantMessenger` but with the given fields replaced with the new values.
  VCardInstantMessenger copyWith({
    String? handler,
    String? username,
  }) =>
      VCardInstantMessenger(
        handler: handler ?? this.handler,
        username: username ?? this.username,
      );

  /// A plain text representation of the `VCardInstantMessenger`.
  String toPlainText() => 'IMPP:$handler:$username';

  @override
  String toString() => '${handler.toUpperCase()}: $username';
}

/// Defines the type of entity that this vCard represents:
/// 'application', 'individual', 'group', 'location' or 'organization';
/// 'x-*' values may be used for experimental purposes.
enum VCardKind {
  /// Entity type application
  application('application'),

  /// Entity type individual
  individual('individual'),

  /// Entity type group
  group('group'),

  /// Entity type location
  location('location'),

  /// Entity type organization
  organization('organization'),

  /// For experimental purposes
  x('x-*');

  final String kind;
  const VCardKind(this.kind);
  factory VCardKind.fromText(String kind) => values.firstWhere((e) => e.name.toLowerCase() == kind.toLowerCase());
  @override
  String toString() => name.toLowerCase();
}

/// Represents the actual text that should be put on the mailing label
/// when delivering a physical package to the person/object
/// associated with the vCard (related to the ADR property).
///
/// Not supported in version 4.0.
/// Instead, this information is stored in the LABEL parameter of the ADR property.
///
/// Example: ADR;TYPE=home;LABEL="123 Main St\nNew York, NY 12345":;;123 Main St;New York;NY;12345;USA
class VCardLabel {
  /// Identifier that can be "HOME", "WORK", "POSTAL, "PARCEL" or "INTL".
  final VCardIdentifier? type;

  /// Label value
  final String value;

  /// Default constructor
  VCardLabel({
    this.type,
    required this.value,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple: LABEL;TYPE=HOME:123 Main St.\nSpringfield, IL 12345\nUSA
  factory VCardLabel.fromPlainText(String plainText) {
    if (!plainText.startsWith('LABEL')) {
      throw VCardParsingError('Property "label" must starts with "LABEL"');
    }
    final texts = plainText.split(':');
    VCardIdentifier? type;
    final t = texts.first;
    if (t.contains('TYPE=') || t.contains('type=')) {
      type = VCardIdentifier.fromText(t.substring(11));
    }
    return VCardLabel(
      type: type,
      value: texts[1],
    );
  }

  /// Creates a copy of this `VCardLabel` but with the given fields replaced with the new values.
  VCardLabel copyWith({
    VCardIdentifier? type,
    String? value,
  }) =>
      VCardLabel(
        type: type ?? this.type,
        value: value ?? this.value,
      );

  /// A plain text representation of the `VCardLabel`.
  String toPlainText() {
    final t = type != null ? ';TYPE=${type.toString()}' : '';
    return 'LABEL$t:$value';
  }

  @override
  String toString() => 'Type: ${type.toString()}\n Value: $value';
}

/// A structured representation of the name of the person,
/// place or thing associated with the vCard object.
/// Structure recognizes, in order separated by semicolons:
/// Family Name, Given Name, Additional/Middle Names,
/// Honorific Prefixes, and Honorific Suffixes.
class VCardName {
  /// A.k.a. Family Name
  final String? lastName;

  /// A.k.a. Given Name
  final String name;

  /// A.k.a. Additional/Middle Names
  final String? middleNames;

  /// A.k.a. Honorific Prefixes
  final String? prefixes;

  /// A.k.a. Honorific Suffixes
  final String? suffixes;

  /// Default constructor
  VCardName({
    this.prefixes,
    required this.name,
    this.middleNames,
    this.lastName,
    this.suffixes,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple: N:Doe;John;;Dr;
  factory VCardName.fromPlainText(String plainText) {
    if (!plainText.startsWith('N:')) {
      throw VCardParsingError('Property "name" must starts with "N:"');
    }
    final n = plainText.substring(2).split(';');
    if (n.length != 5) {
      throw VCardParsingError('This text is not recognized as a correct structure');
    }
    return VCardName(
      lastName: n[0].isNotEmpty ? n[0] : null,
      name: n[1],
      middleNames: n[2].isNotEmpty ? n[2] : null,
      prefixes: n[3].isNotEmpty ? n[3] : null,
      suffixes: n[4].isNotEmpty ? n[4] : null,
    );
  }

  /// Creates a copy of this `VCardName` but with the given fields replaced with the new values.
  VCardName copyWith({
    String? lastName,
    String? name,
    String? middleNames,
    String? prefixes,
    String? suffixes,
  }) =>
      VCardName(
        lastName: lastName ?? this.lastName,
        name: name ?? this.name,
        middleNames: middleNames ?? this.middleNames,
        prefixes: prefixes ?? this.prefixes,
        suffixes: suffixes ?? this.suffixes,
      );

  /// A plain text representation of the `VCardName`.
  String toPlainText() {
    final ln = lastName ?? '';
    final mn = middleNames ?? '';
    final p = prefixes ?? '';
    final s = suffixes ?? '';
    return 'N:$ln;$name;$mn;$p;$s';
  }

  @override
  String toString() {
    final ln = lastName != null ? ' $lastName' : '';
    final mn = middleNames != null ? ' $middleNames' : '';
    final p = prefixes != null ? '$prefixes ' : '';
    final s = suffixes != null ? ' $suffixes' : '';
    return '$p$name$mn$ln$s';
  }

  /// A plain text representation of the `VCardName` as full name.
  String asFullName() => 'FN:${toString()}';
}

/// One or more descriptive/familiar names
/// for the object represented by this vCard.
class VCardNickName {
  /// One or more descriptive/familiar names.
  final List<String> nicknames;

  /// Default constructor
  VCardNickName(this.nicknames);

  /// Constructor from the plain text.
  ///
  /// Exmaple: NICKNAME:Jon,Johnny
  factory VCardNickName.fromPlainText(String plainText) {
    if (!plainText.startsWith('NICKNAME:')) {
      throw VCardParsingError('Property "nickname" must starts with "NICKNAME:"');
    }
    final nicks = plainText.split(',');
    nicks.removeWhere((e) => e.isEmpty);
    return VCardNickName(nicks);
  }

  /// Creates a copy of this `VCardNickName` but with the given fields replaced with the new values.
  VCardNickName copyWith({
    List<String>? nicknames,
  }) =>
      VCardNickName(nicknames ?? this.nicknames);

  /// A plain text representation of the `VCardName`.
  String toPlainText() {
    String nicks = '';
    for (String n in nicknames) {
      nicks += '${n.trim()},';
    }
    return 'NICKNAME:${nicks.substring(0, nicks.length - 1)}';
  }

  @override
  String toString() => nicknames.toString();
}

/// The name and optionally the unit(s) of the organization associated with the vCard object.
/// This property is based on the X.520 Organization Name attribute and
/// the X.520 Organization Unit attribute.
class VCardOrganization {
  /// Unit(s) of the organization associated with the vCard
  final List<String> units;

  /// Default constructor
  VCardOrganization(this.units);

  /// Constructor from the plain text.
  ///
  /// Exmaple: ORG:Google;GMail Team;Spam Detection Squad
  factory VCardOrganization.fromPlainText(String plainText) {
    if (!plainText.startsWith('ORG:')) {
      throw VCardParsingError('Property "organization" must starts with "ORG:"');
    }
    final units = plainText.substring(4).split(';');
    return VCardOrganization(units);
  }

  /// Creates a copy of this `VCardOrganization` but with the given fields replaced with the new values.
  VCardOrganization copyWith(List<String>? units) => VCardOrganization(units ?? this.units);

  /// A plain text representation of the `VCardOrganization`.
  String toPlainText() {
    String text = '';
    for (String u in units) {
      text += '$u;';
    }
    return 'ORG:${text.substring(0, text.length - 1)}';
  }

  @override
  String toString() {
    String text = '';
    for (String u in units) {
      text += '$u ->';
    }
    return text.substring(0, text.length - 3);
  }
}

/// The canonical number string for a telephone number
/// for telephony communication with the vCard object.
class VCardTelephone {
  /// Indicates if the address is preferred
  final bool preferred;

  /// Indicates the types
  final List<VCardIdentifier> types;

  /// Phone number
  final String value;

  /// Extension, if any
  final List<String>? ext;

  /// Default constructor
  VCardTelephone({
    this.preferred = false,
    required this.types,
    required this.value,
    this.ext,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple: TEL;TYPE=cell:(123) 555-5832
  factory VCardTelephone.fromPlainText(String plainText, [VCardVersion version = VCardVersion.v3]) {
    if (!plainText.startsWith('TEL')) {
      throw VCardParsingError('Property "organization" must starts with "TEL"');
    }
    final texts = plainText.split(':');
    final newVersions = version == VCardVersion.v3 || version == VCardVersion.v4;
    final separator = newVersions ? ',' : ';';
    final start = newVersions ? 9 : 4;
    List<String> t;
    try {
      t = texts.first.substring(start).split(separator);
    } catch (e) {
      t = [];
    }
    final types = <VCardIdentifier>[];
    if (t.contains('HOME') || t.contains('home')) types.add(VCardIdentifier.home);
    if (t.contains('WORK') || t.contains('work')) types.add(VCardIdentifier.work);
    if (t.contains('CELL') || t.contains('cell')) types.add(VCardIdentifier.cell);
    if (t.contains('PAGER') || t.contains('pager')) types.add(VCardIdentifier.pager);
    if (t.contains('VIDEO') || t.contains('video')) types.add(VCardIdentifier.video);
    if (t.contains('VOICE') || t.contains('voice')) types.add(VCardIdentifier.voice);
    if (t.contains('MSG') || t.contains('msg')) types.add(VCardIdentifier.msg);
    if (t.contains('FAX') || t.contains('fax')) types.add(VCardIdentifier.fax);
    final v = texts[1].split(';');
    final ext = <String>[];
    if (v.length > 1) {
      for (int i = 1; i < v.length; i++) {
        ext.add(v[i].substring(4));
      }
    }
    return VCardTelephone(
      preferred: t.contains('PREF') || t.contains('pref'),
      types: types,
      value: v.first,
      ext: ext,
    );
  }

  /// Creates a copy of this `VCardTelephone` but with the given fields replaced with the new values.
  VCardTelephone copyWith({
    bool? preferred,
    List<VCardIdentifier>? types,
    String? value,
    List<String>? ext,
  }) =>
      VCardTelephone(
        preferred: preferred ?? this.preferred,
        types: types ?? this.types,
        value: value ?? this.value,
        ext: ext ?? this.ext,
      );

  /// A plain text representation of the `VCardTelephone`.
  String toPlainText([VCardVersion version = VCardVersion.v3]) {
    final newVersions = version == VCardVersion.v3 || version == VCardVersion.v4;
    final separator = newVersions ? ',' : ';';
    final type = newVersions ? 'TYPE=' : '';
    String identifiers = '';
    for (VCardIdentifier t in types) {
      identifiers += '${t.toString()}$separator';
    }
    if (preferred) {
      identifiers += 'PREF';
    } else {
      try {
        identifiers = identifiers.substring(0, identifiers.length - 1);
      } catch (_) {}
    }
    String extensions = '';
    if (ext != null) {
      for (String e in ext!) {
        extensions += ';EXT=$e';
      }
    }
    return 'TEL${identifiers.isEmpty ? '' : ';'}$identifiers$type:$value$extensions';
  }

  @override
  String toString() =>
      'Preferred: $preferred\nTypes: ${types.toString()}\nPhone: $value\nExtensions: ${ext.toString()}';
}

/// vCard versions
enum VCardVersion {
  /// vCard version 1.0
  v1('VERSION:1.0'),

  /// vCard version 2.1
  v2('VERSION:2.1'),

  /// vCard version 3.0
  v3('VERSION:3.0'),

  /// vCard version 4.0
  v4('VERSION:4.0');

  final String version;
  const VCardVersion(this.version);
  factory VCardVersion.fromPlainText(String plainText) =>
      values.firstWhere((e) => e.name.toUpperCase() == plainText.toUpperCase());
  @override
  String toString() => version;
}

/// Abstract class that represents a vCard
abstract class VCard {
  /// The version of the vCard specification.
  /// In version 4.0, this must come right after the BEGIN property.
  final VCardVersion version;

  /// A structured representation of the name of the person,
  /// place or thing associated with the vCard object.
  /// Structure recognizes, in order separated by semicolons:
  /// Family Name, Given Name, Additional/Middle Names,
  /// Honorific Prefixes, and Honorific Suffixes
  final VCardName name;

  VCard({
    required this.version,
    required this.name,
  });
}

class VCard1 extends VCard {
  /// The canonical number string for a telephone number
  /// for telephony communication with the vCard object.
  final List<VCardTelephone>? telephone;

  /// A structured representation of the physical delivery address for the vCard object.
  final List<VCardAddress>? address;

  /// Specifies a latitude and longitude.
  final VCardGeo? geo;

  /// The address for electronic mail communication with the vCard object.
  final List<String>? emails;

  /// The name and optionally the unit(s) of the organization associated with the vCard object.
  /// This property is based on the X.520 Organization Name attribute and
  /// the X.520 Organization Unit attribute.
  final VCardOrganization? organization;

  /// Specifies the job title, functional position or function of the
  /// individual associated with the vCard object within an organization.
  final String? title;

  /// The role, occupation, or business category of the vCard object within an organization.
  final String? role;

  /// A URL pointing to a website that represents the person in some way.
  final String? url;

  /// A timestamp for the last time the vCard was updated.
  final DateTime? revision;

  /// Default constructor
  VCard1({
    super.version = VCardVersion.v1,
    required super.name,
    this.telephone,
    this.address,
    this.geo,
    this.emails,
    this.organization,
    this.title,
    this.role,
    this.url,
    this.revision,
  });

  /// Constructor from the plain text.
  ///
  /// Exmaple:
  /// ``` vcard
  /// BEGIN:VCARD
  /// VERSION:1.0
  /// N:Gump;Forrest;;Mr.
  /// FN:Forrest Gump
  /// ORG:Bubba Gump Shrimp Co.
  /// TITLE:Shrimp Man
  /// TEL;WORK;VOICE:(111) 555-1212
  /// TEL;HOME;VOICE:(404) 555-1212
  /// ADR;WORK;PREF:;;100 Waters Edge;Baytown;LA;30314;United States of America
  /// ADR;HOME:;;42 Plantation St.;Baytown;LA;30314;United States of America
  /// URL:http://www.johndoe.com
  /// REV:20080424T195243Z
  /// END:VCARD
  /// ```
  factory VCard1.fromPlainText(String plainText) {
    final texts = plainText.trim().split('\n');
    if (texts.first != 'BEGIN:VCARD') {
      throw VCardParsingError('vCard must starts with "BEGIN:VCARD"');
    } else {
      texts.removeAt(0);
    }
    if (texts.last != 'END:VCARD') {
      throw VCardParsingError('vCard must ends with "END:VCARD"');
    } else {
      texts.removeLast();
    }
    if (!texts.contains('VERSION:1.0')) {
      throw VCardParsingError('The vCard must have "VERSION:1.0" as the vCard specification');
    }
    final name = VCardName.fromPlainText(texts.firstWhere((e) => e.startsWith('N:')));
    final tel = <VCardTelephone>[];
    final adr = <VCardAddress>[];
    final emails = <String>[];
    VCardGeo? geo;
    VCardOrganization? org;
    String? title;
    String? role;
    String? url;
    DateTime? rev;
    for (String t in texts) {
      if (t.startsWith('TEL')) {
        tel.add(VCardTelephone.fromPlainText(t, VCardVersion.v1));
      } else if (t.startsWith('ADR')) {
        adr.add(VCardAddress.fromPlainText(t));
      } else if (t.startsWith('GEO')) {
        geo = VCardGeo.fromPlainText(t);
      } else if (t.startsWith('EMAIL')) {
        emails.add(t.substring(6));
      } else if (t.startsWith('ORG')) {
        org = VCardOrganization.fromPlainText(t);
      } else if (t.startsWith('TITLE')) {
        title = t.substring(6);
      } else if (t.startsWith('ROLE')) {
        role = t.substring(5);
      } else if (t.startsWith('URL')) {
        url = t.substring(4);
      } else if (t.startsWith('REV')) {
        rev = DateTime.tryParse(t.substring(4));
      }
    }
    return VCard1(
      name: name,
      telephone: tel.isNotEmpty ? tel : null,
      address: adr.isNotEmpty ? adr : null,
      geo: geo,
      emails: emails.isNotEmpty ? emails : null,
      organization: org,
      title: title,
      role: role,
      url: url,
      revision: rev,
    );
  }

  String toPlainText() {
    String tel = '';
    if (telephone != null) {
      for (VCardTelephone t in telephone!) {
        tel += '${t.toPlainText(VCardVersion.v1)}\n';
      }
    }
    String adr = '';
    if (address != null) {
      for (VCardAddress a in address!) {
        adr += '${a.toPlainText(VCardVersion.v1)}\n';
      }
    }
    String email = '';
    if (emails != null) {
      for (String e in emails!) {
        email += 'EMAIL:$e\n';
      }
    }
    return 'BEGIN:VCARD\n${version.toString()}\n${name.toPlainText()}\n${name.asFullName()}\n${organization != null ? '${organization!.toPlainText()}\n' : ''}${title != null ? 'TITLE:$title\n' : ''}${role != null ? 'ROLE:$role\n' : ''}${geo != null ? '${geo!.toPlainText()}\n' : ''}$tel$email$adr${url != null ? 'URL:$url\n' : ''}${revision != null ? 'REV:${revision!.toString()}\n' : ''}END:VCARD';
  }
}
