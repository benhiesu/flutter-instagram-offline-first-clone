import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_offline_first_clone/auth/components/signup/cubit/signup_cubit.dart';
import 'package:flutter_instagram_offline_first_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignupCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<SignupCubit, bool>((c) => c.state.isLoading);
    final passwordError =
        context.select<SignupCubit, String?>((c) => c.state.passwordError);
    final showPassword =
        context.select<SignupCubit, bool>((c) => c.state.showPassword);
    return AppTextField(
      filled: true,
      focusNode: _focusNode,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => context.read<SignupCubit>().onSubmit(),
      hintText: context.l10n.passwordText,
      enabled: !isLoading,
      obscureText: !showPassword,
      onChanged: (v) => _debouncer.run(
        () => context.read<SignupCubit>().onPasswordChanged(v),
      ),
      errorText: passwordError,
      suffixIcon: Tappable(
        color: AppColors.transparent,
        onTap: isLoading
            ? null
            : context.read<SignupCubit>().changePasswordVisibility,
        child: Icon(
          !showPassword ? Icons.visibility : Icons.visibility_off,
          color: context
              .customAdaptiveColor(dark: AppColors.grey)
              .withOpacity(isLoading ? .4 : 1),
        ),
      ),
    );
  }
}
