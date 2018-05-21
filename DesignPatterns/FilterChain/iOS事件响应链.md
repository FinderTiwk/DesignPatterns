#  iOS中的责任链模式

## iOS中的事件
一个事件包括 (UITouches, UIEvent)
> UITouch:
一个touch一个手指

> UIEvent:
事件类型,时间点等

### 1. iOS事件类型
1. touches触摸事件(点击,缩放,拖动等)
2. remotion运动事件(陀螺仪,加速计等)
3. remote远程事件(如耳机上的按键,外接设备等)


### 2. UIKit内置6种手势识别器
- UITapGestureRecognizer：点击（单击、双击、三连击等）手势。
- UIPinchGestureRecognizer：缩放手势。
- UIPanGestureRecognizer：拖拽手势。
- UISwipeGestureRecognizer：滑动手势。
- UIRotationGestureRecognizer：旋转手势。
- UILongPressGestureRecognizer：长按手势。


## 事件传递响应机制

### 1. 事件传递
UIApplication–>UIWindow-->递归找到最适配的事件接收者(遍历视图子控件时,从后向前,因为后加上来的控件在最上面)

```ObjectiveC
/*
UIView不能接收触摸事件的三种情况：
不接受用户交互：userInteractionEnabled = NO;
隐藏：hidden = YES;
透明：alpha = 0.0~0.01
*/

//通过这两个方法来寻找能响应事件的控件
hitTest：withEvent：
pointInside: withEvent：
```

### 2. 事件响应
最适合的控制------>扔给父控制直到最上层控件 ---->  最终到UIApplication 如果处理不了的话事件丢弃
