import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/util/circle_image_clipper.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_notifications_bloc/new_notifications_bloc.dart';
import 'package:get_together_app/features/home/presentation/screens/home_screen.dart';

class NewNotifications extends StatefulWidget {
  final Function(HomeScreen) mapScreenToNavBarIcon;
  final double iconSize;
  final Color iconColor;
  const NewNotifications({
    Key? key,
    required this.mapScreenToNavBarIcon,
    required this.iconColor,
    required this.iconSize,
  }) : super(key: key);

  @override
  _NewNotificationsState createState() => _NewNotificationsState();
}

class _NewNotificationsState extends State<NewNotifications> {
  late NewNotificationsBloc newNotificationsBloc;

  @override
  void initState() {
    super.initState();
    newNotificationsBloc = BlocProvider.of<NewNotificationsBloc>(context);
    newNotificationsBloc.add(HomeScreenOpened());
  }

  @override
  void dispose() {
    newNotificationsBloc.add(NewNotificationsClosing());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = HomeScreen.notifications_overview;
    return BlocBuilder<NewNotificationsBloc, NewNotificationsState>(
      builder: (context, state) {
        if (state is NewNotificationsLoaded)
          return state.newNotificationsNum == 0
              ? Icon(
                  widget.mapScreenToNavBarIcon(screen),
                  size: widget.iconSize,
                  color: widget.iconColor,
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        widget.mapScreenToNavBarIcon(screen),
                        size: widget.iconSize,
                        color: widget.iconColor,
                      ),
                      Container(
                        width: 17,
                        height: 17,
                        child: ClipPath(
                          clipper: CircleImageClipper(),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            color: Theme.of(context).primaryColor,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                state.newNotificationsNum.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        else
          return Icon(
            widget.mapScreenToNavBarIcon(screen),
            size: widget.iconSize,
            color: widget.iconColor,
          );
      },
    );
  }
}
