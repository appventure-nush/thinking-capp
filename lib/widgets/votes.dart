import 'package:flutter/material.dart';

class Votes extends StatefulWidget {
  final int upvotes;
  final bool? vote;

  const Votes({
    Key? key,
    required this.upvotes,
    required this.vote,
  }) : super(key: key);

  @override
  State<Votes> createState() => _VotesState();
}

class _VotesState extends State<Votes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_upward,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            '${widget.upvotes}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_downward,
            size: 20,
          ),
        ],
      ),
    );
  }
}
