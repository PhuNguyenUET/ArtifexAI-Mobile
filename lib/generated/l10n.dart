// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocale {
  AppLocale();

  static AppLocale? _current;

  static AppLocale get current {
    assert(
      _current != null,
      'No instance of AppLocale was loaded. Try to initialize the AppLocale delegate before accessing AppLocale.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocale> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocale();
      AppLocale._current = instance;

      return instance;
    });
  }

  static AppLocale of(BuildContext context) {
    final instance = AppLocale.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocale present in the widget tree. Did you add AppLocale.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocale? maybeOf(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale);
  }

  String get common_search {
    return Intl.message('Tìm kiếm', name: 'common_search', desc: '', args: []);
  }

  String get common_notification {
    return Intl.message(
      'Thông báo',
      name: 'common_notification',
      desc: '',
      args: [],
    );
  }

  String get common_collection {
    return Intl.message(
      'Bộ sưu tập',
      name: 'common_collection',
      desc: '',
      args: [],
    );
  }

  String get common_home {
    return Intl.message('Trang chủ', name: 'common_home', desc: '', args: []);
  }

  String get common_profile {
    return Intl.message(
      'Tài khoản',
      name: 'common_profile',
      desc: '',
      args: [],
    );
  }

  String get common_monday {
    return Intl.message('Thứ Hai', name: 'common_monday', desc: '', args: []);
  }

  String get common_tuesday {
    return Intl.message('Thứ Ba', name: 'common_tuesday', desc: '', args: []);
  }

  String get common_wednesday {
    return Intl.message('Thứ Tư', name: 'common_wednesday', desc: '', args: []);
  }

  String get common_thursday {
    return Intl.message('Thứ Năm', name: 'common_thursday', desc: '', args: []);
  }

  String get common_friday {
    return Intl.message('Thứ Sáu', name: 'common_friday', desc: '', args: []);
  }

  String get common_saturday {
    return Intl.message('Thứ Bảy', name: 'common_saturday', desc: '', args: []);
  }

  String get common_sunday {
    return Intl.message('Chủ Nhật', name: 'common_sunday', desc: '', args: []);
  }

  String get common_email {
    return Intl.message('Email', name: 'common_email', desc: '', args: []);
  }

  String get common_phone_number {
    return Intl.message(
      'Số điện thoại',
      name: 'common_phone_number',
      desc: '',
      args: [],
    );
  }

  String get common_password {
    return Intl.message(
      'Mật khẩu',
      name: 'common_password',
      desc: '',
      args: [],
    );
  }

  String get common_first_name_last_name {
    return Intl.message(
      'Họ và tên',
      name: 'common_first_name_last_name',
      desc: '',
      args: [],
    );
  }

  String get common_name {
    return Intl.message('Tên', name: 'common_name', desc: '', args: []);
  }

  String get common_username {
    return Intl.message(
      'Username',
      name: 'common_username',
      desc: '',
      args: [],
    );
  }

  String get validator_please_input_new_phone_number {
    return Intl.message(
      'Nhập số điện thoại mới',
      name: 'validator_please_input_new_phone_number',
      desc: '',
      args: [],
    );
  }

  String get validator_phone_at_least_10_digits {
    return Intl.message(
      'Số điện thoại phải có ít nhất 10 chữ số',
      name: 'validator_phone_at_least_10_digits',
      desc: '',
      args: [],
    );
  }

  String validator_value_not_correct_format(Object value) {
    return Intl.message(
      '$value không đúng định dạng',
      name: 'validator_value_not_correct_format',
      desc: '',
      args: [value],
    );
  }

  String get validator_please_input_phone_number {
    return Intl.message(
      'Nhập số điện thoại',
      name: 'validator_please_input_phone_number',
      desc: '',
      args: [],
    );
  }

  String validator_value_is_not_invalid(Object value) {
    return Intl.message(
      '$value không hợp lệ',
      name: 'validator_value_is_not_invalid',
      desc: '',
      args: [value],
    );
  }

  String validator_please_input_value(Object value) {
    return Intl.message(
      'Vui lòng điền $value',
      name: 'validator_please_input_value',
      desc: '',
      args: [value],
    );
  }

  String common_validate_empty_value(Object value) {
    return Intl.message(
      'Nhập $value của bạn',
      name: 'common_validate_empty_value',
      desc: '',
      args: [value],
    );
  }

  String get validator_please_input_username {
    return Intl.message(
      'Cập nhật username',
      name: 'validator_please_input_username',
      desc: '',
      args: [],
    );
  }

  String get common_allow {
    return Intl.message('Cho phép', name: 'common_allow', desc: '', args: []);
  }

  String get common_un_allow {
    return Intl.message(
      'Không cho phép',
      name: 'common_un_allow',
      desc: '',
      args: [],
    );
  }

  String get common_camera {
    return Intl.message('Camera', name: 'common_camera', desc: '', args: []);
  }

  String get common_gallery {
    return Intl.message('Thư viện', name: 'common_gallery', desc: '', args: []);
  }

  String get permission_photos_message {
    return Intl.message(
      'Cho phép truy cập hình ảnh và nội dung nghe nhìn trên thiết bị để tải hình ảnh lên đánh giá của bạn',
      name: 'permission_photos_message',
      desc: '',
      args: [],
    );
  }

  String get app_name {
    return Intl.message('Face App', name: 'app_name', desc: '', args: []);
  }

  String get permission_photos_steps_android {
    return Intl.message(
      '<p>Các bước để cho phép truy cập hình ảnh<br>\n   1. Vào thông tin ứng dụng <b>Face AI</b><br>\n   2. Chọn <b>Quyền</b> > Chọn <b>Bộ nhớ</b><br>\n   3. Chọn <b>Chỉ cho phép truy cập vào nội dung nghe nhìn</b></p>',
      name: 'permission_photos_steps_android',
      desc: '',
      args: [],
    );
  }

  String get permission_photos_steps_ios {
    return Intl.message(
      '<p>Các bước để cho phép truy cập hình ảnh<br>\n   1. Vào thông tin ứng dụng <b>Face AI</b><br>\n   2. Chọn <b>Ảnh</b><br>\n   3. Chọn <b>Ảnh được chọn</b> hoặc <b>Tất cả ảnh</b></p>',
      name: 'permission_photos_steps_ios',
      desc: '',
      args: [],
    );
  }

  String get permission_camera_message {
    return Intl.message(
      'Cho phép truy cập chụp ảnh và quay video để chụp hình ảnh cho đánh giá của bạn',
      name: 'permission_camera_message',
      desc: '',
      args: [],
    );
  }

  String get permission_camera_steps_android {
    return Intl.message(
      '<p>Các bước để cho phép truy cập máy ảnh<br>\n   1. Vào thông tin ứng dụng <b>Face AI</b><br>\n   2. Chọn <b>Quyền</b> > Chọn <b>Máy ảnh</b><br>\n   3. Chọn <b>Chỉ cho phép khi dùng dứng dụng</b> hoặc <b>Luôn hỏi</b></p>',
      name: 'permission_camera_steps_android',
      desc: '',
      args: [],
    );
  }

  String get permission_camera_steps_ios {
    return Intl.message(
      '<p>Các bước để cho phép truy cập máy ảnh<br>\n   1. Vào thông tin ứng dụng <b>Face AI</b><br>\n   2. Bật quyền <b>Camera</b><br>',
      name: 'permission_camera_steps_ios',
      desc: '',
      args: [],
    );
  }

  String get enhance_topbar_title {
    return Intl.message(
      'Face App',
      name: 'enhance_topbar_title',
      desc: '',
      args: [],
    );
  }

  String get enhance_title {
    return Intl.message('Làm đẹp', name: 'enhance_title', desc: '', args: []);
  }

  String get text_style {
    return Intl.message('Bằng văn bản', name: 'text_style', desc: '', args: []);
  }

  String get face_ai_generate {
    return Intl.message('Tạo', name: 'face_ai_generate', desc: '', args: []);
  }

  String get face_ai_popular_searches {
    return Intl.message(
      'Tìm kiếm phổ biến',
      name: 'face_ai_popular_searches',
      desc: '',
      args: [],
    );
  }

  String get face_ai_person {
    return Intl.message('Hình ảnh', name: 'face_ai_person', desc: '', args: []);
  }

  String get allow_access {
    return Intl.message(
      'Cho phép truy cập',
      name: 'allow_access',
      desc: '',
      args: [],
    );
  }

  String get to_your_photos {
    return Intl.message(
      'Bộ sưu tập của bạn',
      name: 'to_your_photos',
      desc: '',
      args: [],
    );
  }

  String get they_will_appear_here {
    return Intl.message(
      'Ảnh sẽ xuất hiện ở đây',
      name: 'they_will_appear_here',
      desc: '',
      args: [],
    );
  }

  String get ai_gen_result {
    return Intl.message(
      'Kết quả AI',
      name: 'ai_gen_result',
      desc: '',
      args: [],
    );
  }

  String get loading {
    return Intl.message(
      'Xin hãy đợi một chút...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  String get regenerate_image {
    return Intl.message(
      'Tạo lại',
      name: 'regenerate_image',
      desc: '',
      args: [],
    );
  }

  String get download_image {
    return Intl.message(
      'Tải xuống',
      name: 'download_image',
      desc: '',
      args: [],
    );
  }

  String get share {
    return Intl.message('Chia sẻ', name: 'share', desc: '', args: []);
  }

  String get additional_prompt {
    return Intl.message(
      'Thêm mô tả',
      name: 'additional_prompt',
      desc: '',
      args: [],
    );
  }

  String get photo_style {
    return Intl.message('Bằng ảnh', name: 'photo_style', desc: '', args: []);
  }

  String get super_style {
    return Intl.message(
      'Kiểu siêu thực',
      name: 'super_style',
      desc: '',
      args: [],
    );
  }

  String get real_style {
    return Intl.message('Kiểu thực tế', name: 'real_style', desc: '', args: []);
  }

  String get photo_swap {
    return Intl.message(
      'Đổi khuôn mặt',
      name: 'photo_swap',
      desc: '',
      args: [],
    );
  }

  String get super_enhance {
    return Intl.message(
      'Làm đẹp siêu thực',
      name: 'super_enhance',
      desc: '',
      args: [],
    );
  }

  String get normal_enhance {
    return Intl.message('Làm đẹp', name: 'normal_enhance', desc: '', args: []);
  }

  String get QR_expired_message {
    return Intl.message(
      'QR này đã hết thời hạn',
      name: 'QR_expired_message',
      desc: '',
      args: [],
    );
  }

  String get QR_success_message {
    return Intl.message(
      'Thanh toán thành công',
      name: 'QR_success_message',
      desc: '',
      args: [],
    );
  }

  String get QR_code_payment {
    return Intl.message(
      'Thanh toán QR',
      name: 'QR_code_payment',
      desc: '',
      args: [],
    );
  }

  String get pricing {
    return Intl.message('Giá cả', name: 'pricing', desc: '', args: []);
  }

  String get payment_amount {
    return Intl.message(
      'Số tiền thanh toán',
      name: 'payment_amount',
      desc: '',
      args: [],
    );
  }

  String get clicks_remained {
    return Intl.message(
      'Số click còn lại',
      name: 'clicks_remained',
      desc: '',
      args: [],
    );
  }

  String get no_face_warning {
    return Intl.message(
      'Ảnh của bạn không có khuôn mặt. Một số chức năng có thể sẽ không hoạt động',
      name: 'no_face_warning',
      desc: '',
      args: [],
    );
  }

  String get editor {
    return Intl.message('Chỉnh sửa', name: 'editor', desc: '', args: []);
  }

  String get remove_background {
    return Intl.message(
      'Xóa nền',
      name: 'remove_background',
      desc: '',
      args: [],
    );
  }

  String get error_msg {
    return Intl.message(
      'Đã có lỗi xảy ra. Hãy thử lại sau ít phút',
      name: 'error_msg',
      desc: '',
      args: [],
    );
  }

  String get overloaded_error {
    return Intl.message(
      'Server đang quá tải. Hãy thử lại sau ít phút.',
      name: 'overloaded_error',
      desc: '',
      args: [],
    );
  }

  String get no_face_force_warning {
    return Intl.message(
      'Chức năng này yêu cầu ảnh của bạn phải có khuôn mặt. Xin hãy chọn lại.',
      name: 'no_face_force_warning',
      desc: '',
      args: [],
    );
  }

  String get all {
    return Intl.message('Tất cả', name: 'all', desc: '', args: []);
  }

  String get faces {
    return Intl.message('Khuôn mặt', name: 'faces', desc: '', args: []);
  }

  String get out_of_clicks_warning {
    return Intl.message(
      'Bạn đã hết lượt click. Xin hãy mua thêm để tiếp tục.',
      name: 'out_of_clicks_warning',
      desc: '',
      args: [],
    );
  }

  String get successfully {
    return Intl.message('Thành công', name: 'successfully', desc: '', args: []);
  }

  String get error {
    return Intl.message('Lỗi', name: 'error', desc: '', args: []);
  }

  String get normal {
    return Intl.message('Bình thường', name: 'normal', desc: '', args: []);
  }

  String get warning {
    return Intl.message('Cảnh báo', name: 'warning', desc: '', args: []);
  }

  String get make_up {
    return Intl.message('Trang điểm', name: 'make_up', desc: '', args: []);
  }

}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocale> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'cn'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocale> load(Locale locale) => AppLocale.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
