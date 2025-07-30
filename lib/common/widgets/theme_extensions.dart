// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hh_example/common/themes/border_radius_sheme.dart';
import 'package:hh_example/common/themes/color_scheme.dart';
import 'package:hh_example/common/themes/text_themes.dart';
import 'package:hh_example/common/utils/custom_outline_border.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef TextStyleBuilder = TextStyle Function();

@immutable
class TextThemes extends ThemeExtension<TextThemes> {
  /// headline
  final TextStyleBuilder _hLM;
  final TextStyleBuilder _hLS;
  final TextStyleBuilder _hLB;

  final TextStyleBuilder _hMR;
  final TextStyleBuilder _hMM;
  final TextStyleBuilder _hMS;

  final TextStyleBuilder _hSR;
  final TextStyleBuilder _hSM;
  final TextStyleBuilder _hSS;

  /// title
  final TextStyleBuilder _titleLR;
  final TextStyleBuilder _titleLM;
  final TextStyleBuilder _titleLS;
  final TextStyleBuilder _titleLB;

  final TextStyleBuilder _titleMR;
  final TextStyleBuilder _titleMM;
  final TextStyleBuilder _titleMS;

  final TextStyleBuilder _titleSR;
  final TextStyleBuilder _titleSM;
  final TextStyleBuilder _titleSS;
  final TextStyleBuilder _titleSB;

  /// body
  final TextStyleBuilder _bodyLR;
  final TextStyleBuilder _bodyLM;

  final TextStyleBuilder _bodyMR;
  final TextStyleBuilder _bodyMM;

  /// label
  final TextStyleBuilder _labelLR;
  final TextStyleBuilder _labelLM;
  final TextStyleBuilder _labelLS;

  final TextStyleBuilder _labelMR;
  final TextStyleBuilder _labelMM;
  final TextStyleBuilder _labelMS;

  final TextStyleBuilder _labelSR;
  final TextStyleBuilder _labelSM;
  final TextStyleBuilder _labelSS;

  const TextThemes({
    required TextStyleBuilder hLM,
    required TextStyleBuilder hLS,
    required TextStyleBuilder hLB,
    required TextStyleBuilder hMR,
    required TextStyleBuilder hMM,
    required TextStyleBuilder hMS,
    required TextStyleBuilder hSR,
    required TextStyleBuilder hSM,
    required TextStyleBuilder hSS,
    required TextStyleBuilder titleLR,
    required TextStyleBuilder titleLM,
    required TextStyleBuilder titleLS,
    required TextStyleBuilder titleLB,
    required TextStyleBuilder titleMR,
    required TextStyleBuilder titleMM,
    required TextStyleBuilder titleMS,
    required TextStyleBuilder titleSR,
    required TextStyleBuilder titleSM,
    required TextStyleBuilder titleSS,
    required TextStyleBuilder titleSB,
    required TextStyleBuilder bodyLR,
    required TextStyleBuilder bodyLM,
    required TextStyleBuilder bodyMR,
    required TextStyleBuilder bodyMM,
    required TextStyleBuilder labelLR,
    required TextStyleBuilder labelLM,
    required TextStyleBuilder labelLS,
    required TextStyleBuilder labelMR,
    required TextStyleBuilder labelMM,
    required TextStyleBuilder labelMS,
    required TextStyleBuilder labelSR,
    required TextStyleBuilder labelSM,
    required TextStyleBuilder labelSS,
  })  : _hLM = hLM,
        _hLS = hLS,
        _hLB = hLB,
        _hMR = hMR,
        _hMM = hMM,
        _hMS = hMS,
        _hSR = hSR,
        _hSM = hSM,
        _hSS = hSS,
        _titleLR = titleLR,
        _titleLM = titleLM,
        _titleLS = titleLS,
        _titleLB = titleLB,
        _titleMR = titleMR,
        _titleMM = titleMM,
        _titleMS = titleMS,
        _titleSR = titleSR,
        _titleSM = titleSM,
        _titleSS = titleSS,
        _titleSB = titleSB,
        _bodyLR = bodyLR,
        _bodyLM = bodyLM,
        _bodyMR = bodyMR,
        _bodyMM = bodyMM,
        _labelLR = labelLR,
        _labelLM = labelLM,
        _labelLS = labelLS,
        _labelMR = labelMR,
        _labelMM = labelMM,
        _labelMS = labelMS,
        _labelSR = labelSR,
        _labelSM = labelSM,
        _labelSS = labelSS;

