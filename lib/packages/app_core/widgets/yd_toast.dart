import '../../index.dart';

class YDToast {
  const YDToast._();

  static Widget Function(BuildContext context, Widget? child) builder() {
    return BotToastInit();
  }

  static NavigatorObserver obs() {
    return BotToastNavigatorObserver();
  }

  static Function showNotiToast(
    Widget content, {
    VoidCallback? onClose,
    Alignment align = const Alignment(0, -1),
  }) {
    return BotToast.showCustomNotification(
      useSafeArea: true,
      align: align,
      duration: const Duration(milliseconds: AppStyleConstant.toastDuration),
      onClose: onClose,
      toastBuilder: (_) {
        return content;
      },
    );
  }

  /// Shows a "Session timed out" banner that fades in at the top of the screen
  /// and auto-dismisses after [duration].
  static void showSessionExpiredToast({
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    BotToast.showCustomNotification(
      useSafeArea: true,
      align: const Alignment(0, -1),
      duration: duration,
      animationDuration: const Duration(milliseconds: 350),
      animationReverseDuration: const Duration(milliseconds: 350),
      toastBuilder: (_) => const _SessionExpiredBanner(),
    );
  }

  /// Show loading indicator when called. Usage:
  ///
  /// To show loading: [final cancel = YDToast.showLoadingToast;]
  ///
  /// To dismiss: [cancel();]
  static Function showLoadingToast({
    VoidCallback? onClose,
    required Widget child,
  }) {
    return BotToast.showCustomLoading(
      onClose: onClose,
      backgroundColor: Colors.transparent,
      toastBuilder: (void Function() cancelFunc) {
        return child;
      },
    );
  }

  /// Show loading indicator during the execution of [future].
  ///
  /// Returns the result of the [future].
  static Future<T> showAutoDismissLoading<T>({
    required Future<T> future,
    VoidCallback? onClose,
    Widget? child,
    int durationAutoDismissIfError = 3,
  }) async {
    final cancel = child != null
        ? BotToast.showCustomLoading(
            onClose: onClose,
            backgroundColor: Colors.transparent,
            toastBuilder: (cancelFunc) {
              return child;
            },
          )
        : BotToast.showLoading(
            onClose: onClose,
            backgroundColor: Colors.transparent,
          );
    Future.delayed(Duration(seconds: durationAutoDismissIfError), () {
      cancel();
    });
    final result = await future;
    cancel();
    return result;
  }
}

class _SessionExpiredBanner extends StatelessWidget {
  const _SessionExpiredBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.alertWarningBackground,
            border: Border.all(color: AppColor.alertWarningBorder),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_clock_outlined,
                color: AppColor.alertWarning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Session timed out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.alertWarning,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
