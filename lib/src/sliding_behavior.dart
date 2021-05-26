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

  final int initialSnapPointIndex;

  const SlidingBehavior({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
    required this.onSlide,
    required this.onSnap,
    required this.snapPoints,
    this.initialSnapPointIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _SlidingBehaviorState createState() => _SlidingBehaviorState();
}

class _SlidingBehaviorState extends State<SlidingBehavior> with SingleTickerProviderStateMixin {
  late final AnimationController _slidingAnimation;
  late final BottomSheetInnerController _bottomSheetController;

  bool _isDragJustStarted = false;

  late Offset _dragStartPosition;

  double get minHeight => widget.minHeight;

  double get maxHeight => widget.maxHeight;

  double get currentSheetHeight => _slidingAnimation.value * (maxHeight - minHeight) + minHeight;

  bool get isSliding => _slidingAnimation.isAnimating;

  bool get isOpened => _slidingAnimation.value == widget.snapPoints.last;

  @override
  void initState() {
    super.initState();

    _slidingAnimation = AnimationController(
      vsync: this,
      value: widget.snapPoints[widget.initialSnapPointIndex],
    );

    _slidingAnimation.addListener(_onSlide);
    _slidingAnimation.addStatusListener(_onSlideAnimationStatusChanged);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _bottomSheetController = BottomSheetInnerControllerProvider.of(context);
      if (widget.initialSnapPointIndex == widget.snapPoints.length - 1) {
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
      behavior: HitTestBehavior.opaque,
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
    _isDragJustStarted = true;

    _dragStartPosition = event.localPosition;

    if (_slidingAnimation.isAnimating) {
      _slidingAnimation.stop();
    }
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if (event.delta == Offset.zero) {
      return;
    }

    if (_isDragJustStarted) {
      if (isOpened &&
          event.delta.dy > 0 &&
          _bottomSheetController.isContentScrollEnabled &&
          _bottomSheetController.scrollController.offset <= 0) {
        _bottomSheetController.disableScroll();
      }
      _isDragJustStarted = false;
    }

    if (_bottomSheetController.isContentScrollEnabled) {
      return;
    }

    _slidingAnimation.value -= event.delta.dy / (maxHeight - minHeight);
  }

  void _onDragEnd(PointerUpEvent event) {
    if (_bottomSheetController.isContentScrollEnabled) {
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