  // Optional
  @override
  String toString() => '';

  @override
  TextThemes copyWith({
    TextStyleBuilder? hLM,
    TextStyleBuilder? hLS,
    TextStyleBuilder? hLB,
    TextStyleBuilder? hMR,
    TextStyleBuilder? hMM,
    TextStyleBuilder? hMS,
    TextStyleBuilder? hSR,
    TextStyleBuilder? hSM,
    TextStyleBuilder? hSS,
    TextStyleBuilder? titleLR,
    TextStyleBuilder? titleLM,
    TextStyleBuilder? titleLS,
    TextStyleBuilder? titleLB,
    TextStyleBuilder? titleMR,
    TextStyleBuilder? titleMM,
    TextStyleBuilder? titleMD,
    TextStyleBuilder? titleSR,
    TextStyleBuilder? titleSM,
    TextStyleBuilder? titleSS,
    TextStyleBuilder? titleSB,
    TextStyleBuilder? bodyLR,
    TextStyleBuilder? bodyLM,
    TextStyleBuilder? bodyMR,
    TextStyleBuilder? bodyMM,
    TextStyleBuilder? labelLR,
    TextStyleBuilder? labelLM,
    TextStyleBuilder? labelLS,
    TextStyleBuilder? labelMR,
    TextStyleBuilder? labelMM,
    TextStyleBuilder? labelMS,
    TextStyleBuilder? labelSR,
    TextStyleBuilder? labelSM,
    TextStyleBuilder? labelSS,
  }) {
    return TextThemes(
      hLM: hLM ?? _hLM,
      hLS: hLS ?? _hLS,
      hLB: hLB ?? _hLB,
      hMR: hMR ?? _hMR,
      hMM: hMM ?? _hMM,
      hMS: hMS ?? _hMS,
      hSR: hSR ?? _hSR,
      hSM: hSM ?? _hSM,
      hSS: hSS ?? _hSS,
      titleLR: titleLR ?? _titleLR,
      titleLM: titleLM ?? _titleLM,
      titleLS: titleLS ?? _titleLS,
      titleLB: titleLB ?? _titleLB,
      titleMR: titleMR ?? _titleMR,
      titleMM: titleMM ?? _titleMM,
      titleMS: titleMD ?? _titleMS,
      titleSR: titleSR ?? _titleSR,
      titleSM: titleSM ?? _titleSM,
      titleSS: titleSS ?? _titleSS,
      titleSB: titleSB ?? _titleSB,
      bodyLR: bodyLR ?? _bodyLR,
      bodyLM: bodyLM ?? _bodyLM,
      bodyMR: bodyMR ?? _bodyMR,
      bodyMM: bodyMM ?? _bodyMM,
      labelLR: labelLR ?? _labelLR,
      labelLM: labelLM ?? _labelLM,
      labelLS: labelLS ?? _labelLS,
      labelMR: labelMR ?? _labelMR,
      labelMM: labelMM ?? _labelMM,
      labelMS: labelMS ?? _labelMS,
      labelSR: labelSR ?? _labelSR,
      labelSM: labelSM ?? _labelSM,
      labelSS: labelSS ?? _labelSS,
    );
  }

  @override
  ThemeExtension<TextThemes> lerp(ThemeExtension<TextThemes>? other, double t) {
    if (other is! TextThemes) return this;
    return other;
  }

  TextStyle get hLM => _hLM();

  TextStyle get hLS => _hLS();

  TextStyle get hLB => _hLB();

  TextStyle get hMR => _hMR();

  TextStyle get hMM => _hMM();

  TextStyle get hMS => _hMS();

  TextStyle get hSR => _hSR();

  TextStyle get hSM => _hSM();

  TextStyle get hSS => _hSS();

  TextStyle get titleLR => _titleLR();

  TextStyle get titleLM => _titleLM();

  TextStyle get titleLS => _titleLS();

