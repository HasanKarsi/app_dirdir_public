import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:flutter/material.dart';

// Sosyal giriş butonu için özel bir widget

class Socialloginbutton extends StatelessWidget {
  const Socialloginbutton({
    super.key,
    this.buttonText = "Button", // Varsayılan değer
    this.buttonColor, // Butonun arka plan rengi (null olabilir)
    this.textColor, // Yazı rengi (null olabilir)
    this.borderRadius = 28.0, // WhatsApp benzeri yuvarlama
    this.height = 56.0, // Daha büyük buton
    this.buttonIcon, // Opsiyonel ikon
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ), // Daha iyi padding
    this.isOutlined = false, // Çerçeveli buton seçeneği
    required this.onPressed, // Tıklama olayı
  });

  final String buttonText;
  final Color? buttonColor; // Null olabilir
  final Color? textColor; // Null olabilir
  final double borderRadius;
  final double height;
  final Widget? buttonIcon;
  final EdgeInsets padding;
  final bool isOutlined; // Yeni: çerçeveli buton seçeneği
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Varsayılan renkler - Constants'tan
    final Color effectiveButtonColor = buttonColor ?? AppConstants.primaryGreen;
    final Color effectiveTextColor = textColor ?? AppConstants.white;

    return Padding(
      padding: padding,
      child: Container(
        height: height,
        width: double.infinity,
        child:
            isOutlined
                ? OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: effectiveButtonColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: _buildButtonContent(effectiveButtonColor),
                )
                : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: effectiveButtonColor,
                    foregroundColor: effectiveTextColor,
                    elevation: 2,
                    shadowColor: effectiveButtonColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: _buildButtonContent(effectiveTextColor),
                ),
      ),
    );
  }

  Widget _buildButtonContent(Color iconTextColor) {
    if (buttonIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 24, height: 24, child: buttonIcon!),
          SizedBox(width: 12),
          Flexible(
            child: Text(
              buttonText,
              style: TextStyle(
                color: iconTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return Text(
        buttonText,
        style: TextStyle(
          color: iconTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
