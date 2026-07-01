import 'package:flutter/material.dart';

class CarouselIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Function(int) onPageChanged;

  const CarouselIndicators({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () => onPageChanged(index),
          child: Container(
            width: currentIndex == index ? (isMobile ? 12 : 14) : 8,
            height: isMobile ? 8 : 10,
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 3 : 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentIndex == index
                  ? Colors.blue.shade700
                  : Colors.blue.shade300.withOpacity(0.5),
              boxShadow: currentIndex == index
                  ? [
                      BoxShadow(
                        color: Colors.blue.shade300.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
