import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../components/button.dart';
import '../../components/profileMenuWidget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}


class _UserProfileState extends State<UserProfile> {

  // function to delete Account
  void deleteAccount(){

  }
  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.sun),)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child:Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(image: AssetImage('lib/images/png/profile.jpg')),
                  ),
                ),
                const SizedBox(height: 20,),
                Text("Thanos",style: Theme.of(context).textTheme.headlineLarge,),
                Text("thanos@themani.dev",style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: (){},
                      child: const Text("Edit Profile",style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        side: BorderSide.none,
                        shape: const StadiumBorder()
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                const Divider(),
                const SizedBox(height: 20,),
                ProfileMenuWidget(title: "Settings",icon: LineAwesomeIcons.cog_solid,onPress: (){},TextColor: Colors.grey,),
                ProfileMenuWidget(title: "Billing Details",icon: LineAwesomeIcons.wallet_solid,onPress: (){},TextColor: Colors.grey,),
                ProfileMenuWidget(title: "User Management",icon: LineAwesomeIcons.user_check_solid,onPress: (){},TextColor: Colors.grey,),
                ProfileMenuWidget(title: "Information",icon: LineAwesomeIcons.info_solid,onPress: (){},TextColor: Colors.grey,),

                const SizedBox(height: 50,),
                Button(
                  onTap: deleteAccount,
                  text: "Delete Account",
                  bgColor: Colors.red,
                ),
              ],
            ),
        )
      )
    );
  }
}
