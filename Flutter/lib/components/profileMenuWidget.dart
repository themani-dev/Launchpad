import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({super.key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.TextColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? TextColor;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container (
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular (100),
          color: Colors.blueGrey.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),

      title: Text(title, style: Theme.of(context). textTheme.bodyLarge),
      trailing: endIcon ? Container (
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular (100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(LineAwesomeIcons.angle_right_solid, size: 18.0, color: TextColor)
      ) : null,
    );
  }
}
