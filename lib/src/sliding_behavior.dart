import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller.dart';

import 'inner_controller_provider.dart';

const _kNotFound = -1;

typedef OnSlideCallback = void Function(double value);

typedef OnSnapCallback = void Function(int value);

class SlidingBehavior extends StatefulWidget {
  final Widget child;

  final double minHeight;

  final double maxHeight;

  final List<double> snapPoints;

  final OnSlideCallback? onSlide;

  final OnSnapCallback? onSnap;

  final bool isDraggable;

  final int initialAnchorIndex;

  const SlidingBehavior({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
    required this.onSlide,
    required this.onSnap,
    required this.snapPoints,
    required this.isDraggable,
    this.initialAnchorIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _SlidingBehaviorState createState() => _SlidingBehaviorState();
}

class _SlidingBehaviorState extends State<SlidingBehavior> with SingleTickerProviderStateMixin {
  late final AnimationController _slidingAnimation;
  late final BottomSheetInnerController _bottomSheetController;
  late int _currentSnapPoint;

  bool _isDragJustStarted = false;

  double get minHeight => widget.minHeight;
  double get maxHeight => widget.maxHeight;
  double get currentSheetHeight => _slidingAnimation.value * (maxHeight - minHeight) + minHeight;

  double get currentBottomSheetPosition => _slidingAnimation.value;
  bool get isSliding => _slidingAnimation.isAnimating;
  bool get isOpened => _slidingAnimation.value == widget.snapPoints.last;

  @override
  void initState() {
    super.initState();

    _currentSnapPoint = widget.initialAnchorIndex;

    _slidingAnimation = AnimationController(
      vsync: this,
      value: widget.snapPoints[_currentSnapPoint],
    );

    _slidingAnimation.addListener(_onSlide);
    _slidingAnimation.addStatusListener(_onSlideAnimationStatusChanged);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _bottomSheetController = BottomSheetInnerControllerProvider.of(context);
      if (widget.initialAnchorIndex == widget.snapPoints.length - 1) {
        _bottomSheetController.enableScroll();
      }
    });
  }

  @override
  void dispose() {
    _slidingAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onDragStart,
      onPointerMove: _onDragUpdate,
      onPointerUp: _onDragEnd,
      child: AnimatedBuilder(
        animation: _slidingAnimation,
        builder: (context, child) => SizedBox(
          height: currentSheetHeight,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }

  Future<void> snapTo(int anchorIndex) {
    final positionToAnimate = widget.snapPoints[anchorIndex];

    return _slidingAnimation.animateTo(
      positionToAnimate,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _onSlide() {
    widget.onSlide?.call(_slidingAnimation.value);
  }

  void _onSlideAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final anchorIndex = widget.snapPoints.indexWhere((anchor) => anchor == _slidingAnimation.value);
      if (anchorIndex != _kNotFound) {
        widget.onSnap?.call(anchorIndex);
      }

      if (_slidingAnimation.value == widget.snapPoints.last) {
        _bottomSheetController.enableScroll();
      }
    }
  }

  void _onDragStart(PointerDownEvent event) {
    if (!widget.isDraggable) {
      return;
    }

    _isDragJustStarted = true;

    if (_slidingAnimation.isAnimating) {
      _slidingAnimation.stop();
    }
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if (!widget.isDraggable) {
      return;
    }

    if (_isDragJustStarted) {
      if (isOpened &&
          event.delta.dy > 0 &&
          _bottomSheetController.isScrollEnabled &&
          _bottomSheetController.scrollController.offset <= 0) {
        _bottomSheetController.disableScroll();
      }
      _isDragJustStarted = false;
    }

    if (_bottomSheetController.isDraggingLocked) {
      return;
    }

    _slidingAnimation.value -= event.delta.dy / (maxHeight - minHeight);
  }

  void _onDragEnd(PointerUpEvent event) {
    if (!widget.isDraggable || _bottomSheetController.isDraggingLocked) {
      return;
    }

    final y = _slidingAnimation.value;

    final snapPointIndex = _findPointToSnapIndex(y);
    snapTo(snapPointIndex);
  }

  int _findPointToSnapIndex(double currentValue) {
    final anchorsCopy = <double>[...widget.snapPoints];

    anchorsCopy.sort((a, b) => (a - currentValue).abs().compareTo((b - currentValue).abs()));

    final nearestAnchorIndex = widget.snapPoints.indexOf(anchorsCopy.first);

    return nearestAnchorIndex;
  }
}

class SlidingBehaviorController {
  late _SlidingBehaviorState _slidingBehavior;

  bool get isSliding => _slidingBehavior.isSliding;
  double get currentBottomSheetPosition => _slidingBehavior.currentBottomSheetPosition;

  void snapTo(int snapPointIndex) {
    _slidingBehavior.snapTo(snapPointIndex);
  }

  void _attach(_SlidingBehaviorState behavior) {
    _slidingBehavior = behavior;
  }
}
