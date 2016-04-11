//
//  LineChart2ViewController.m
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

#import "LineChart2ViewController.h"
#import "BarChartSample-Swift.h"

@interface LineChart2ViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@end

@implementation LineChart2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Line Chart 2 Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = YES;
    
    _chartView.backgroundColor = [UIColor whiteColor];
    
    /**<  图例  >**/
//    _chartView.legend.form = ChartLegendFormLine;
//    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//    _chartView.legend.textColor = UIColor.blackColor;
//    _chartView.legend.position = ChartLegendPositionRightOfChartInside;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:12.f];
    xAxis.labelTextColor = UIColor.blackColor;
//    xAxis.drawGridLinesEnabled = YES; /**<  是否显示横线  >**/
//    xAxis.drawAxisLineEnabled = NO;/**<  是否显示X横坐标线  >**/
    xAxis.labelPosition = XAxisLabelPositionBottom;/**<  X轴显示位置  >**/
    xAxis.spaceBetweenLabels = 1.0;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
//    leftAxis.labelTextColor =[UIColor blackColor];
//    leftAxis.customAxisMax = 200.0;
//    leftAxis.startAtZeroEnabled = NO;
//    leftAxis.drawGridLinesEnabled = NO;
    
    _chartView.rightAxis.enabled = NO;
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.labelTextColor = UIColor.redColor;
//    rightAxis.customAxisMin = -200.0;
//    rightAxis.minWidth = 20;
//    rightAxis.drawGridLinesEnabled = NO;
    
    _sliderX.value = 10.0;
    _sliderY.value = 1038080.0;
    [self slidersValueChanged:nil];
    
//    [_chartView animateWithXAxisDuration:2.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range
{
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:0.8] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    NSArray * barTexts = @[@"收:",@"支:"];
    NSMutableArray * barText1 = [NSMutableArray array];
    NSMutableArray * barText2 = [NSMutableArray array];
    
    _chartView.legend.form = ChartLegendFormLine;
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 5;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    for (int i = 0; i < count; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 45;
        [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    [barText1 addObject:barTexts[0]];
    [barText2 addObject:barTexts[1]];
    
    [marker.barDescription addObject:barText1];
    [marker.barDescription addObject:barText2];
    _chartView.marker = marker;
//    _chartView.leftAxis.startAtZeroEnabled = isNav;
    
    /**<  设置点的属性  >**/
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"收入"];
    set1.axisDependency = AxisDependencyLeft;/**<  Y轴坐标依赖 左侧  >**/
    [set1 setColor:UIColor.blackColor];/**<  线的颜色  >**/
    [set1 setCircleColor:UIColor.whiteColor];/**<  点的颜色  >**/
    set1.lineWidth = 2.0;/**<  折线宽  >**/
    set1.circleRadius = 3.0;/**<  圆点大小  >**/
    /**<  是否显示数值  >**/
//    set1.drawValuesEnabled = NO;
    /**<  折线是曲面还是直线(YES为曲面)  >**/
//    set1.drawCubicEnabled = YES;
    /**<  下方是否填充颜色  >**/
    set1.drawFilledEnabled = YES;
    /**<  填充颜色的透明度  >**/
    set1.fillAlpha = 65/255.0;
    /**<  填充的颜色  >**/
    set1.fillColor = kColorInBarViewWithIndex01;
    /**<  移动虚线属性设置  >**/
    set1.highlightLineWidth = .5;
    set1.highlightLineDashLengths = @[@15.0,@10.0];
    set1.highlightColor = [UIColor blackColor];
    set1.drawCircleHoleEnabled = NO;
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:yVals2 label:@"支出"];
    set2.axisDependency = AxisDependencyLeft;
    [set2 setColor:UIColor.blackColor];
    [set2 setCircleColor:UIColor.whiteColor];
    set2.lineWidth = 2.0;
    set2.circleRadius = 3.0;
//    set2.drawValuesEnabled = NO;
//    set2.drawCubicEnabled = YES;
    
    set2.drawFilledEnabled = YES;
    set2.fillAlpha = 65/255.0;
    set2.fillColor = kColorInBarViewWithIndex03;//UIColor.redColor;
    
    /**<  移动虚线  >**/
    set2.highlightLineWidth = .5;
    set2.highlightLineDashLengths = @[@15.0,@10.0];
    set2.highlightColor = [UIColor blackColor];
    set2.drawCircleHoleEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _chartView.data = data;
    [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (id<IChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
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
    {
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

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
