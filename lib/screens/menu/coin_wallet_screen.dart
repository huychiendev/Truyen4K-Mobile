import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/models/User.dart';

class CoinWalletScreen extends StatefulWidget {
  final String username;
  final String email;
  final int coinBalance;
  final UserProfile userProfile;
  final UserImage? userImage;

  const CoinWalletScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.coinBalance,
    required this.userProfile,
    this.userImage,
  }) : super(key: key);

  @override
  _CoinWalletScreenState createState() => _CoinWalletScreenState();
}

class _CoinWalletScreenState extends State<CoinWalletScreen> {
  ImageProvider _getProfileImage() {
    if (widget.userImage?.data != null) {
      try {
        return MemoryImage(base64Decode(widget.userImage!.data));
      } catch (e) {
        print('Error decoding image data: $e');
        return AssetImage('assets/avt.png');
      }
    }
    return AssetImage('assets/avt.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ví của tôi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildWalletCard(),
            Expanded(
              child: _buildCoinGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceWidget(IconData icon, String amount, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildWalletCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.deepPurple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _getProfileImage(),
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading avatar image: $exception');
                },
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userProfile.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.userProfile.email,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  widget.userProfile.tierName,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          _buildBalanceWidget(
            Icons.monetization_on_outlined,
            '${widget.userProfile.coinBalance}',
            'Xu',
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildCoinGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _coinOptions.length,
      itemBuilder: (context, index) {
        final option = _coinOptions[index];
        return _buildPurchaseCard(option);
      },
    );
  }

  List<_PurchaseOption> get _coinOptions => [
    _PurchaseOption(
      amount: '1.000',
      price: '20.000đ',
      bonus: '',
      isPopular: false,
    ),
    _PurchaseOption(
      amount: '5.000',
      price: '100.000đ',
      bonus: '+10%',
      isPopular: true,
    ),
    _PurchaseOption(
      amount: '10.000',
      price: '200.000đ',
      bonus: '+15%',
      isPopular: false,
    ),
    _PurchaseOption(
      amount: '20.000',
      price: '400.000đ',
      bonus: '+25%',
      isPopular: false,
    ),
    _PurchaseOption(
      amount: '50.000',
      price: '1.000.000đ',
      bonus: '+35%',
      isPopular: false,
    ),
    _PurchaseOption(
      amount: '100.000',
      price: '2.000.000đ',
      bonus: '+40%',
      isPopular: false,
    ),
  ];

  Widget _buildPurchaseCard(_PurchaseOption option) {
    return GestureDetector(
      onTap: () => _showPurchaseConfirmation(option.amount, option.price),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: option.isPopular ? Colors.purple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            if (option.isPopular)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Phổ biến',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    size: 40,
                    color: Colors.amber,
                  ),
                  SizedBox(height: 16),
                  Text(
                    option.amount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    option.price,
                    style: TextStyle(color: Colors.white70),
                  ),
                  if (option.bonus.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        option.bonus,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(String amount, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Xác nhận mua',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có muốn mua $amount xu với giá $price?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPurchaseSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Giao dịch thành công!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _PurchaseOption {
  final String amount;
  final String price;
  final String bonus;
  final bool isPopular;

  _PurchaseOption({
    required this.amount,
    required this.price,
    required this.bonus,
    required this.isPopular,
  });
}