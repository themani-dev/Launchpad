import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertMessage {
  static SnackBar showAlert({required String mode,required String title, required String message}) {
    Color color = _getColorFromMode(mode);
    return SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        message,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              child: SvgPicture.asset(
                "lib/images/svg/Bubbles.svg",
                height: 60,
                width: 40,
                color: const Color(0xFF801336),
              ),
            ),
          ),
          const Positioned(
            top: -20,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Uncomment and provide appropriate paths to SVG assets if needed
                  // SvgPicture.asset(
                  //   "lib/images/svg/Bubbles.svg",
                  //   height: 40,
                  // ),
                  // Positioned(
                  //   // top: 10,
                  //   child: SvgPicture.asset(
                  //     "lib/images/svg/Close.svg",
                  //     height: 25,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  static Color _getColorFromMode(String mode) {
    if (mode.toLowerCase() == 'fail') {
      return const Color(0xFFC72C41); // Red color
    } else if (mode.toLowerCase() == 'success'){
      return const Color(0xFF4CAF50); // Green color
    } else {
      return const Color(0xFFFFEB3B); // Yellow Color
    }
  }
}