  TextStyle get titleLB => _titleLB();

  TextStyle get titleMR => _titleMR();

  TextStyle get titleMM => _titleMM();

  TextStyle get titleMS => _titleMS();

  TextStyle get titleSR => _titleSR();

  TextStyle get titleSM => _titleSM();

  TextStyle get titleSS => _titleSS();

  TextStyle get titleSB => _titleSB();

  TextStyle get bodyLR => _bodyLR();

  TextStyle get bodyLM => _bodyLM();

  TextStyle get bodyMR => _bodyMR();

  TextStyle get bodyMM => _bodyMM();

  TextStyle get labelLR => _labelLR();

  TextStyle get labelLM => _labelLM();

  TextStyle get labelLS => _labelLS();

  TextStyle get labelMR => _labelMR();

  TextStyle get labelMM => _labelMM();

  TextStyle get labelMS => _labelMS();

  TextStyle get labelSR => _labelSR();

  TextStyle get labelSM => _labelSM();

  TextStyle get labelSS => _labelSS();
}

@immutable
class ColorsScheme extends ThemeExtension<ColorsScheme> {
  /// overlay
  final LinearGradient overlay;

  /// text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textSubhead;
  final Color textAccent;
  final Color textNegative;
  final Color textPositive;
  final Color textLink;

  /// background
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color backgroundCard;
  final Color backgroundField;
  final Color backgroundContrast;
  final Color backgroundAccent;
  final Color backgroundNegative;
  final Color backgroundPositive;

  /// icons
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconContrastThemed;
  final Color iconAccent;
  final Color iconAccentThemed;
  final Color iconNegative;
  final Color iconPositive;

  /// states
  final Color statesOverlay;
  final Color statesHoverAccentBG;
  final Color statesPressAccentBG;
  final Color statesDisablePrimaryText;
  final Color statesDisableAccent;
  final Color statesLoad;
  final Color statesDisableBase;
  final Color statesPressBase;
  final Color statesDisableIconPrimary;
  final Color statesDisableField;
  final Color statesField;
  final Color statesPressField;
  final Color statesFocusField;
  final Color statesHoverField;

  /// others
  final Color progress;
  final Color white;
  final Color black;
  final Color bgUI;
  final Color labelUI;

  /// separators
  final Color separatorPrimary;
  final Color separatorPrimaryAlpha;
  final Color separatorSecondary;
  final Color separatorAccent;
  final Color separatorAccentThemed;
  final Color separatorNegative;
  final Color separatorPositive;

  const ColorsScheme({
    required this.overlay,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textSubhead,
    required this.textAccent,
    required this.textNegative,
    required this.textPositive,
    required this.textLink,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.backgroundCard,
    required this.backgroundField,
    required this.backgroundContrast,
    required this.backgroundAccent,
    required this.backgroundNegative,
    required this.backgroundPositive,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconContrastThemed,
    required this.iconAccent,
    required this.iconAccentThemed,
    required this.iconNegative,
    required this.iconPositive,
    required this.statesOverlay,
    required this.statesHoverAccentBG,
    required this.statesPressAccentBG,
    required this.statesDisablePrimaryText,
    required this.statesDisableAccent,
    required this.statesLoad,
    required this.statesDisableBase,
    required this.statesPressBase,
    required this.statesDisableIconPrimary,
    required this.statesDisableField,
    required this.statesField,
    required this.statesPressField,
    required this.statesFocusField,
    required this.statesHoverField,
    required this.progress,
    required this.white,
    required this.black,
    required this.bgUI,
    required this.labelUI,
    required this.separatorPrimary,
    required this.separatorPrimaryAlpha,
    required this.separatorSecondary,
    required this.separatorAccent,
    required this.separatorAccentThemed,
    required this.separatorNegative,
    required this.separatorPositive,
  });

