import 'package:flutter/material.dart';

class SquareRotatingIndicator extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;
  final double borderRadius;
  final Duration duration;

  const SquareRotatingIndicator({
    required this.size,
    this.backgroundColor = Colors.transparent,
    this.valueColor = Colors.blue,
    this.strokeWidth = 5.0,
    this.borderRadius = 0.0,
    this.duration = const Duration(seconds: 2),
    Key? key,
  }) : super(key: key);

  @override
  _SquareRotatingIndicatorState createState() =>
      _SquareRotatingIndicatorState();
}

class _SquareRotatingIndicatorState extends State<SquareRotatingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              RotationTransition(
                turns: _animationController,
                child: _buildSquareProgress(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSquareProgress() {
    return Container(
      width: widget.size - widget.strokeWidth,
      height: widget.size - widget.strokeWidth,
      decoration: BoxDecoration(
        border: Border.all(color: widget.valueColor, width: widget.strokeWidth),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
    );
  }
}
