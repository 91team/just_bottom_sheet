import 'package:flutter/widgets.dart';

class JustBottomSheet extends StatefulWidget {
  final List<double> anchors;
  final Function(double value) onSlide;
  final Function(int anchorIndex) onSnap;

  JustBottomSheet({
    @required this.anchors,
    this.onSlide,
    this.onSnap,
    Key key,
  }) : super(key: key);

  @override
  _JustBottomSheetState createState() => _JustBottomSheetState();
}

class _JustBottomSheetState extends State<JustBottomSheet> with SingleTickerProviderStateMixin {
  AnimationController slidingAnimation;

  double get minHeight => widget.anchors.first;
  double get maxHeight => widget.anchors.last;

  @override
  void initState() {
    slidingAnimation = AnimationController(vsync: this);
    slidingAnimation.addListener(_onSlide);
    slidingAnimation.addStatusListener(_onSlideAnimationStatusChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: slidingAnimation,
        builder: (BuildContext context, Widget child) {
          return SizedBox(
            height: _calculateSheetHeight(),
            child: child,
          );
        },
        child: SizedBox(
          height: maxHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFF0000),
            ),
          ),
        ),
      ),
    );
  }

  void _onSlide() {
    if (widget.onSlide != null) {
      widget.onSlide(slidingAnimation.value);
    }
  }

  void _onSlideAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final anchorIndex = widget.anchors.indexWhere((anchor) => anchor == slidingAnimation.value);
      if (anchorIndex != -1 && widget.onSnap != null) {
        widget.onSnap(anchorIndex);
      }
    }
  }

  double _calculateSheetHeight() {
    return slidingAnimation.value * (maxHeight - minHeight) + minHeight;
  }
}