  @override
  ColorsScheme copyWith({
    LinearGradient? overlay,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textSubhead,
    Color? textAccent,
    Color? textNegative,
    Color? textPositive,
    Color? textLink,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? backgroundCard,
    Color? backgroundField,
    Color? backgroundContrast,
    Color? backgroundAccent,
    Color? backgroundNegative,
    Color? backgroundPositive,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconTertiary,
    Color? iconContrastThemed,
    Color? iconAccent,
    Color? iconAccentThemed,
    Color? iconNegative,
    Color? iconPositive,
    Color? statesOverlay,
    Color? statesHoverAccentBG,
    Color? statesPressAccentBG,
    Color? statesDisablePrimaryText,
    Color? statesDisableAccent,
    Color? statesLoad,
    Color? statesDisableBase,
    Color? statesPressBase,
    Color? statesDisableIconPrimary,
    Color? statesDisableField,
    Color? statesField,
    Color? statesPressField,
    Color? statesFocusField,
    Color? statesHoverField,
    Color? progress,
    Color? white,
    Color? black,
    Color? bgUI,
    Color? labelUI,
    Color? separatorPrimary,
    Color? separatorPrimaryAlpha,
    Color? separatorSecondary,
    Color? separatorAccent,
    Color? separatorAccentThemed,
    Color? separatorNegative,
    Color? separatorPositive,
  }) {
    return ColorsScheme(
      overlay: overlay ?? this.overlay,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textSubhead: textSubhead ?? this.textSubhead,
      textAccent: textAccent ?? this.textAccent,
      textNegative: textNegative ?? this.textNegative,
      textPositive: textPositive ?? this.textPositive,
      textLink: textLink ?? this.textLink,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
      backgroundCard: backgroundCard ?? this.backgroundCard,
      backgroundField: backgroundField ?? this.backgroundField,
      backgroundContrast: backgroundContrast ?? this.backgroundContrast,
      backgroundAccent: backgroundAccent ?? this.backgroundAccent,
      backgroundNegative: backgroundNegative ?? this.backgroundNegative,
      backgroundPositive: backgroundPositive ?? this.backgroundPositive,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconTertiary: iconTertiary ?? this.iconTertiary,
      iconContrastThemed: iconContrastThemed ?? this.iconContrastThemed,
      iconAccent: iconAccent ?? this.iconAccent,
      iconAccentThemed: iconAccentThemed ?? this.iconAccentThemed,
      iconNegative: iconNegative ?? this.iconNegative,
      iconPositive: iconPositive ?? this.iconPositive,
      statesOverlay: statesOverlay ?? this.statesOverlay,
      statesHoverAccentBG: statesHoverAccentBG ?? this.statesHoverAccentBG,
      statesPressAccentBG: statesPressAccentBG ?? this.statesPressAccentBG,
      statesDisablePrimaryText: statesDisablePrimaryText ?? this.statesDisablePrimaryText,
      statesDisableAccent: statesDisableAccent ?? this.statesDisableAccent,
      statesLoad: statesLoad ?? this.statesLoad,
      statesDisableBase: statesDisableBase ?? this.statesDisableBase,
      statesPressBase: statesPressBase ?? this.statesPressBase,
      statesDisableIconPrimary: statesDisableIconPrimary ?? this.statesDisableIconPrimary,
      statesDisableField: statesDisableField ?? this.statesDisableField,
      statesField: statesField ?? this.statesField,
      statesPressField: statesPressField ?? this.statesPressField,
      statesFocusField: statesFocusField ?? this.statesFocusField,
      statesHoverField: statesHoverField ?? this.statesHoverField,
      progress: progress ?? this.progress,
      white: white ?? this.white,
      black: black ?? this.black,
      bgUI: bgUI ?? this.bgUI,
      labelUI: labelUI ?? this.labelUI,
      separatorPrimary: separatorPrimary ?? this.separatorPrimary,
      separatorPrimaryAlpha: separatorPrimaryAlpha ?? this.separatorPrimaryAlpha,
      separatorSecondary: separatorSecondary ?? this.separatorSecondary,
      separatorAccent: separatorAccent ?? this.separatorAccent,
      separatorAccentThemed: separatorAccentThemed ?? this.separatorAccentThemed,
      separatorNegative: separatorNegative ?? this.separatorNegative,
      separatorPositive: separatorPositive ?? this.separatorPositive,
    );
  }

