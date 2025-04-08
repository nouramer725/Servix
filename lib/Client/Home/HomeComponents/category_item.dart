import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Model/Category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key,
      required this.category,
      required this.index,
      required this.onTap});

  final Category category;
  final int index; // Determines layout
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isImageOnRight =
        index.isEven; // Even index → Image on right, Text on left

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: category.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: isImageOnRight
                ? _buildRowWithImageOnRight() // Even index → Image on right
                : _buildRowWithImageOnLeft(), // Odd index → Image on left
          ),
        ),
      ),
    );
  }

  // Image on the right
  List<Widget> _buildRowWithImageOnRight() {
    return [
      _buildTextContainer(),
      _buildImageContainer(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ];
  }

  // Image on the left
  List<Widget> _buildRowWithImageOnLeft() {
    return [
      _buildImageContainer(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      _buildTextContainer(),
    ];
  }

  Widget _buildTextContainer() {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          category.categoryname,
          style: GoogleFonts.castoro(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer({required BorderRadius borderRadius}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          category.image,
          height: category.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
