import 'package:flutter/material.dart';

/// to control all colors, app theme, without any need to dig into code
/// any new color or existing color will have a const with its value
/// there is a stand alone variable for any widget, text, image or icon

abstract final class AppColors {
  const AppColors._();
  static const Color _black = Colors.black;
  static const Color _white = Colors.white;
  static const Color _transparent = Colors.transparent;
  static const Color _red = Colors.red;
  static const Color _black87 = Color(0xDD000000);
  static const Color _grey = Color(0xFF9E9E9E);
  static const Color _gray727171 = Color(0xFF727171);
  static const Color _gray919191 = Color(0xFF919191);
  static const Color _checkboxBorder = Color(0xFFADB7C2);
  static const Color _alto = Color(0xffD9D9D9);
  static const Color _yellowOrange = Color(0xffFAAF40);
  static const Color _frenchGray = Color(0xffCFCFD0);
  static const Color _silver = Color(0xFFD4D4D4);
  static const Color _gray = Color(0xff929292);
  static const Color _mineShaft = Color(0xff373535);
  static const Color _dustyGray = Color(0xff9C9C9C);
  static const Color _athensGray = Color(0xffE9ECEF);
  static const Color _wildSand = Color(0xFFF5F5F5);

  static const Color _amaranth = Color(0xffF03A47);
  static const Color _shark = Color(0xff1B1D21);
  static const Color _doveGray = Color(0xff737373);
  static const Color _denim = Color(0xFF176AE5);
  static const Color _porcelain = Color(0xffF7F8F9);
  static const Color _rhino = Color(0xff25314C);
  static const Color _zircon = Color(0xFFEAEEF9);
  static const Color _carnation = Color(0xffEF4D54);
  static const Color _linenRed = Color(0xffFCECEB);
  static const Color _linenOrange = Color(0xffF8EFE1);
  static const Color _appleGreen = Color(0xffE4F3ED);
  static const Color _thunderbird = Color(0xffCC1710);
  static const Color _dixie = Color(0xffE29417);
  static const Color _greenHaze = Color(0xff01995A);
  static const Color _mercury = Color(0xffE8E8E8);
  static const Color _alabaster = Color(0xffF8F7F7);
  static const Color _emperor = Color(0xff4F4D4D);
  static const Color _derby = Color(0xFFFFECD9);
  static const Color _electricViolet = Color(0xff7C4CFF);
  static const Color _bridesmaid = Color(0xffFEEEEE);
  static const Color _wineBerry = Color(0xff601F22);
  static const Color _concrete = Color(0xffF3F3F3);
  static const Color _informing = Color(0xff366FFF);
  static const Color _hippieBlue = Color(0xff50A0A4);
  static const Color _lightBlue = Color(0xffE4F1F8);
  static const Color _nevada = Color(0xff666D76);
  static const Color _swansDown = Color(0xffE1F2F2);
  static const Color _blueDianne = Color(0xff255255);

  static const Color _catskillWhite = Color(0xFFE2E8F0);
  static const Color _catskillWhiteLighter = Color(0xFFF8FAFC);
  static const Color _catskillWhiteLight = Color(0xFFF1F5F9);
  static const Color _slateGray = Color(0xFF64748B);
  static const Color _gullGray = Color(0xFF94A3B8);
  static const Color _mako = Color(0xFF40454B);
  static const Color _athensGrayBorder = Color(0xFFE8ECEF);
  static const Color _selectiveYellow = Color(0xFFFFB800);
  static const Color _swansDownDef = Color(0xFFDEF1F1);
  static const Color _fiord = Color(0xFF475569);
  static const Color _pickledBluewood = Color(0xFF334155);
  static const Color _flamingo = Color(0xFFEF4444);
  static const Color _geyser = Color(0xFFCBD5E1);
  static const Color _iron = Color(0xFFD5D9DE);
  static const Color _buttercup = Color(0xFFF59E0B);
  static const Color _lightningYellow = Color(0xFFFBBF24);
  static const Color _keppel = Color(0xFF389BA1);
  static const Color _elm = Color(0xFF206C71);
  static const Color _scandal = Color(0xFFD1FAE5);
  static const Color _watercourse = Color(0xFF065F46);
  static const Color _blackShadow = Color(0x0A000000);

