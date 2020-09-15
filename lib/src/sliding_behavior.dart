import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller.dart';

import 'inner_controller_provider.dart';

const _kNotFound = -1;

class SlidingBehavior extends StatefulWidget {
  final Widget child;
  final SlidingBehaviorController controller;

  final double minHeight;
  final double maxHeight;
  final List<double> anchors;
  final void Function(double value) onSlide;
  final void Function(int anchorIndex) onSnap;
  final bool isDraggable;
  final int initialAnchorIndex;

  const SlidingBehavior({
    @required this.child,
    @required this.controller,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.onSlide,
    @required this.onSnap,
    this.isDraggable,
    this.anchors,
    this.initialAnchorIndex = 0,
    Key key,
  }) : super(key: key);

  @override
  _SlidingBehaviorState createState() => _SlidingBehaviorState();
}

class _SlidingBehaviorState extends State<SlidingBehavior> with SingleTickerProviderStateMixin {
  AnimationController slidingAnimation;
  BottomSheetInnerController bottomSheetController;
  final velocityTracker = VelocityTracker();
  int currentSnapPoint;

  bool isDragJustStarted = false;

  double get minHeight => widget.minHeight;
  double get maxHeight => widget.maxHeight;
  double get currentSheetHeight => slidingAnimation.value * (maxHeight - minHeight) + minHeight;

  double get currentBottomSheetPosition => slidingAnimation.value;
  bool get isSliding => slidingAnimation.isAnimating;
  bool get isOpened => slidingAnimation.value == widget.anchors.last;

  @override
  void initState() {
    currentSnapPoint = widget.initialAnchorIndex;

    slidingAnimation = AnimationController(
      vsync: this,
      value: widget.anchors[currentSnapPoint],
    );
    slidingAnimation.addListener(_onSlide);
    slidingAnimation.addStatusListener(_onSlideAnimationStatusChanged);

    widget.controller._attach(this);

    super.initState();

    Future.delayed(Duration.zero, () {
      bottomSheetController = BottomSheetInnerControllerProvider.of(context);
      if (widget.initialAnchorIndex == widget.anchors.length - 1) {
        bottomSheetController.enableScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onDragStart,
      onPointerMove: _onDragUpdate,
      onPointerUp: _onDragEnd,
      child: AnimatedBuilder(
        animation: slidingAnimation,
        builder: (context, child) => SizedBox(
          height: currentSheetHeight,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    slidingAnimation.dispose();
    super.dispose();
  }

  Future<void> snapTo(int anchorIndex) {
    final positionToAnimate = widget.anchors[anchorIndex];

    return slidingAnimation.animateTo(
      positionToAnimate,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
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
      if (anchorIndex != _kNotFound && widget.onSnap != null) {
        widget.onSnap(anchorIndex);
      }

      if (slidingAnimation.value == widget.anchors.last) {
        bottomSheetController.enableScroll();
      }
    }
  }

  void _onDragStart(PointerDownEvent event) {
    if (!widget.isDraggable) {
      return;
    }

    isDragJustStarted = true;

    if (slidingAnimation.isAnimating) {
      slidingAnimation.stop();
    }
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if (!widget.isDraggable) {
      return;
    }

    if (isDragJustStarted) {
      if (isOpened &&
          event.delta.dy > 0 &&
          bottomSheetController.isScrollEnabled &&
          bottomSheetController.scrollController.offset <= 0) {
        bottomSheetController.disableScroll();
      }
      isDragJustStarted = false;
    }

    if (bottomSheetController.isDraggingLocked) {
      return;
    }

    velocityTracker.addPosition(event.timeStamp, event.position);
    slidingAnimation.value -= event.delta.dy / (maxHeight - minHeight);
  }

  void _onDragEnd(PointerUpEvent event) {
    if (!widget.isDraggable || bottomSheetController.isDraggingLocked) {
      return;
    }

    final y = slidingAnimation.value;
    final velocity = velocityTracker.getVelocity();

    final velocityY = velocity.pixelsPerSecond.dy;

    final snapPointIndex = _findPointToSnapIndex(y, velocityY);
    snapTo(snapPointIndex);
  }

  int _findPointToSnapIndex(double currentValue, double velocity) {
    final anchorsCopy = <double>[...widget.anchors];

    anchorsCopy.sort((a, b) => (a - currentValue).abs().compareTo((b - currentValue).abs()));

    final nearestAnchorIndex = widget.anchors.indexOf(anchorsCopy.first);

    return nearestAnchorIndex;

    // final upperAnchorIndex = widget.anchors.indexWhere((anchor) => anchor >= currentValue);
    // final bottomAnchorIndex = widget.anchors.lastIndexWhere((anchor) => anchor < currentValue);

    // if (velocity < 0 && upperAnchorIndex != _kNotFound) {
    //   return upperAnchorIndex;
    // } else {
    //   return bottomAnchorIndex == _kNotFound ? 0 : bottomAnchorIndex;
    // }
  }
}

class SlidingBehaviorController {
  _SlidingBehaviorState slidingBehavior;

  bool get isSliding => slidingBehavior.isSliding;
  double get currentBottomSheetPosition => slidingBehavior.currentBottomSheetPosition;

  void snapTo(int snapPointIndex) {
    slidingBehavior.snapTo(snapPointIndex);
  }

  void _attach(_SlidingBehaviorState behavior) {
    slidingBehavior = behavior;
  }
}
