import 'package:pdf/widgets.dart';

class InfoItemPdf extends StatelessWidget {
  final String title;
  final String value;
  final Font? font;
  final EdgeInsets margin;

  InfoItemPdf({
    required this.title,
    required this.value,
    required this.font,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(Context context) {
    return Padding(
      padding: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(font: font, fontSize: 10),
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
          Text(
            value,
            style: TextStyle(font: font, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
