import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/get_together_title.dart';
import 'package:get_together_app/core/widgets/event_card/event_card.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/user_events_overview/presentation/bloc/cubit/user_events_cubit.dart';
import 'package:get_together_app/features/user_events_overview/presentation/widgets/no_user_events.dart';

class UserEventsScreen extends StatelessWidget {
  static const route = "/user_events_screen";
  const UserEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<UserEventsCubit>(
          create: (_) => getIt<UserEventsCubit>(),
          child: Builder(
              builder: (context) => Column(
                    children: [
                      Container(
                        height: screenSize.height * 0.1,
                        alignment: Alignment.topCenter,
                        child: GetTogetherTitle(
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                          child: BlocBuilder<UserEventsCubit, UserEventsState>(
                        builder: (context, state) {
                          if (state is UserEventsInitial) {
                            BlocProvider.of<UserEventsCubit>(context)
                                .fetchEvents();
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is UserEventsNetworkFailure)
                            return NetworkErrorWidget(state.message,
                                onReload: () =>
                                    BlocProvider.of<UserEventsCubit>(context)
                                        .fetchEvents());
                          if (state is UserEventsServerFailure)
                            return ServerErrorWidget(state.message,
                                onReload: () =>
                                    BlocProvider.of<UserEventsCubit>(context)
                                        .fetchEvents());
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.15),
                            child: (state as UserEventsLoaded)
                                        .userAdminEvents
                                        .length ==
                                    0
                                ? NoUserEvents()
                                : ListView.builder(
                                    itemCount: state.userAdminEvents.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: screenSize.width * 0.7,
                                        child: EventCard(
                                          event: state.userAdminEvents[index],
                                          width: screenSize.width * 0.6,
                                          color: Colors.white,
                                          elevation: 1,
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      )),
                    ],
                  )),
        ),
      ),
    );
  }
}
