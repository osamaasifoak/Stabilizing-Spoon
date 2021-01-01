

import 'package:react/constants/assets/assets_constants.dart';
import 'package:react/constants/colors/colors_constants.dart';

class JSON {
  static var onboarding = [
    {
      "bg_color": ColorConstant.beige,
      "heading_color": ColorConstant.charcoal,
      "disable_dots_color": ColorConstant.charcoal.withOpacity(0.3),
      "text_color": ColorConstant.charcoal,
      "button_color": ColorConstant.darkGreyBlue,
      "button_text_color": ColorConstant.white,
      "text": "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.",
      "image": AssetConstant.onboarding_1,
    },
    {
      "bg_color": ColorConstant.paleGrey,
      "heading_color": ColorConstant.darkGreyBlue,
      "disable_dots_color": ColorConstant.charcoal.withOpacity(0.3),
      "text_color": ColorConstant.charcoal,
      "button_color": ColorConstant.darkGreyBlue,
      "button_text_color": ColorConstant.white,
      "text": "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.",
      "image": AssetConstant.onboarding_2
    },
    {
      "bg_color": ColorConstant.darkGreyBlue,
      "heading_color": ColorConstant.white,
      "disable_dots_color": ColorConstant.white.withOpacity(0.3),
      "text_color": ColorConstant.white,
      "button_color": ColorConstant.paleGrey,
      "button_text_color": ColorConstant.darkGreyBlue,
      "text": "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.",
      "image": AssetConstant.onboarding_3
    },
  ];
}
