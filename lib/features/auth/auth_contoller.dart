import 'package:bharatwork/features/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? error;

  AuthState({this.isLoading = false, this.verificationId, this.error});

  AuthState copyWith({bool? isLoading, String? verificationId, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      error: error ?? this.error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState());

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
        );
      },
      onFailed: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.message,
        );
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (state.verificationId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.verifyOtp(
        verificationId: state.verificationId!,
        smsCode: otp,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
