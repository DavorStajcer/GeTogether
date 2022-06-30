import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';

class EditAndSettings extends StatelessWidget {
  final UserDataPublic currentUserData;
  final double picHeight;
  const EditAndSettings(
      {Key? key, required this.picHeight, required this.currentUserData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: picHeight,
              padding:
                  EdgeInsets.only(top: picHeight * 0.6, right: picHeight * 0.2),
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => BlocProvider.of<ProfileScreenCubit>(context)
                    .editProfile(currentUserData),
              ),
            ),
          ),
          Expanded(
              child: Container(
            width: picHeight,
            height: picHeight,
            padding: EdgeInsets.only(bottom: 15), //mimic the picture size
          )),
          Flexible(
            flex: 1,
            child: Container(
              height: picHeight,
              //TODO: SETTINGS IS NOT YET IMPLEMENTED IN THE APPLICATION
              /*        padding:
                  EdgeInsets.only(top: picHeight * 0.6, left: picHeight * 0.2),
              alignment: Alignment.center,
              child: Icon(
                Icons.settings,
                color: Color.fromRGBO(40, 53, 147, 1),
              ), */
            ),
          ),
        ],
      ),
    );
  }
}
