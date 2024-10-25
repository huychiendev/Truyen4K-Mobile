import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onSelected;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onSelected,
  }) : super(key: key);

  Future<File> resizeImage(String imagePath, int width, int height) async {
    final file = File(imagePath);
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.parent.path}/resized_${file.path
          .split('/')
          .last}',
      quality: 80,
      minWidth: width,
      minHeight: height,
    );
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Phương thức thanh toán',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              _buildPaymentMethod(
                'zalopayapp',
                'ZaloPay',
                'assets/zalopay.png',
              ),
              SizedBox(height: 12),
              _buildPaymentMethod(
                'momo',
                'Momo',
                'assets/momo.png',
              ),
              SizedBox(height: 12),
              _buildPaymentMethod(
                'CC',
                'Credit/Debit Card',
                'assets/icard.png',
              ),
              SizedBox(height: 12),
              _buildPaymentMethod(
                'ATM',
                'Internet Banking',
                'assets/bank.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String id, String name, String iconPath) {
    final isSelected = selectedMethod == id;

    return GestureDetector(
      onTap: () => onSelected(id),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<File>(
              future: resizeImage(iconPath, 24, 24),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.file(
                    snapshot.data!,
                    width: 24,
                    height: 24,
                  );
                } else {
                  return SizedBox(width: 24, height: 24);
                }
              },
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}