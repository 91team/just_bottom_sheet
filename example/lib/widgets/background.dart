import 'package:flutter/widgets.dart';

class Background extends StatelessWidget {
  const Background({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage('https://techrocks.ru/wp-content/uploads/2019/10/Google-Maps-API-min-1024x610.png'),
      fit: BoxFit.cover,
    );
  }
}
