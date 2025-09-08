import 'package:flutter/material.dart';

class BatikSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const BatikSearchBar({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari informasi batik...',
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.brown.withOpacity(0.5),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 246, 241),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFF8A5A44), width: 1.5),
            ),
            prefixIcon:
                Icon(Icons.search, color: Colors.brown.withOpacity(0.7)),
          ),
          onChanged: onChanged,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ),
    );
  }
}
