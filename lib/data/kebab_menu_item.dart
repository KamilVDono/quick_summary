import 'package:flutter/material.dart';

class KebabMenuItem{
  final String name;
  final IconData iconData;
  final Function(BuildContext context) onSelected;

  KebabMenuItem(this.name, this.iconData, this.onSelected);

  PopupMenuItem<KebabMenuItem> build(){
    return PopupMenuItem<KebabMenuItem>(
      value: this,
      child: Row(
        children: [
          Icon(iconData),
          Text(name),
        ],
      ),
    );
  }
}