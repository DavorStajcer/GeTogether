import 'package:flutter/material.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';

class EventButtonWithBackIcon extends StatelessWidget {
  final String text;
  final bool isOn;
  final Function() goBack;
  final Function() goFowards;
  const EventButtonWithBackIcon(
      {Key? key,
      required this.text,
      bool? isOn,
      required this.goBack,
      required this.goFowards})
      : isOn = isOn ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: goBack),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: EventButton(
                text: text,
                navigate: goFowards,
                textColor: isOn ? null : Colors.black45,
                buttonColor: isOn ? null : Colors.grey,
                isOn: isOn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
