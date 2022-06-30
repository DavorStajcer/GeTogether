import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/util/background_drawing.dart';
import 'package:get_together_app/core/widgets/get_together_title.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/profile_card_view.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/profile_card_edit.dart';
import 'package:get_together_app/features/profile_overview/presentation/widgets/user_events_and_log_out.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProfileOverviewScreenState createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  @override
  void initState() {
    BlocProvider.of<ProfileScreenCubit>(context).getScreenData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: CustomPaint(
        painter: BackgroundDrawing(context),
        child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          builder: (context, state) {
            log("STATE IS -> $state");
            return Column(
              children: [
                Flexible(
                  flex: 2,
                  child: GetTogetherTitle(
                    textColor: Colors.white.withOpacity(0.9),
                  ),
                ),
                Flexible(
                  flex: 8,
                  child:
                      _mapStateToScreen(state: state, screenSize: screenSize),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _mapStateToScreen({
    required ProfileScreenState state,
    required Size screenSize,
  }) {
    if (state is ProfileScreenServerError)
      return ServerErrorWidget(
        state.message,
        onReload: () {},
      );
    if (state is ProfileScreennNetworkError)
      return NetworkErrorWidget(
        state.message,
        onReload: () {},
      );
    else
      return Column(
        children: [
          Flexible(
            flex: 6,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 450,
              ),
              child: Container(
                width: screenSize.width * 0.75,
                height: double.infinity,
                child: _getProfileCardWidget(state, screenSize),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: UserEventsAndLogOut(
              screenSize: screenSize,
              currentState: state,
            ),
          ),
        ],
      );
  }

  Widget _getProfileCardWidget(ProfileScreenState state, Size screenSize) {
    final profilePicHeight = screenSize.width * 0.25;
    if (state is ProfileScreenEdit)
      return ProfileCardEdit(
        picHeight: profilePicHeight,
        userData: state.lastUserData,
      );
    else if (state is ProfileScreenView)
      return ProfileCardView(
        picHeight: profilePicHeight,
        currentUserData: state.userProfileData,
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}
