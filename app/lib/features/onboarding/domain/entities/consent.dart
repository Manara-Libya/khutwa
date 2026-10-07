class Consent {
  const Consent({
    this.ageConfirmed = false,
    this.understandsLimits = false,
    this.acceptedTerms = false,
  });

  final bool ageConfirmed;
  final bool understandsLimits;
  final bool acceptedTerms;

  bool get isComplete => ageConfirmed && understandsLimits && acceptedTerms;

  Consent copyWith({
    bool? ageConfirmed,
    bool? understandsLimits,
    bool? acceptedTerms,
  }) => Consent(
    ageConfirmed: ageConfirmed ?? this.ageConfirmed,
    understandsLimits: understandsLimits ?? this.understandsLimits,
    acceptedTerms: acceptedTerms ?? this.acceptedTerms,
  );
}
