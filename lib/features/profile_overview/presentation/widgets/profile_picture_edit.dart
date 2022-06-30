import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';

class ProfilePictureEdit extends StatelessWidget {
  final String imageUrl;
  final double picHeight;
  const ProfilePictureEdit({
    Key? key,
    required this.picHeight,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: picHeight,
      width: picHeight * 1.1,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: picHeight,
            height: picHeight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(imageUrl),
              ),
              color: Colors.grey,
            ),
          ),
          Container(
            width: double.infinity,
            height: picHeight / 3 + 10,
            // color: Colors.blue,
            alignment: Alignment.topRight,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.mode_edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    BlocProvider.of<ProfileScreenCubit>(context).changeImage();
                  },
                )),
          )
        ],
      ),
    );
  }
}