  /// app main theme ...
  static const colorSchemeSeed = _hippieBlue;
  static const colorPrimary = _hippieBlue;
  static const colorSecondary = _swansDown;
  static const lightBlue = _lightBlue;
  static const textSecondaryColor = _blueDianne;
  static const scaffoldBackground = _white;
  static const appBarBackground = _white;
  static const transparentColor = _transparent;
  static const cardBackground = _porcelain;
  static const cardBorder = _athensGray;
  static const white = _white;
  static const black = _black;
  static const black87 = _black87;
  static const grey = _grey;
  static const checkboxBorder = _checkboxBorder;
  static const uploadHintText = _gray727171;
  static const labelSubtitle = _nevada;
  static const neutral10 = _mercury;
  static const lightSurface = _alabaster;

  static const Color borderLight = _catskillWhite;
  static const Color textMuted = _slateGray;
  static const Color textSecondary = _gullGray;
  static const Color textBody = _nevada;
  static const Color textDark = _mako;
  static const Color borderSubtle = _athensGrayBorder;
  static const Color ratingStar = _selectiveYellow;
  static const Color surfaceLight = _catskillWhiteLighter;
  static const Color surfaceMuted = _catskillWhiteLight;
  static const Color chipSelectedBg = _swansDownDef;
  static const Color textDescription = _fiord;
  static const Color textHeader = _pickledBluewood;
  static const Color errorRed = _flamingo;
  static const Color bottomSheetDragHandle = _geyser;
  static const Color sliderInactiveTrack = _iron;
  static const Color badgeYellow = _buttercup;
  static const Color starFilled = _lightningYellow;
  static const Color headerGradientStart = _keppel;
  static const Color headerGradientEnd = _elm;
  static const Color badgeGreenBg = _scandal;
  static const Color badgeGreenText = _watercourse;
  static const Color tabBackground = _porcelain;
  static const Color shadowColor = _blackShadow;
  static const buttonBackground = colorPrimary;
  static const verifyEmailText = colorPrimary;
  static const verifyEmailDescriptionText = _black;
  static const dropDownButtonColor = _black;
  static const titleColor = _white;
  static const containerColor = _white;
  static const buttonWhiteTextColor = _white;
  static const buttonBlackTextColor = _black;
  static const leadingButtonBackgroundColor = _white;
  static const leadingButtonColor = _black;
  static const iconTheme = colorPrimary;
  static const dotsIndicator = _black;
  static const dotsIndicatorActive = colorPrimary;
  static const floatActionBtnBackgroundColor = colorPrimary;
  static const tagGreenColor = _greenHaze;
  static const floatActionBtnForegroundColor = _white;
  static const bottomNavigationBarBackground = _white;
  static const appBarTextColor = _black;
  static const appBarIconColor = _black;
  static const expandedDropDownColor = _yellowOrange;
  static const dropDownText = colorPrimary;
  static const selectedNavBarItem = colorPrimary;
  static const unSelectedNavBarItem = _alto;
  static const logOutButtonColor = _red;
  static const redButtonColor = _red;
  static const filterBorder = _black;
  static const filterIcon = _black;

  /// text colors
  static const bodyMedium = _shark;
  static const titleMedium = _white;
  static const headlineMedium = _thunderbird;
  static const bodySmall = _silver;
  static const titleSmall = _gray;
  static const headlineSmall = _dustyGray;
  static const labelSmall = _dustyGray;
  static const labelMedium = _doveGray;
  static const displaySmall = _amaranth;
  static const headlineLarge = _mineShaft;
  static const bodyLarge = _denim;

