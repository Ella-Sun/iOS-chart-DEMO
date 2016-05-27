//
//  LineChart1ViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "LineChart1ViewController.h"
#import "BarChartSample-Swift.h"

@interface LineChart1ViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (nonatomic, strong) ChartLimitLine *currentLimieLint;
@property (nonatomic, assign) BOOL isTouchLiminLine;
@end

@implementation LineChart1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Line Chart 1 Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
                     ];

    _chartView.delegate = self;
    
    _chartView.descriptionText = @""; // 右下角描述
    _chartView.noDataTextDescription = @"You need to provide data for the chart."; // 当图表为空的时候的提示语
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO; // 是否绘制网络背景
    _chartView.pinchZoomEnabled = YES; // yes的时候x 和 y轴均可缩放
    
    _chartView.backgroundColor= [UIColor whiteColor];
    
    //X轴上的描述
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:12.f];
    xAxis.labelTextColor = [UIColor blackColor];
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.drawAxisLineEnabled = NO;
    xAxis.labelPosition = ChartLimitLabelPositionLeftBottom;
    xAxis.spaceBetweenLabels = 1.0;
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:0 label:@"Upper Limit"];
    ll1.lineWidth = 2.0;
    ll1.limit = 130.0;
    ll1.lineColor = [UIColor redColor];
    ll1.lineDashLengths = @[@5.f, @5.f]; //ll1线的长度以及 间距
    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    self.currentLimieLint = ll1;
    
    // y 轴上的一些设置
    ChartYAxis *leftAxis = _chartView.leftAxis;
    /**<  警戒线  >**/
    [leftAxis removeAllLimitLines];
    /**<  警戒线  >**/
    [leftAxis addLimitLine:ll1];
//    [leftAxis addLimitLine:ll2];
    leftAxis.gridLineDashLengths = @[@5.f, @5.f]; // 平行于x 轴的虚线长度 和间隙
    /**<  非常重要 加警戒线  >**/
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.labelTextColor =[UIColor blackColor];
//    leftAxis.startAtZeroEnabled = NO;
//    leftAxis.drawGridLinesEnabled = NO;
    
    _chartView.rightAxis.enabled = NO;
    
    [_chartView.viewPortHandler setMaximumScaleY: 2.f];
    [_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:0.8] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    //右上角描述
    _chartView.legend.form = ChartLegendFormLine;
    
    _sliderX.value = 11.0;
    _sliderY.value = 2000000.0;
    [self slidersValueChanged:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateChartData
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    [self setDataCount:(_sliderX.value + 1) range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{

    NSArray *dataKnow = @[@12322086.49,
                          @12310776.49,
                          @12305500.49,
                          @12297578.49,
                          @12303887.49,
                          @12307186.49];
    NSMutableArray *newDatas = [NSMutableArray arrayWithArray:dataKnow];
    NSInteger newCount = newDatas.count;
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < newCount; i++)
    {
        [xVals addObject:[@(i) stringValue]]; // 一共有多少个点
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < newCount; i++) {
        double value = [newDatas[i] doubleValue]/1000.0;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:value xIndex:i]];
    }
//    for (int i = 0; i < count; i++)
//    {
//        double mult = (range + 1);
//        double val = (double) (arc4random_uniform(mult)) + 3; // 点的y值
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
//    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.highlightLineDashLengths = @[@15.f, @10.f]; // 点击后出现水平和竖直虚线长度和间隙长度
    set1.highlightLineWidth = .5; //点击后水平和竖直虚线宽度
    set1.highlightColor = [UIColor blackColor]; //点击后水平和竖直虚线颜色
    
//    set1.lineDashLengths = @[@5.f, @2.5f]; // 折线线段长度 和 间隙长度
    [set1 setColor:UIColor.blackColor]; // 折线的颜色
    [set1 setCircleColor:UIColor.whiteColor]; // 拐点点的颜色
    set1.lineWidth = 2.0; // 线宽
    set1.circleRadius = 3.0; // 拐点半径
    set1.drawCubicEnabled = YES;
    set1.drawCircleHoleEnabled = NO; // NO 为实心圆，yes 为空心圆
    set1.valueFont = [UIFont systemFontOfSize:9.f]; // 点上面的值得大小
    set1.fillAlpha = 65/255.0;
    set1.fillColor = kColorInBarViewWithIndex01;//UIColor.blackColor;
    /*
    NSArray *gradientColors = @[
                        (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                        (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                        ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 1.f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
     */
    set1.drawFilledEnabled = YES; // 画折线下面的彩色阴影
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _chartView.data = data;
    
    // 设置折线图样式
//    for (id<ILineChartDataSet> set in _chartView.data.dataSets)
//    {
//        set.drawCubicEnabled = YES;
//        set.drawValuesEnabled = NO;
//    }
    
    [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    [super handleOption:key forChartView:_chartView];
}

#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value + 1) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - 移动预警虚线的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.chartView];
    
    if((self.chartView.leftYAxisRenderer.yPoint.y - 8) < point.y && point.y < (self.chartView.leftYAxisRenderer.yPoint.y + 8)){
        
        self.isTouchLiminLine = YES;
        //移除手势
        [_chartView removeGestureRecognizer:_chartView._tapGestureRecognizer];
        [_chartView removeGestureRecognizer:_chartView._panGestureRecognizer];
    
    }else{
        
        self.isTouchLiminLine = NO;
        
        [_chartView addGestureRecognizer:_chartView._tapGestureRecognizer];
        [_chartView addGestureRecognizer:_chartView._panGestureRecognizer];
    }
    
}

static CGPoint position;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.chartView];
    
    if(self.isTouchLiminLine){
        //移除手势
        [_chartView removeGestureRecognizer:_chartView._tapGestureRecognizer];
        [_chartView removeGestureRecognizer:_chartView._panGestureRecognizer];
        
        // 反转坐标（将点对应的Y值转换为Y轴上对应的Y值）
        CGAffineTransform trans = self.chartView.xAxisRenderer.transformer.valueToPixelMatrix;
        //反转
        CGAffineTransform invert = CGAffineTransformInvert(trans);
        position = CGPointApplyAffineTransform(point,invert);
  
        //如果移动的点超出y轴上的最大最小值就直接返回
        if(position.y > self.chartView.leftAxis.customAxisMax || position.y < self.chartView.leftAxis.customAxisMin){
            return;
        }
        
        //移除之前的线
        [self.chartView.leftAxis removeLimitLine:self.currentLimieLint];

        // 添加新的线
        ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:0 label:@"Upper Limit"];
        ll1.lineWidth = 2.0;
        ll1.limit = position.y;
        ll1.lineColor = [UIColor redColor];
        ll1.lineDashLengths = @[@5.f, @5.f]; //ll1线的长度以及 间距
        ll1.labelPosition = ChartLimitLabelPositionRightTop;
        ll1.valueFont = [UIFont systemFontOfSize:10.0];
        self.currentLimieLint = ll1;
        
        // y 轴上的一些设置
        ChartYAxis *leftAxis = _chartView.leftAxis;
        [leftAxis addLimitLine:ll1];
        
        [_chartView setNeedsDisplay];
        
    }else{
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_chartView addGestureRecognizer:_chartView._tapGestureRecognizer];
    [_chartView addGestureRecognizer:_chartView._panGestureRecognizer];
}

@end
