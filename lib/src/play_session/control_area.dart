import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/game_risk.dart';
import 'package:game_template/src/game_internals/game_state.dart';
import 'package:game_template/src/game_internals/selected_symbol.dart';
import 'package:game_template/src/play_session/confirm_dialog.dart';
import 'package:game_template/src/play_session/game_card.dart';

/// 提示與操作區塊
class ControlArea extends StatelessWidget {
  final List<IconData> content;
  final List<SelectedItem> selectedItems;
  final int currentSelectedSymbolCount;
  final int step;
  final VoidCallback nextStep;
  const ControlArea({
    super.key,
    required this.content,
    required this.currentSelectedSymbolCount,
    required this.step,
    required this.selectedItems,
    required this.nextStep,
  });

  String _getDescription() {
    switch (step) {
      case 1:
        return '請選擇至少 1 個最多 3 個';
      case 2:
        return '請選擇 $currentSelectedSymbolCount 個';
      case 3:
        return '請組合出最大值的算式';
      default:
        return 'Something wrong...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          _getDescription(),
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(
          height: 25,
        ),
        (step == 1 || step == 2)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '內容物',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: content
                        .map(
                          (icon) => Icon(
                            icon,
                            size: 30.0,
                          ),
                        )
                        .toList(),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: selectedItems
                    .map(
                      (e) => Draggable(
                        feedback: Container(
                          width: 60,
                          height: 90,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.lightBlue,
                          ),
                        ),
                        childWhenDragging: Container(
                          width: 60,
                          height: 90,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blueGrey,
                          ),
                        ),
                        onDragStarted: () {
                          debugPrint('onDragStarted(), 開始拖動');
                        },
                        onDraggableCanceled:
                            (Velocity velocity, Offset offset) {
                          debugPrint('onDraggableCanceled(), 被放掉＋沒被接受');
                        },
                        onDragCompleted: () {
                          debugPrint('onDragCompleted(), 被放掉＋接受');
                        },
                        onDragEnd: (DraggableDetails details) {
                          debugPrint('onDragEnd(), 被放掉');
                        },
                        child: Container(
                          width: 60,
                          height: 90,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blueAccent,
                          ),
                          child: e.symbol != null
                              ? Icon(
                                  GameRisk.convertSymbolToIcon(
                                      e.symbol as MathSymbol),
                                  color: Colors.white,
                                  size: 40.0,
                                )
                              : Center(
                                  child: Text(
                                    GameRisk.isInteger(e.number as double)
                                        ? (e.number as double)
                                            .toInt()
                                            .toString()
                                        : e.number.toString(),
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    )
                    .toList(),
              ),
        // 確認視窗
        Container(
          margin: EdgeInsets.all(10),
          child: ElevatedButton(
            child: Text('確定'),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => ConfirmDialog(
                onConfirm: (() {
                  nextStep();
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}