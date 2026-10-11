class SavedAddress {
  final String id;
  final String label;
  final String subCity;
  final String woreda;
  final String streetAndGateNotes;
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.label,
    required this.subCity,
    required this.woreda,
    required this.streetAndGateNotes,
    this.isDefault = false,
  });

  SavedAddress copyWith({bool? isDefault}) {
    return SavedAddress(
      id: id,
      label: label,
      subCity: subCity,
      woreda: woreda,
      streetAndGateNotes: streetAndGateNotes,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toParseJson() {
    return {
      'label': label,
      'subCity': subCity,
      'woreda': woreda,
      'streetAndGateNotes': streetAndGateNotes,
      'isDefault': isDefault,
    };
  }
}

class SavedPaymentMethod {
  final String id;
  final String provider; // 'Telebirr', 'CBE Birr', 'Chapa'
  final String accountHolder;
  final String maskedAccount;
  final bool isDefault;

  const SavedPaymentMethod({
    required this.id,
    required this.provider,
    required this.accountHolder,
    required this.maskedAccount,
    this.isDefault = false,
  });

  SavedPaymentMethod copyWith({bool? isDefault}) {
    return SavedPaymentMethod(
      id: id,
      provider: provider,
      accountHolder: accountHolder,
      maskedAccount: maskedAccount,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toParseJson() {
    return {
      'provider': provider,
      'accountHolder': accountHolder,
      'maskedAccount': maskedAccount,
      'isDefault': isDefault,
    };
  }
}
