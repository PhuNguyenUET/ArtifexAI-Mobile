import '../../packages/index.dart';
import '../home/home_controller.dart';
import '../home/home_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  DateTime? _selectedDob;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<HomeController>().state.user;
    _firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: user?.lastName ?? '');
    _selectedDob = user?.dateOfBirth;
    _firstNameCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final dobString = _selectedDob != null
        ? '${_selectedDob!.day.toString().padLeft(2, '0')}/${_selectedDob!.month.toString().padLeft(2, '0')}/${_selectedDob!.year}'
        : null;

    final ok = await context.read<HomeController>().editUser(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          dateOfBirth: dobString,
          onError: (msg) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColor.alertError),
              );
            }
          },
        );

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          backgroundColor: AppColor.alertSuccess,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _selectedDob ?? DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColor.primary,
            surface: AppColor.spaceCard,
            onSurface: AppColor.spaceTextPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.spaceBg,
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) => _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppStyleConstant.appBarHeight),
      child: Container(
        height:
            AppStyleConstant.appBarHeight + MediaQuery.of(context).padding.top,
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
              Text(
                'Edit Profile',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColor.spaceTextPrimary,
                ),
              ),
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
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.spaceCard,
                borderRadius:
                    BorderRadius.circular(AppStyleConstant.largeRounding),
                border: Border.all(color: AppColor.spaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Personal Information'),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: _firstNameCtrl,
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'First name is required'
                        : null,
                  ),
                  const SizedBox(height: 4),
                  AppTextFormField(
                    controller: _lastNameCtrl,
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Last name is required'
                        : null,
                  ),
                  const SizedBox(height: 4),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColor.spaceTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _pickDob,
                        child: Container(
                          height: AppStyleConstant.textFieldHeight,
                          padding: AppStyleConstant.textFieldContentPadding,
                          decoration: BoxDecoration(
                            color: AppColor.spaceInputFill,
                            border: Border.all(
                                color: AppColor.spaceBorder,
                                width:
                                    AppStyleConstant.textFieldBorderWidth),
                            borderRadius: BorderRadius.circular(
                                AppStyleConstant.textFieldBorderRadius),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDob != null
                                      ? '${_selectedDob!.day.toString().padLeft(2, '0')} / ${_selectedDob!.month.toString().padLeft(2, '0')} / ${_selectedDob!.year}'
                                      : 'Select date of birth',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: _selectedDob != null
                                        ? AppColor.spaceTextPrimary
                                        : AppColor.spaceTextHint,
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today_outlined,
                                  size: 18, color: AppColor.spaceTextSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final first = _firstNameCtrl.text.trim();
    return first.isNotEmpty ? first[0].toUpperCase() : '?';
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColor.spaceTextSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

