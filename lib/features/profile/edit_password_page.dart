import '../../packages/index.dart';
import '../home/home_controller.dart';

/// Screen for changing the user's password.
class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final ok = await context.read<HomeController>().changePassword(
          oldPassword: _oldPasswordCtrl.text,
          newPassword: _newPasswordCtrl.text,
          onError: (msg) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColor.alertError),
              );
            }
          },
        );

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          backgroundColor: AppColor.alertSuccess,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.spaceBg,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppStyleConstant.appBarHeight),
      child: Container(
        height: AppStyleConstant.appBarHeight + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: const BoxDecoration(
          color: AppColor.spaceCard,
          border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: AppColor.spaceTextPrimary),
              ),
              const SizedBox(width: 4),
              Text('Change Password',
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColor.spaceTextPrimary)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AppFilledButton(
                  onPressed: _saving ? null : _save,
                  height: 36,
                  buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                    minimumSize: const MaterialStatePropertyAll(Size(64, 36)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Save',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.spaceCardHigh,
                borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
                border: Border.all(color: AppColor.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppColor.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your new password must be at least 8 characters and different from your current password.',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Fields card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.spaceCard,
                borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                border: Border.all(color: AppColor.spaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.spaceTextSecondary,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: _oldPasswordCtrl,
                    labelText: 'Current Password',
                    hintText: 'Enter your current password',
                    obscureText: !_showOld,
                    textInputAction: TextInputAction.next,
                    suffixIcon: _eyeIcon(_showOld, () => setState(() => _showOld = !_showOld)),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter your current password' : null,
                  ),
                  const SizedBox(height: 4),
                  AppTextFormField(
                    controller: _newPasswordCtrl,
                    labelText: 'New Password',
                    hintText: 'At least 8 characters',
                    obscureText: !_showNew,
                    textInputAction: TextInputAction.next,
                    suffixIcon: _eyeIcon(_showNew, () => setState(() => _showNew = !_showNew)),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please enter a new password';
                      if (v.length < 8) return 'Password must be at least 8 characters';
                      if (v == _oldPasswordCtrl.text) return 'New password must differ from current';
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  AppTextFormField(
                    controller: _confirmPasswordCtrl,
                    labelText: 'Confirm New Password',
                    hintText: 'Re-enter your new password',
                    obscureText: !_showConfirm,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _save(),
                    suffixIcon: _eyeIcon(_showConfirm, () => setState(() => _showConfirm = !_showConfirm)),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please confirm your new password';
                      if (v != _newPasswordCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Strength indicator
            _PasswordStrengthIndicator(passwordCtrl: _newPasswordCtrl),
          ],
        ),
      ),
    );
  }

  Widget _eyeIcon(bool visible, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20, color: AppColor.spaceTextSecondary,
          ),
        ),
      );
}

// ─── Password Strength Indicator ─────────────────────────────────────────────

class _PasswordStrengthIndicator extends StatefulWidget {
  const _PasswordStrengthIndicator({required this.passwordCtrl});
  final TextEditingController passwordCtrl;

  @override
  State<_PasswordStrengthIndicator> createState() => _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<_PasswordStrengthIndicator> {
  @override
  void initState() {
    super.initState();
    widget.passwordCtrl.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.passwordCtrl.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  String get _pw => widget.passwordCtrl.text;

  int get _score {
    if (_pw.isEmpty) return 0;
    int s = 0;
    if (_pw.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(_pw)) s++;
    if (RegExp(r'[0-9]').hasMatch(_pw)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(_pw)) s++;
    return s;
  }

  Color get _color {
    if (_score == 1) return AppColor.alertError;
    if (_score == 2) return AppColor.alertWarning;
    if (_score == 3) return AppColor.alertInfo;
    if (_score >= 4) return AppColor.alertSuccess;
    return AppColor.spaceBorder;
  }

  String get _label {
    if (_score == 1) return 'Weak';
    if (_score == 2) return 'Fair';
    if (_score == 3) return 'Good';
    if (_score >= 4) return 'Strong';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (_pw.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.spaceCard,
        borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
        border: Border.all(color: AppColor.spaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Password strength',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary)),
              Text(_label,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _color)),
            ],
          ),
          const SizedBox(height: 8),
          // 4-segment bar
          Row(
            children: List.generate(4, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: i < _score ? _color : AppColor.spaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
          ),
          const SizedBox(height: 10),
          _hint('At least 8 characters', _pw.length >= 8),
          _hint('One uppercase letter', RegExp(r'[A-Z]').hasMatch(_pw)),
          _hint('One number', RegExp(r'[0-9]').hasMatch(_pw)),
          _hint('One special character', RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(_pw)),
        ],
      ),
    );
  }

  Widget _hint(String text, bool met) {
    final color = met ? AppColor.alertSuccess : AppColor.spaceTextSecondary;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(met ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              size: 13, color: color),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.inter(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

