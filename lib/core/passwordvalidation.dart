import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordValidationState {
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigits;
  final bool hasSpecialCharacters;

  const PasswordValidationState({
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasDigits = false,
    this.hasSpecialCharacters = false,
  });

  bool get isValid =>
      hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;

  PasswordValidationState copyWith({
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasDigits,
    bool? hasSpecialCharacters,
  }) {
    return PasswordValidationState(
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasDigits: hasDigits ?? this.hasDigits,
      hasSpecialCharacters: hasSpecialCharacters ?? this.hasSpecialCharacters,
    );
  }
}

// Define a StateNotifier that manages PasswordValidationState
class PasswordValidationNotifier extends StateNotifier<PasswordValidationState> {
  PasswordValidationNotifier() : super(const PasswordValidationState());

  void validatePassword(String password) {
    state = state.copyWith(
      hasUppercase: password.contains(RegExp(r'[A-Z]')),
      hasLowercase: password.contains(RegExp(r'[a-z]')),
      hasDigits: password.contains(RegExp(r'[0-9]')),
      hasSpecialCharacters: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    );
  }
}

final passwordValidationProvider =
    StateNotifierProvider<PasswordValidationNotifier, PasswordValidationState>(
        (ref) => PasswordValidationNotifier());