  /// app form field
  static const appDropdownButtonFormFieldFill = _black;
  static const appFormFieldFill = _transparent;
  static const enabledAppFormFieldBorder = _silver;
  static const suffixIcon = _rhino;
  static const focusIcon = _yellowOrange;
  static const formFieldText = _white;
  static const formFieldProfileEnableBorder = _frenchGray;
  static const formFieldProfileFocusIBorder = _yellowOrange;
  static const formFieldProfileErrorIBorder = _red;
  static const formFieldFocusIBorder = _silver;
  static const formFieldHintText = _gray;
  static const formFieldTitle = _mineShaft;
  static const filterTitles = _mineShaft;
  static const formFieldBorder = _wildSand;
  static const checkBoxFormFieldBg = _white;
  static const checkBoxFormFieldSelectedBg = colorPrimary;
  static const formImageFieldBorder = _gray;
  static const filePickerFieldBorder = _silver;
  static const formImageSourceBorder = _zircon;
  static const formFieldAsterisk = _red;

  static const viewFileWidgetBg = _transparent;
  static const fileWidgetWhiteBg = _white;
  static const emptyRadioFormFelid = _porcelain;

  /// toast ..
  static const toastBackground = _black;
  static const toastText = _white;
  static const successSnackBg = _appleGreen;
  static const successSnackText = _greenHaze;

  /// paging
  static const paginationLoadingBackground = _white;

  /// bottom sheets
  static const modalBottomSheetBarrier = _black;
  static const modalBottomSheetDivider = _alto;
  static const modalBottomSheetCloseIcon = _shark;
  static const modalBottomSheetBackground = _white;

  static const splashBackground = _white;

  /// App Navigation
  static const appNavigationSelectedIcon = colorPrimary;
  static const appNavigationUnSelectedIcon = _dustyGray;
  static const appNavigationBackground = _mineShaft;

  /// Text Link Widget
  static const linkText = _denim;

  /// Tasks
  static const highPriorityBg = _linenRed;
  static const highPriorityTxt = _thunderbird;
  static const mediumPriorityBg = _linenOrange;
  static const mediumPriorityTxt = _dixie;
  static const lowPriorityBg = _appleGreen;
  static const lowPriorityTxt = _greenHaze;

  static const notStartedTask = _doveGray;
  static const inprogressTask = _dixie;
  static const canceledTask = _thunderbird;
  static const closedTask = _greenHaze;

  static const progressBarBg = _alabaster;
  static const taskItemBorder = _mercury;
  static const unselectedPriorityBg = _alabaster;
  static const unselectedPriorityTxt = _emperor;

  static const taskUpdateStatusItemBg = _alabaster;
  static const taskUpdateProgressItemBg = _derby;
  static const attachmentCountColor = _thunderbird;
  static const verificationApproved = _greenHaze;
  static const verificationRejected = _thunderbird;
  static const verificationPending = _mineShaft;

  static const completedTask = _mineShaft;
  static const offTrack = _thunderbird;
  static const onTrack = _greenHaze;
  static const upcoming = _electricViolet;
  static const highPriority = _carnation;
  static const itemTitle = _emperor;
  static const itemValue = _mineShaft;
  static const itemSubtitle = _doveGray;
  static const detailsDivider = _alabaster;
  static const selectedBackgroundColor = _derby;
  static const commentBackground = _alabaster;
  static const countBackground = _alabaster;
  static const orderByUnselectedBg = _alabaster;
  static const orderBySelectedBg = _bridesmaid;
  static const orderByUnselectedIc = _gray;
  static const orderBySelectedIc = _wineBerry;
  static const circlePainterBg = _concrete;
  static const fileBorderSide = _concrete;
  static const delete = _thunderbird;
  static const edit = _informing;
  static const duplicate = _dixie;
  static const selectedBg = _alabaster;
  static const selectedTxt = _emperor;

  static Color? forgetPassTitle;
}

///
/// All name colors according to https://chir.ag/projects/name-that-color
///   100% - FF
///   95% - F2
///   90% - E6
///   85% - D9
///   80% - CC
///   75% - BF
///   70% - B3
///   65% - A6
///   60% - 99
///   55% - 8C
///    50% - 80
///    45% - 73
///    40% - 66
///    35% - 59
///   30% - 4D
///   25% - 40
///   20% - 33
///   15% - 26
///   10% - 1A
///    5% - 0D
///   0% - 00
