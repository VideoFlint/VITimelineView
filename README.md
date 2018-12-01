# VITimelineView 

VITimelineView can represent any time base things. Made with fully customizable & extendable.

![](https://s1.ax1x.com/2018/12/01/FnETDf.jpg)

## Usage

**Simple demo**

Represent video frame's timeline using AVAsset

```
AVAsset *asset1 = ...;
AVAsset *asset2 = ...;

CGFloat widthPerSecond = 40;
CGSize imageSize = CGSizeMake(30, 45);

VITimelineView *timelineView = [VITimelineView timelineViewWithAssets:@[asset1, asset2] imageSize:imageSize widthPerSecond:widthPerSecond];
[self.view addSubview:timelineView];
```

**Customize**

1. Customize TimelineView see VITimelineView.h
2. Customize single source's control view, see VIRangeView.h
3. Customize source's content view, you can subclass VIRangeContentView, then add to VIRangeView.

```
VIRangeView *rangeView = ...;
rangeView.contentView = <Any Content View>;
```

VIVideoRangeContentView is a subclass of VIRangeContentView.

## LICENSE

Under MIT
