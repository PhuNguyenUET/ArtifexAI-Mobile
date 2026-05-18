import '../../packages/index.dart';
import '../home/home_controller.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _tokenCtrl = TextEditingController();
  bool _submitting = false;
  bool _resending = false;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _tokenCtrl.text.trim();
    if (token.isEmpty) {
      _showSnack('Please enter the verification code.', isError: true);
      return;
    }

    setState(() => _submitting = true);

    final ok = await context.read<HomeController>().verifyEmailToken(
          token: token,
          onError: (msg) => _showSnack(msg, isError: true),
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      _showSnack('Email verified successfully!');
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _resend() async {
    setState(() => _resending = true);

    final ok = await context.read<HomeController>().sendVerificationEmail(
          onError: (msg) => _showSnack(msg, isError: true),
        );

    if (!mounted) return;
    setState(() => _resending = false);

    if (ok) _showSnack('Verification email resent. Please check your inbox.');
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
          Expanded(
              child:
                  Text(msg, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor:
            isError ? AppColor.alertError : AppColor.alertSuccess,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.spaceBg,
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
            'Verify Email',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

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
              child: const Icon(Icons.mark_email_read_outlined,
                  size: 34, color: Colors.white),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Check your inbox',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColor.spaceTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We sent a verification code to your email address.\nEnter it below to verify your account.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColor.spaceTextSecondary,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Verification Code',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.spaceTextSecondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tokenCtrl,
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.spaceTextPrimary,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              hintText: '· · · · · ·',
              hintStyle: GoogleFonts.inter(
                fontSize: 20,
                color: AppColor.spaceTextHint,
                letterSpacing: 4,
              ),
              filled: true,
              fillColor: AppColor.spaceInputFill,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppStyleConstant.textFieldBorderRadius),
                borderSide: const BorderSide(color: AppColor.spaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppStyleConstant.textFieldBorderRadius),
                borderSide: const BorderSide(color: AppColor.spaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    AppStyleConstant.textFieldBorderRadius),
                borderSide:
                    const BorderSide(color: AppColor.primary, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppStyleConstant.buttonBorderRadius),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: _submitting
                      ? null
                      : const LinearGradient(
                          colors: [
                            AppColor.gradientStart3,
                            AppColor.gradientEnd3
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  color:
                      _submitting ? AppColor.spaceBorder : null,
                  borderRadius: BorderRadius.circular(
                      AppStyleConstant.buttonBorderRadius),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Verify',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive it? ",
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColor.spaceTextSecondary),
              ),
              GestureDetector(
                onTap: _resending ? null : _resend,
                child: _resending
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColor.primary),
                      )
                    : Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

