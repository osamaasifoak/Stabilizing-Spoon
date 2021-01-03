import 'package:flutter/material.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';

class SimpleAppBarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String subtile;
  final double height, bottomLeftRadius, bottomRightRadius;
  final Color color;
  final void Function() onTapBackButton;
  final bool isTrailingIcon;
  final bool isBackButton;
  SimpleAppBarComponent(
      {@required this.title,
      this.height = 25.0,
      this.color = ColorConstant.darkGreyBlue,
      this.bottomLeftRadius = 0.0,
      this.bottomRightRadius = 50.0,
      this.subtile = "",
      this.onTapBackButton,
      this.isTrailingIcon = false,
      this.isBackButton = true});
  @override
  PreferredSize build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: ColorConstant.lightGrey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  bottomRight: Radius.circular(bottomRightRadius))),
          child: Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: isBackButton,
                          child: InkWell(
                            onTap: onTapBackButton != null
                                ? onTapBackButton
                                : () => {Navigator.pop(context)},
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: ColorConstant.paleGrey,
                            ),
                          ),
                        ),
                        TextComponent(
                          text: title,
                          textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                              color: ColorConstant.paleGrey, fontSize: 17.0),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isTrailingIcon,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.notifications),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 23, top: 8),
                  child: TextComponent(
                    text: subtile,
                    textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                        color: ColorConstant.paleGrey,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(height);
}
