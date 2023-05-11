import 'package:flutter/material.dart';

class SquareProgressIndicator extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Color valueColor;
  final double strokeWidth;
  final double borderRadius;
  final Duration duration;

  const SquareProgressIndicator({
    required this.size,
    this.backgroundColor = Colors.transparent,
    this.valueColor = Colors.blue,
    this.strokeWidth = 5.0,
    this.borderRadius = 0.0,
    this.duration = const Duration(seconds: 2),
    Key? key,
  }) : super(key: key);

  @override
  _SquareProgressIndicatorState createState() =>
      _SquareProgressIndicatorState();
}

class _SquareProgressIndicatorState extends State<SquareProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation =
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: child,
        );
      },
      child: _buildSquareProgress(),
    );
  }

  Widget _buildSquareProgress() {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          Container(
            width: widget.size - widget.strokeWidth,
            height: widget.size - widget.strokeWidth,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.valueColor, width: widget.strokeWidth),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          Container(
            width: widget.size - widget.strokeWidth,
            height: widget.size - widget.strokeWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