  @override
  ThemeExtension<ColorsScheme> lerp(ThemeExtension<ColorsScheme>? other, double t) {
    if (other is! ColorsScheme) return this;
    return ColorsScheme(
      overlay: LinearGradient.lerp(overlay, other.overlay, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textSubhead: Color.lerp(textSubhead, other.textSubhead, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      textNegative: Color.lerp(textNegative, other.textNegative, t)!,
      textPositive: Color.lerp(textPositive, other.textPositive, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundTertiary: Color.lerp(backgroundTertiary, other.backgroundTertiary, t)!,
      backgroundCard: Color.lerp(backgroundCard, other.backgroundCard, t)!,
      backgroundField: Color.lerp(backgroundField, other.backgroundField, t)!,
      backgroundContrast: Color.lerp(backgroundContrast, other.backgroundContrast, t)!,
      backgroundAccent: Color.lerp(backgroundAccent, other.backgroundAccent, t)!,
      backgroundNegative: Color.lerp(backgroundNegative, other.backgroundNegative, t)!,
      backgroundPositive: Color.lerp(backgroundPositive, other.backgroundPositive, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconTertiary: Color.lerp(iconTertiary, other.iconTertiary, t)!,
      iconContrastThemed: Color.lerp(iconContrastThemed, other.iconContrastThemed, t)!,
      iconAccent: Color.lerp(iconAccent, other.iconAccent, t)!,
      iconAccentThemed: Color.lerp(iconAccentThemed, other.iconAccentThemed, t)!,
      iconNegative: Color.lerp(iconNegative, other.iconNegative, t)!,
      iconPositive: Color.lerp(iconPositive, other.iconPositive, t)!,
      statesOverlay: Color.lerp(statesOverlay, other.statesOverlay, t)!,
      statesHoverAccentBG: Color.lerp(statesHoverAccentBG, other.statesHoverAccentBG, t)!,
      statesPressAccentBG: Color.lerp(statesPressAccentBG, other.statesPressAccentBG, t)!,
      statesDisablePrimaryText:
          Color.lerp(statesDisablePrimaryText, other.statesDisablePrimaryText, t)!,
      statesDisableAccent: Color.lerp(statesDisableAccent, other.statesDisableAccent, t)!,
      statesLoad: Color.lerp(statesLoad, other.statesLoad, t)!,
      statesDisableBase: Color.lerp(statesDisableBase, other.statesDisableBase, t)!,
      statesPressBase: Color.lerp(statesPressBase, other.statesPressBase, t)!,
      statesDisableIconPrimary:
          Color.lerp(statesDisableIconPrimary, other.statesDisableIconPrimary, t)!,
      statesDisableField: Color.lerp(statesDisableField, other.statesDisableField, t)!,
      statesField: Color.lerp(statesField, other.statesField, t)!,
      statesPressField: Color.lerp(statesPressField, other.statesPressField, t)!,
      statesFocusField: Color.lerp(statesFocusField, other.statesFocusField, t)!,
      statesHoverField: Color.lerp(statesHoverField, other.statesHoverField, t)!,
      progress: Color.lerp(progress, other.progress, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      bgUI: Color.lerp(bgUI, other.bgUI, t)!,
      labelUI: Color.lerp(labelUI, other.labelUI, t)!,
      separatorPrimary: Color.lerp(separatorPrimary, other.separatorPrimary, t)!,
      separatorPrimaryAlpha: Color.lerp(separatorPrimaryAlpha, other.separatorPrimaryAlpha, t)!,
      separatorSecondary: Color.lerp(separatorSecondary, other.separatorSecondary, t)!,
      separatorAccent: Color.lerp(separatorAccent, other.separatorAccent, t)!,
      separatorAccentThemed: Color.lerp(separatorAccentThemed, other.separatorAccentThemed, t)!,
      separatorNegative: Color.lerp(separatorNegative, other.separatorNegative, t)!,
      separatorPositive: Color.lerp(separatorPositive, other.separatorPositive, t)!,
    );
  }
}

@immutable
class BorderRadiusScheme extends ThemeExtension<BorderRadiusScheme> {
  final BorderRadius input;
  final BorderRadius button;
  final BorderRadius itemS;
  final BorderRadius itemM;
  final BorderRadius itemL;
  final BorderRadius itemSTop;
  final BorderRadius itemMTop;
  final BorderRadius itemLTop;
  final BorderRadius tooltip;
  final BorderRadius circularLoader;
  final BorderRadius bottomSheet;
  final BorderRadius dialog;
  final BorderRadius checkBox;
  final BorderRadius dragHandle;

  const BorderRadiusScheme({
    required this.input,
    required this.button,
    required this.itemS,
    required this.itemM,
    required this.itemL,
    required this.itemSTop,
    required this.itemMTop,
    required this.itemLTop,
    required this.tooltip,
    required this.circularLoader,
    required this.bottomSheet,
    required this.dialog,
    required this.checkBox,
    required this.dragHandle,
  });

  @override
  ThemeExtension<BorderRadiusScheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<BorderRadiusScheme> lerp(
      covariant ThemeExtension<BorderRadiusScheme>? other, double t) {
    return this;
  }
}

class ChatScheme extends ThemeExtension<ChatScheme> implements ChatTheme {
  @override
  final Widget? attachmentButtonIcon = Assets.icons.attachments.svg();

  @override
  final EdgeInsets? attachmentButtonMargin = EdgeInsets.zero;

  @override
  final Color backgroundColor = colorsScheme.white;

  @override
  final EdgeInsets dateDividerMargin = EdgeInsets.all(12.r);

  @override
  final TextStyle dateDividerTextStyle = textThemes.labelLR.copyWith(
    color: colorsScheme.textSubhead,
  );

  @override
  final Widget? deliveredIcon = null;

  @override
  final Widget? documentIcon = null;

  @override
  final TextStyle emptyChatPlaceholderTextStyle = textThemes.labelLM;

  @override
  final Color errorColor = colorsScheme.iconNegative;

  @override
  final Widget? errorIcon = Icon(
    Icons.error_outline,
    size: 16.w,
    color: colorsScheme.iconNegative,
  );

  @override
  final Color? highlightMessageColor = Colors.transparent;

  @override
  final Color inputBackgroundColor = colorsScheme.backgroundSecondary;

  @override
  final BorderRadius inputBorderRadius = borderRadiusScheme.input;

  @override
  final Decoration? inputContainerDecoration = const BoxDecoration();

  @override
  final double inputElevation = 0;

  @override
  final EdgeInsets inputMargin = EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 16.h,
  ).copyWith(top: 8.h);

  @override
  final EdgeInsets inputPadding = EdgeInsets.all(12.r);

  @override
  final Color inputSurfaceTintColor = Colors.transparent;

  @override
  final Color inputTextColor = colorsScheme.textPrimary;

  @override
  final Color? inputTextCursorColor = colorsScheme.textPrimary;

  @override
  final InputDecoration inputTextDecoration = InputDecoration(
    isDense: true,
    isCollapsed: false,
    errorStyle: textThemes.labelMR.copyWith(
      color: colorsScheme.textNegative,
    ),
    floatingLabelStyle: textThemes.titleMR.copyWith(
      color: colorsScheme.textTertiary,
      fontSize: 12.sp,
      letterSpacing: .2,
    ),
    errorBorder: CustomOutlineBorder(
      borderRadiusScheme.input,
      borderSide: BorderSide(
        color: colorsScheme.separatorNegative,
      ),
    ),
    focusedBorder: CustomOutlineBorder(
      borderRadiusScheme.input,
      borderSide: BorderSide(
        color: colorsScheme.separatorSecondary,
      ),
    ),
    hintStyle: textThemes.bodyLM.copyWith(
      color: colorsScheme.textSubhead,
    ),
    alignLabelWithHint: false,
    filled: true,
  );

  @override
  final TextStyle inputTextStyle = textThemes.bodyLR;

  @override
  final double messageBorderRadius = borderRadiusScheme.itemM.bottomLeft.x;

  @override
  final double messageInsetsHorizontal = 0;

  @override
  final double messageInsetsVertical = 0;

  @override
  final double messageMaxWidth = ScreenUtil().screenWidth * 3 / 4;

  @override
  final Color primaryColor = colorsScheme.backgroundTertiary;

  @override
  final TextStyle receivedEmojiMessageTextStyle = textThemes.bodyLR;

  @override
  final TextStyle? receivedMessageBodyBoldTextStyle = textThemes.bodyLM;

  @override
  final TextStyle? receivedMessageBodyCodeTextStyle = textThemes.bodyLR;

  @override
  final TextStyle? receivedMessageBodyLinkTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textLink,
  );

  @override
  final TextStyle receivedMessageBodyTextStyle = textThemes.bodyLR;

  @override
  final TextStyle receivedMessageCaptionTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textSecondary,
  );

  @override
  final Color receivedMessageDocumentIconColor = colorsScheme.iconPrimary;

  @override
  final TextStyle receivedMessageLinkDescriptionTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textLink.withOpacity(
      0.6,
    ),
  );

  @override
  final TextStyle receivedMessageLinkTitleTextStyle =
      textThemes.bodyMR.copyWith(color: colorsScheme.textLink);

  @override
  final Color secondaryColor = colorsScheme.backgroundSecondary;

  @override
  final Widget? seenIcon = null;

  @override
  final Widget? sendButtonIcon = Assets.icons.arrowUp.svg(
    colorFilter: ColorFilter.mode(
      colorsScheme.iconPrimary,
      BlendMode.srcIn,
    ),
  );

  @override
  final EdgeInsets? sendButtonMargin = EdgeInsets.all(4.r);

  @override
  final Widget? sendingIcon = null;

  @override
  final TextStyle sentEmojiMessageTextStyle = textThemes.bodyLR;

  @override
  final TextStyle? sentMessageBodyBoldTextStyle = textThemes.bodyLM;

  @override
  final TextStyle? sentMessageBodyCodeTextStyle = textThemes.bodyLR;

  @override
  final TextStyle? sentMessageBodyLinkTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textLink,
  );

