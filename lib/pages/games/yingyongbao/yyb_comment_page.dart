import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// jacokwu
/// 8/13/21 3:07 PM

class YYBCommentPage extends StatefulWidget {
  final YYBListModel appDetail;

  const YYBCommentPage({Key? key, required this.appDetail}) : super(key: key);

  @override
  _YYBCommentPageState createState() => _YYBCommentPageState();
}

class _YYBCommentPageState extends State<YYBCommentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildPlayerRatingWidget(),
            Dimens.hGap12,
            ..._buildCommentContainerWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlayerRatingWidget() {
    return [
      Padding(
        padding: EdgeInsets.only(bottom: Dimens.pd12),
        child: Text(
          '玩家评星',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: Dimens.font_size_18),
        ),
      ),
      Card(
        color: Color(0xfff0f0f0),
        shadowColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Center(
                      child: Text(
                    widget.appDetail.averageRating.toStringAsFixed(1),
                    style: TextStyle(fontSize: 60),
                  ))),
              Expanded(flex: 7, child: _buildRatingWidget()),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildRatingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Dimens.pd8),
          child: Text(
            '${unitConverter(widget.appDetail.appRatingInfo.ratingCount)}人评分',
            style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12),
          ),
        ),
        _buildRatingProgressWidget(5, widget.appDetail.appRatingInfo.ratingDistribution.i5),
        _buildRatingProgressWidget(4, widget.appDetail.appRatingInfo.ratingDistribution.i4),
        _buildRatingProgressWidget(3, widget.appDetail.appRatingInfo.ratingDistribution.i3),
        _buildRatingProgressWidget(2, widget.appDetail.appRatingInfo.ratingDistribution.i2),
        _buildRatingProgressWidget(1, widget.appDetail.appRatingInfo.ratingDistribution.i1),
      ],
    );
  }

  Widget _buildRatingProgressWidget(int star, int ratingCount) {
    print(ratingCount / widget.appDetail.appRatingInfo.ratingCount * 100);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(star.toString(), style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12)),
        Icon(Icons.star_rate, size: Dimens.font_size_12, color: Constants.gray_9),
        Container(
          width: 160,
          height: 4,
          decoration: BoxDecoration(
            color: Constants.gray_c,
            borderRadius: BorderRadius.circular(50),
          ),
          clipBehavior: Clip.antiAlias,
          child: FractionallySizedBox(
            widthFactor: ratingCount / widget.appDetail.appRatingInfo.ratingCount,
            alignment: Alignment.centerLeft,
            child: Container(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCommentContainerWidget() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
        child: Text(
          '用户评价',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: Dimens.font_size_18),
        ),
      ),
      Row(
        children: [
          _buildCommentTypeButton('全部', true),
          Dimens.wGap6,
          _buildCommentTypeButton('最新', false),
          Dimens.wGap6,
          _buildCommentTypeButton('好评', false),
          Dimens.wGap6,
          _buildCommentTypeButton('中评', false),
          Dimens.wGap6,
          _buildCommentTypeButton('差评', false),
        ],
      ),
      MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _buildCommentBoxWidget(),
            separatorBuilder: (_, index) => Dimens.hGap12,
            itemCount: 20,
            shrinkWrap: true,
          )),
      safeAreaBottom(context),
    ];
  }

  Widget _buildCommentBoxWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 25,
                  child: CircleAvatar(
                    backgroundColor: Constants.gray_9,
                  )),
              Dimens.wGap6,
              _buildContentTextWidget('用户名'),
              Dimens.wGap6,
              Container(
                padding: EdgeInsets.symmetric(vertical: Dimens.pd2, horizontal: Dimens.pd4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '热门评论',
                  style: TextStyle(color: Colors.white, fontSize: Dimens.font_size_12),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 12,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 12,
                  ),
                  Icon(
                    Icons.star,
                    color: Constants.gray_9,
                    size: 12,
                  ),
                  Icon(
                    Icons.star,
                    color: Constants.gray_9,
                    size: 12,
                  ),
                  Icon(
                    Icons.star,
                    color: Constants.gray_9,
                    size: 12,
                  ),
                ],
              )),
              PopupMenuButton(itemBuilder: (_) {
                return [
                  PopupMenuItem(child: Text('举报')),
                ];
              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.pd30),
            child: Column(
              children: [
                Text('评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容评论内容'),
                Row(
                  children: [
                    Expanded(
                      child: _buildContentTextWidget('2021-08-08'),
                    ),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.thumbsUp,
                          size: 12,
                        ),
                        label: Text(
                          '999+',
                          style: TextStyle(fontSize: 12),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.thumbsDown,
                          size: 12,
                        ),
                        label: Text('999+', style: TextStyle(fontSize: 12))),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.commentAlt,
                          size: 12,
                        ),
                        label: Text('999+', style: TextStyle(fontSize: 12))),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    color: Color(0xfff0f0f0),
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(text: '用户名:'),
                              TextSpan(text: '评论内容', style: TextStyle(color: Colors.black)),
                            ], style: TextStyle(color: Constants.gray_c, fontSize: 14)),
                          ),
                          Dimens.hGap6,
                          GestureDetector(
                            onTap: () {},
                            child: Text('查看全部67条回复', style: TextStyle(fontSize: 14, color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleTextWidget(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: Dimens.font_size_16),
    );
  }

  Widget _buildContentTextWidget(String content) {
    return Text(
      content,
      style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_14),
    );
  }

  Widget _buildCommentTypeButton(String title, bool isSelected) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        title,
        style: TextStyle(fontSize: Dimens.font_size_12),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
        backgroundColor: MaterialStateProperty.all(isSelected ? Colors.blueAccent : Constants.gray_c),
        minimumSize: MaterialStateProperty.all(Size(46, 30)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}
