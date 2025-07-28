import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skinsight/core/theme/app_color.dart';

// class MarkdownViewer extends StatelessWidget {
//   final String markdownData;
//   const MarkdownViewer({super.key, required this.markdownData});

//   @override
//   Widget build(BuildContext context) {
//     final baseTextStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
//         );

//     return MarkdownBody(
//       data: markdownData,
//       styleSheet: MarkdownStyleSheet(
//         h1: baseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
//         h2: baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
//         h3: baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
//         h4: baseTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
//         h5: baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
//         h6: baseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600),

//         p: baseTextStyle,

//         strong: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
//         em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),

//         listBullet: baseTextStyle,
//         listIndent: 24.0,
//         blockSpacing: 6.0,

//         code: baseTextStyle.copyWith(
//           backgroundColor: const Color(0xFFF5F5F5),
//           fontSize: 12,
//           fontFamily: 'Courier',
//         ),

//         blockquote: baseTextStyle.copyWith(
//           fontStyle: FontStyle.italic,
//           color: Colors.black87,
//         ),

//         horizontalRuleDecoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(width: 1, color: Colors.grey.shade300),
//           ),
//         ),

//         img: baseTextStyle.copyWith(
//           fontStyle: FontStyle.italic,
//           color: Colors.grey,
//         ),
//         textAlign: WrapAlignment.start,
//       ),
//       sizedImageBuilder: (config) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               config.uri.toString(),
//               width: double.infinity,
//               height: 152,
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


class MarkdownViewer extends StatelessWidget {
  final String markdownData;
  const MarkdownViewer({super.key, required this.markdownData});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium!;
    final baseTextStyle = base.copyWith(height: 1.6); // ← tinggi baris biar enak dibaca

    return MarkdownBody(
      data: markdownData,
      styleSheet: MarkdownStyleSheet(
        p: baseTextStyle.copyWith(fontSize: 14),

        h1: baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        h2: baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        h3: baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        h4: baseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
        h5: baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        h6: baseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600),

        strong: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
        em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),

        blockquote: baseTextStyle.copyWith(
          fontStyle: FontStyle.italic,
          color: kMainTextColor,
        ),

        code: baseTextStyle.copyWith(
          fontFamily: 'Inter',
          backgroundColor: const Color(0xFFF5F5F5),
          fontSize: 13,
        ),

        listBullet: baseTextStyle.copyWith(fontSize: 14),
        listIndent: 16,
        listBulletPadding: const EdgeInsets.symmetric(horizontal: 8),

        tableHead: baseTextStyle.copyWith(
            fontWeight: FontWeight.bold, color: kMainTextColor),
        tableBody: baseTextStyle,

        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Colors.grey.shade300),
          ),
        ),

        img: baseTextStyle.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),

        blockSpacing: 16.0, 
        textAlign: WrapAlignment.start,
      ),

      sizedImageBuilder: (config) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              config.uri.toString(),
              width: double.infinity,
              height: 152,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

