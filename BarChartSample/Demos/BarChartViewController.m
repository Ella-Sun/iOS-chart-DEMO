//
//  BarChartViewController.m
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

#import "BarChartViewController.h"
#import "BarChartSample-Swift.h"

@interface BarChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet BarChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@end

@implementation BarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Bar Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleHighlightArrow", @"label": @"Toggle Brokenline"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    [self setupBarLineChartView:_chartView];
    
    _chartView.delegate = self;
    
    /**<  最大可见绘制值的数目  >**/
    /**<  是否显示阴影  >**/
    _chartView.drawBarShadowEnabled = NO;
    
    /**<  柱状图的详细数据显示位置  >**/
//    _chartView.drawValueAboveBarEnabled = NO;
    
    _chartView.maxVisibleValueCount = 60;
    
    /**<  显示虚线  >**/
    _chartView.drawHighlightArrowEnabled = YES;
    
    /**<  只能单独放大一个方向的坐标  >**/
//    _chartView.pinchZoomEnabled = NO;
    
    /**<  启用自动缩放的标志  >**/
    _chartView.autoScaleMinMaxEnabled = YES;
    
    /**<  X轴坐标  >**/
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    /**<  是否显示竖直的线  >**/
    xAxis.drawGridLinesEnabled = NO;
    
    xAxis.drawAxisLineEnabled = NO;
    xAxis.gridAntialiasEnabled = NO;
    xAxis.spaceBetweenLabels = 2.0;
    
    /**<  左侧Y轴坐标  >**/
    ChartYAxis *leftAxis = _chartView.leftAxis;
//    leftAxis.startAtZeroEnabled = YES;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
//    leftAxis.valueFormatter.negativeSuffix = @" $";
//    leftAxis.valueFormatter.positiveSuffix = @" $";
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.enabled = YES;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
//    rightAxis.labelCount = 8;
//    rightAxis.valueFormatter = leftAxis.valueFormatter;
//    rightAxis.spaceTop = 0.15;
    
    /**<  显示数据的气泡  >**/
//    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets:UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
    
    /**<  图例  >**/
    _chartView.legend.position = ChartLegendPositionRightOfChartInside;
    _chartView.legend.form = ChartLegendFormSquare;
    _chartView.legend.formSize = 9.0;
    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _chartView.legend.xEntrySpace = 4.0;
    
    /**<  默认柱子个数以及创建数值  >**/
    _sliderX.value = 11.0;
    _sliderY.value = 50.0;
    [self slidersValueChanged:nil];
}

/**
 *  传入柱状图数据
 *
 *  @param count 柱子个数
 *  @param range 数字变化范围
 */
- (void)setDataCount:(int)count range:(double)range
{
    /**<  显示数据的气泡  >**/
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets:UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
    
    NSArray * barTexts = @[@"收",@"支"];
    NSMutableArray * barText1 = [NSMutableArray array];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    count = 1;
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:months[i % 12]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult));
        if (i%3 == 2) {
            val = -val*100;
        } else {
            val *= 800;
        }
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    BOOL isNav = YES;
    for (BarChartDataEntry *valEntry in yVals) {
        if (valEntry.value < 0) {
            isNav = NO;
            [barText1 addObject:barTexts[1]];
        } else {
            [barText1 addObject:barTexts[0]];
        }
    }
    [marker.barDescription addObject:barText1];
    _chartView.marker = marker;
    _chartView.leftAxis.startAtZeroEnabled = isNav;
    
    //TODO: 改变 图例 的说明(label)
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35;
    set1.highlightLineWidth = 1.5;
    set1.highlightLineDashLengths = @[@15.0f,@12.0f];
    /**<  是否显示柱状图的详细数据  >**/
//    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    data.highlightEnabled = YES;
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _chartView.data = data;
    
    [_chartView animateWithYAxisDuration:1.5];
}

/**
 *  选项实时改变
 *
 *  @param key 点击项
 */
- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {/**<  完成  >**/
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {/**<  完成  >**/
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlightArrow"])
    {/**<  完成  >**/
        _chartView.drawHighlightArrowEnabled = !_chartView.isDrawHighlightArrowEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {/**<  完成  >**/
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
//        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {/**<  完成  >**/
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value + 1) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self setDataCount:(_sliderX.value + 1) range:_sliderY.value];
}

#pragma mark - ChartViewDelegate

/**
 *  单击柱子
 *
 *  @param chartView    所点击的图表视图
 *  @param entry        未知
 *  @param dataSetIndex 点击的标记
 *  @param highlight    未知
 */
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"---chartView：%@\n",chartView);//frame = (0 47; 375 437);
    NSLog(@"---entry:%@\n",entry);//ChartDataEntry, xIndex: 9, value -20.0
    NSLog(@"---dataSetIndex:%ld\n",dataSetIndex);//当一组中有多个柱子时，显示柱子在组中的下标
    NSLog(@"---highlight:%@\n",highlight);//Highlight, xIndex: 9, dataSetIndex: 0, stackIndex (only stacked barentry): -1
}

/**
 *  连续两次点击柱子，第二次点击时
 *
 *  @param chartView 所点击的图表
 */
- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
