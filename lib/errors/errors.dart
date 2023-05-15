/// Error that occurs when there are problems parsing
/// `MeCard` or `VCard` to plain text and vice versa.
class CardParsingError extends Error {
  final Object? message;
  CardParsingError([this.message]);
}

/// Error that occurs when there are problems parsing
/// `MeCard` to plain text and vice versa.
class MeCardParsingError extends CardParsingError {
  MeCardParsingError([super.message]);
}

/// Error that occurs when there are problems parsing
/// `VCard` to plain text and vice versa.
class VCardParsingError extends CardParsingError {
  VCardParsingError([super.message]);
}
