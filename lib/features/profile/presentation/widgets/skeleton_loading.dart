import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class SkeletonLoading extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SkeletonProfileCard extends StatelessWidget {
  const SkeletonProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SkeletonLoading(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoading(width: 120, height: 16),
                const SizedBox(height: 8),
                SkeletonLoading(width: 80, height: 12),
                const SizedBox(height: 4),
                SkeletonLoading(width: 100, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(3, (index) => 
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  SkeletonLoading(width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
                  const SizedBox(height: 8),
                  SkeletonLoading(width: 60, height: 12),
                  const SizedBox(height: 4),
                  SkeletonLoading(width: 40, height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonCertificationChip extends StatelessWidget {
  const SkeletonCertificationChip({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      width: 120,
      height: 32,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class SkeletonAvailabilityItem extends StatelessWidget {
  const SkeletonAvailabilityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonLoading(width: 60, height: 12),
        const SizedBox(width: 8),
        SkeletonLoading(width: 80, height: 12),
        const SizedBox(width: 8),
        SkeletonLoading(width: 8, height: 8, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }
}

class SkeletonReviewCard extends StatelessWidget {
  const SkeletonReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoading(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          SkeletonLoading(width: 200, height: 12),
          const SizedBox(height: 8),
          SkeletonLoading(width: double.infinity, height: 60),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) => 
              Container(
                margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                child: SkeletonLoading(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
