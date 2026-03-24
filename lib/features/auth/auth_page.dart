import '../../generated/assets.dart';
import '../../init/routes.dart';
 import '../../packages/app_core/utils/art_style_helper.dart';
import '../../packages/index.dart';
import 'auth_controller.dart';
import 'auth_state.dart';
import 'forgot_password_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthController _controller;

  // Sign-in fields
  final _signInFormKey = GlobalKey<FormState>();
  final _signInEmailCtrl = TextEditingController();
  final _signInPasswordCtrl = TextEditingController();

  // Sign-up fields
  final _signUpFormKey = GlobalKey<FormState>();
  final _signUpEmailCtrl = TextEditingController();
  final _signUpPasswordCtrl = TextEditingController();
  final _signUpConfirmPasswordCtrl = TextEditingController();

  AuthController _createController(BuildContext context) {
    _controller = AuthController();
    return _controller;
  }

  @override
  void dispose() {
    _signInEmailCtrl.dispose();
    _signInPasswordCtrl.dispose();
    _signUpEmailCtrl.dispose();
    _signUpPasswordCtrl.dispose();
    _signUpConfirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createController,
      child: BlocBuilder<AuthController, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                const LavaBackground(),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        _buildTabBar(context, state),
                        const SizedBox(height: 28),
                        if (state.activeTab == AuthTab.signIn)
                          _buildSignInForm(context, state)
                        else
                          _buildSignUpForm(context, state),
                        const SizedBox(height: 24),
                        _buildDivider(context),
                        const SizedBox(height: 24),
                        _buildOAuthButtons(context, state),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: 0.45),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              Assets.img.appIcon.appIconBackground.path,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Artifex AI',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColor.spaceTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Generate stunning game art with AI',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColor.spaceTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─── Tab Bar ──────────────────────────────────────────────────────────────────

  Widget _buildTabBar(BuildContext context, AuthState state) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.spaceCard,
        borderRadius: BorderRadius.circular(AppStyleConstant.buttonBorderRadius),
        border: Border.all(color: AppColor.spaceBorder),
      ),
      child: Row(
        children: [
          _buildTabItem(
            context: context,
            label: 'Sign In',
            isActive: state.activeTab == AuthTab.signIn,
            onTap: () => context.read<AuthController>().switchTab(AuthTab.signIn),
          ),
          _buildTabItem(
            context: context,
            label: 'Sign Up',
            isActive: state.activeTab == AuthTab.signUp,
            onTap: () => context.read<AuthController>().switchTab(AuthTab.signUp),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF2D2870), Color(0xFF1A1650)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [BoxShadow(color: AppColor.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColor.spaceTextPrimary : AppColor.spaceTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Sign In Form ─────────────────────────────────────────────────────────────

  Widget _buildSignInForm(BuildContext context, AuthState state) {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            controller: _signInEmailCtrl,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColor.textSubtitle),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _signInPasswordCtrl,
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColor.textSubtitle),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => context.read<AuthController>().toggleObscurePassword(),
                child: Icon(
                  state.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppColor.textSubtitle,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              return null;
            },
            onFieldSubmitted: (_) => _onSignIn(context),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            _buildErrorBanner(state.errorMessage!),
          ],
          const SizedBox(height: 24),
          AppFilledButton(
            onPressed: state.loading ? null : () => _onSignIn(context),
            width: double.infinity,
            height: AppStyleConstant.buttonHeight,
            child: state.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthController>(),
                    child: const ForgotPasswordPage(),
                  ),
                ));
              },
              child: Text(
                'Forgot password?',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sign Up Form ─────────────────────────────────────────────────────────────

  Widget _buildSignUpForm(BuildContext context, AuthState state) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            controller: _signUpEmailCtrl,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColor.textSubtitle),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _signUpPasswordCtrl,
            labelText: 'Password',
            hintText: 'Create a password',
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColor.textSubtitle),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => context.read<AuthController>().toggleObscurePassword(),
                child: Icon(
                  state.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppColor.textSubtitle,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _signUpConfirmPasswordCtrl,
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            obscureText: state.obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColor.textSubtitle),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => context.read<AuthController>().toggleObscureConfirmPassword(),
                child: Icon(
                  state.obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppColor.textSubtitle,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _signUpPasswordCtrl.text) return 'Passwords do not match';
              return null;
            },
            onFieldSubmitted: (_) => _onSignUp(context),
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            _buildErrorBanner(state.errorMessage!),
          ],
          const SizedBox(height: 24),
          AppFilledButton(
            onPressed: state.loading ? null : () => _onSignUp(context),
            width: double.infinity,
            height: AppStyleConstant.buttonHeight,
            child: state.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Create Account',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─── OAuth Buttons ────────────────────────────────────────────────────────────

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColor.spaceBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary),
          ),
        ),
        Expanded(child: Divider(color: AppColor.spaceBorder)),
      ],
    );
  }

  Widget _buildOAuthButtons(BuildContext context, AuthState state) {
    return Column(
      children: [
        _buildOAuthButton(
          context: context,
          label: 'Continue with Google',
          iconWidget: _buildGoogleIcon(),
          onPressed: state.oauthLoading ? null : () => _onGoogleSignIn(context),
          isLoading: state.oauthLoading,
        ),
        const SizedBox(height: 12),
        _buildOAuthButton(
          context: context,
          label: 'Continue with GitHub',
          iconWidget: _buildGithubIcon(),
          onPressed: state.oauthLoading ? null : () => _onGithubSignIn(context),
          isLoading: state.oauthLoading,
        ),
      ],
    );
  }

  Widget _buildOAuthButton({
    required BuildContext context,
    required String label,
    required Widget iconWidget,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppStyleConstant.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.spaceBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyleConstant.buttonBorderRadius),
          ),
          backgroundColor: AppColor.spaceCard,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(color: AppColor.primary, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconWidget,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.spaceTextPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }

  Widget _buildGithubIcon() {
    return const Icon(Icons.code, size: 20, color: AppColor.spaceTextPrimary);
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.alertError.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
        border: Border.all(color: AppColor.alertError.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColor.alertError),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(fontSize: 13, color: AppColor.alertError),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────────

  void _onSignIn(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_signInFormKey.currentState?.validate() != true) return;
    context.read<AuthController>().signIn(
          context: context,
          email: _signInEmailCtrl.text.trim(),
          password: _signInPasswordCtrl.text,
          onSuccess: () {
            context.navigateToHome();
          },
        );
  }

  void _onSignUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_signUpFormKey.currentState?.validate() != true) return;
    context.read<AuthController>().signUp(
          context: context,
          email: _signUpEmailCtrl.text.trim(),
          password: _signUpPasswordCtrl.text,
          onSuccess: () {
            // Navigate to sign-in after successful registration
            context.read<AuthController>().switchTab(AuthTab.signIn);
          },
        );
  }

  void _onGoogleSignIn(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<AuthController>().signInWithGoogle(
          context: context,
          onSuccess: () {
            context.navigateToHome();
          },
        );
  }

  void _onGithubSignIn(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<AuthController>().signInWithGithub(
          context: context,
          onSuccess: () {
            context.navigateToHome();
          },
        );
  }
}

// ─── Google Logo CustomPainter ────────────────────────────────────────────────

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle (white)
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Simplified Google 'G' color segments using arcs
    const double sweepAngle = 2 * 3.14159265358979 / 4;
    final colors = [
      const Color(0xFF4285F4), // Blue
      const Color(0xFF34A853), // Green
      const Color(0xFFFBBC05), // Yellow
      const Color(0xFFEA4335), // Red
    ];
    for (int i = 0; i < 4; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.65),
        i * sweepAngle - 3.14159265358979 / 2,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


