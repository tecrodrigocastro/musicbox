import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:musicbox/routes.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/login_params.dart';
import 'package:musicbox/src/app/features/auth/domain/dtos/register_params.dart';
import 'package:musicbox/src/app/features/auth/domain/validators/login_params_validators.dart';
import 'package:musicbox/src/app/features/auth/domain/validators/register_params_validators.dart';
import 'package:musicbox/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:musicbox/src/core/DI/dependency_injector.dart';
import 'package:musicbox/src/core/theme/app_colors.dart';
import 'package:musicbox/src/core/theme/app_text_styles.dart';
import 'package:musicbox/src/core/utils/show_snack_bar.dart';
import 'package:musicbox/src/core/widgets/cover_art_widget.dart';
import 'package:musicbox/src/core/widgets/mono_label_widget.dart';

/// Entrar / Criar conta. As duas abas compartilham o mesmo [AuthBloc].
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  bool _isRegister = false;
  bool _obscurePassword = true;

  final LoginParams loginParams = LoginParams.empty();
  final LoginParamsValidators loginParamsValidator = LoginParamsValidators();

  final RegisterParams registerParams = RegisterParams.empty();
  final RegisterParamsValidators registerParamsValidator = RegisterParamsValidators();

  final authbloc = injector<AuthBloc>();

  void _selectTab({required bool isRegister}) {
    setState(() => _isRegister = isRegister);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              showMessageSnackBar(context, 'Login realizado com sucesso!', icon: Icons.check_circle, iconColor: AppColors.violet400);
              router.go('/home');
            }
            if (state is AuthRegisterSuccess) {
              showMessageSnackBar(context, 'Conta criada com sucesso!', icon: Icons.check_circle, iconColor: AppColors.violet400);
              router.go('/home');
            }
            if (state is AuthLoginFailure) {
              showMessageSnackBar(context, state.exception.message, icon: Icons.error_outline, iconColor: AppColors.alertRose);
            }
            if (state is AuthRegisterFailure) {
              showMessageSnackBar(context, state.exception.message, icon: Icons.error_outline, iconColor: AppColors.alertRose);
            }
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            children: [
              const _CoverMosaic(),
              const Gap(24),
              const Text('MusicBox', style: AppTextStyles.display),
              const Gap(4),
              const Text('Seu diário de música.', style: AppTextStyles.bodySmall),
              const Gap(24),
              _AuthTabs(isRegister: _isRegister, onSelected: (isRegister) => _selectTab(isRegister: isRegister)),
              const Gap(24),
              if (_isRegister) _buildRegisterForm() else _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordToggle() {
    return IconButton(
      tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MonoLabelWidget('E-mail'),
          const Gap(8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(hintText: 'voce@exemplo.com'),
            validator: loginParamsValidator.byField(loginParams, 'email'),
            onChanged: loginParams.setEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(16),
          const MonoLabelWidget('Senha'),
          const Gap(8),
          TextFormField(
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(suffixIcon: _passwordToggle()),
            validator: loginParamsValidator.byField(loginParams, 'password'),
            onChanged: loginParams.setPassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(24),
          _SubmitButton(
            label: 'Entrar',
            onPressed: () => authbloc.add(AuthLoginRequested(params: loginParams)),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MonoLabelWidget('Nome'),
          const Gap(8),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(hintText: 'Como devemos te chamar'),
            validator: registerParamsValidator.byField(registerParams, 'name'),
            onChanged: registerParams.setName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(16),
          const MonoLabelWidget('E-mail'),
          const Gap(8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(hintText: 'voce@exemplo.com'),
            validator: registerParamsValidator.byField(registerParams, 'email'),
            onChanged: registerParams.setEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(16),
          const MonoLabelWidget('Senha'),
          const Gap(8),
          TextFormField(
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(suffixIcon: _passwordToggle()),
            validator: registerParamsValidator.byField(registerParams, 'password'),
            onChanged: registerParams.setPassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(16),
          const MonoLabelWidget('Confirmar senha'),
          const Gap(8),
          TextFormField(
            obscureText: _obscurePassword,
            decoration: const InputDecoration(),
            validator: (value) => value == registerParams.password ? null : 'As senhas não conferem',
            onChanged: registerParams.setPasswordConfirmation,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const Gap(24),
          _SubmitButton(
            label: 'Criar conta',
            onPressed: () => authbloc.add(AuthRegisterRequested(params: registerParams)),
          ),
        ],
      ),
    );
  }
}

/// Mosaico de quatro capas no topo da tela de entrada.
class _CoverMosaic extends StatelessWidget {
  const _CoverMosaic();

  static const _seeds = ['mosaic-a', 'mosaic-b', 'mosaic-c', 'mosaic-d'];
  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth - _gap * (_seeds.length - 1)) / _seeds.length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final seed in _seeds) CoverArtWidget(size: size, radius: 8, seed: seed),
          ],
        );
      },
    );
  }
}

class _AuthTabs extends StatelessWidget {
  const _AuthTabs({required this.isRegister, required this.onSelected});

  final bool isRegister;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _AuthTab(label: 'Entrar', isSelected: !isRegister, onTap: () => onSelected(false))),
        Expanded(child: _AuthTab(label: 'Criar conta', isSelected: isRegister, onTap: () => onSelected(true))),
      ],
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.violet600 : AppColors.iron,
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(color: isSelected ? AppColors.ice : AppColors.fog),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(label),
        );
      },
    );
  }
}
