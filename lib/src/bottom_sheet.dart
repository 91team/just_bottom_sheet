import 'package:flutter/widgets.dart';

class JustBottomSheet extends StatefulWidget {
  final Widget child;
  final List<double> anchors;
  final Function(double value) onSlide;
  final Function(int anchorIndex) onSnap;
  final BoxDecoration panelDecoration;

  JustBottomSheet({
    @required this.child,
    @required this.anchors,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
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
      child: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: slidingAnimation,
          builder: (BuildContext context, Widget child) {
            return SizedBox(
              height: _calculateSheetHeight(),
              child: child,
            );
          },
          // SingleChildScrollView used to avoid overflow exception
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: maxHeight,
              child: DecoratedBox(
                decoration: widget.panelDecoration ?? BoxDecoration(color: Color(0xFFFFFFFF)),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    slidingAnimation.dispose();
    super.dispose();
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

  void _onDragUpdate(DragUpdateDetails event) {
    slidingAnimation.value -= event.delta.dy / (maxHeight - minHeight);
  }

  void _onDragEnd(DragEndDetails event) {
    //
  }

  double _calculateSheetHeight() {
    return slidingAnimation.value * (maxHeight - minHeight) + minHeight;
  }

  void snapTo(int anchorIndex) {
    // Run snap animation
  }
}