  @override
  final TextStyle sentMessageBodyTextStyle = textThemes.bodyLR;

  @override
  final TextStyle sentMessageCaptionTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textSecondary,
  );

  @override
  final Color sentMessageDocumentIconColor = colorsScheme.iconPrimary;

  @override
  final TextStyle sentMessageLinkDescriptionTextStyle = textThemes.bodyLR.copyWith(
    color: colorsScheme.textLink.withOpacity(
      0.6,
    ),
  );

  @override
  final TextStyle sentMessageLinkTitleTextStyle =
      textThemes.bodyMR.copyWith(color: colorsScheme.textLink);

  @override
  final EdgeInsets statusIconPadding = EdgeInsets.zero;

  @override
  final SystemMessageTheme systemMessageTheme = SystemMessageTheme(
    margin: EdgeInsets.all(12.r),
    textStyle: textThemes.labelLR.copyWith(
      color: colorsScheme.textSubhead,
    ),
  );

  @override
  final TypingIndicatorTheme typingIndicatorTheme = TypingIndicatorTheme(
    animatedCirclesColor: colorsScheme.iconAccent,
    animatedCircleSize: 4.0,
    bubbleBorder: borderRadiusScheme.itemM,
    bubbleColor: colorsScheme.white,
    countAvatarColor: colorsScheme.textAccent,
    countTextColor: colorsScheme.textAccent,
    multipleUserTextStyle: textThemes.labelMR.copyWith(
      color: colorsScheme.textAccent,
    ),
  );

  @override
  final UnreadHeaderTheme unreadHeaderTheme = UnreadHeaderTheme(
    color: colorsScheme.textSubhead,
    textStyle: textThemes.labelLR.copyWith(
      color: colorsScheme.textSubhead,
    ),
  );

  @override
  final Color userAvatarImageBackgroundColor = Colors.white;

  @override
  final List<Color> userAvatarNameColors = [colorsScheme.black];

  @override
  final TextStyle userAvatarTextStyle = const TextStyle();

  @override
  final TextStyle userNameTextStyle = const TextStyle();

  @override
  final EdgeInsetsGeometry? bubbleMargin = EdgeInsets.symmetric(
    horizontal: 15.w,
    vertical: 2.h,
  );

  @override
  ThemeExtension<ChatScheme> lerp(covariant ThemeExtension<ChatScheme>? other, double t) {
    return this;
  }

  @override
  ThemeExtension<ChatScheme> copyWith() {
    return this;
  }
}
