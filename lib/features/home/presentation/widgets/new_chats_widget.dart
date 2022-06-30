import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/util/circle_image_clipper.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_chats_bloc/new_chats_bloc.dart';
import 'package:get_together_app/features/home/presentation/screens/home_screen.dart';

class NewChats extends StatefulWidget {
  final Function(HomeScreen) mapScreenToNavBarIcon;
  final double iconSize;
  final Color iconColor;
  const NewChats({
    Key? key,
    required this.mapScreenToNavBarIcon,
    required this.iconColor,
    required this.iconSize,
  }) : super(key: key);

  @override
  _NewChatsState createState() => _NewChatsState();
}

class _NewChatsState extends State<NewChats> {
  late NewChatsBloc newChatsBloc;

  @override
  void initState() {
    super.initState();
    newChatsBloc = BlocProvider.of<NewChatsBloc>(context);
    newChatsBloc.add(HomeScreenOpened());
  }

  @override
  void dispose() {
    newChatsBloc.add(NewChatsClosing());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = HomeScreen.chats_overview;
    return BlocBuilder<NewChatsBloc, NewChatsState>(
      builder: (context, state) {
        if (state is NewChatsStateLoaded)
          return state.newChatsNum == 0
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
                                state.newChatsNum.toString(),
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
