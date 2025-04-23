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
    final isEven = index.isEven;

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
          // Let Flutter auto-flip in RTL:
          child: Row(
            children: isEven
                ? _buildRowWithImageAtOutside()    // “outside” means trailing in LTR, leading in RTL
                : _buildRowWithImageAtInside(),    // “inside” means leading in LTR, trailing in RTL
          ),
        ),
      ),
    );
  }

  // Even (outside image)
  List<Widget> _buildRowWithImageAtOutside() {
    return [
      // Text first (leading in LTR, trailing in RTL)
      _buildTextContainer(),
      // Image second (trailing in LTR, leading in RTL)
      _buildImageContainer(
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(20),
          bottomEnd: Radius.circular(20),
        ),
      ),
    ];
  }

  // Odd (inside image)
  List<Widget> _buildRowWithImageAtInside() {
    return [
      // Image first (leading in LTR, trailing in RTL)
      _buildImageContainer(
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
          bottomStart: Radius.circular(20),
        ),
      ),
      // Text second (trailing in LTR, leading in RTL)
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
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer({required BorderRadiusDirectional borderRadius}) {
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

