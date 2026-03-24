import '../../packages/index.dart';
import 'auth_controller.dart';
import 'create_new_password_page.dart';

/// Step 1 of the password-reset flow.
/// The user enters their email; we call [forgotPassword] and, on success,
/// push them to [CreateNewPasswordPage].
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final ok = await context.read<AuthController>().sendForgotPasswordEmail(
          email: _emailCtrl.text.trim(),
          onError: (msg) => _showSnack(msg, isError: true),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AuthController>(),
          child: CreateNewPasswordPage(email: _emailCtrl.text.trim()),
        ),
      ));
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: isError ? AppColor.alertError : AppColor.alertSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const LavaBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Forgot Password',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColor.spaceTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // ── Icon ────────────────────────────────────────────────────────
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.lock_reset_outlined,
                    size: 34, color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),

            // ── Title & description ──────────────────────────────────────────
            Text(
              'Reset your password',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColor.spaceTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your account email address and we'll send you a reset code.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColor.spaceTextSecondary,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 32),

            // ── Email field ──────────────────────────────────────────────────
            AppTextFormField(
              controller: _emailCtrl,
              labelText: 'Email Address',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              prefixIcon: const Icon(Icons.email_outlined,
                  size: 20, color: AppColor.textSubtitle),
              onFieldSubmitted: (_) => _submit(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$')
                    .hasMatch(v.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // ── Submit button ────────────────────────────────────────────────
            _buildGradientButton(
              label: 'Send Reset Code',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared gradient button ───────────────────────────────────────────────────

Widget _buildGradientButton({
  required String label,
  required bool loading,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 50,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppStyleConstant.buttonBorderRadius),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: loading
              ? null
              : const LinearGradient(
                  colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: loading ? AppColor.spaceBorder : null,
          borderRadius:
              BorderRadius.circular(AppStyleConstant.buttonBorderRadius),
        ),
        child: Container(
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    ),
  );
}

