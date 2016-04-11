//
//  MultipleBarChartViewController.m
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

#import "MultipleBarChartViewController.h"
#import "BarChartSample-Swift.h"

@interface MultipleBarChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet BarChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@end

@implementation MultipleBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Multiple Bar Chart";
    
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
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @" ";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    /**<  显示虚线  >**/
    _chartView.drawHighlightArrowEnabled = YES;
    
    //气泡数值
//    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[UIColor colorWithWhite:180/255. alpha:1.0] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
    
    //每个柱子颜色注释
    ChartLegend *legend = _chartView.legend;
    legend.position = ChartLegendPositionRightOfChartInside;
    legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = UIBarPositionBottom;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
    /**
     *  设置这个属性 横线消失
     */
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.spaceTop = 0.25;
    
    
    _chartView.rightAxis.enabled = NO;
    
    _sliderX.value = 4.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
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
    NSArray * barTexts = @[@"净:",@"收:",@"支:"];
    NSMutableArray * barText1 = [NSMutableArray array];
    NSMutableArray * barText2 = [NSMutableArray array];
    NSMutableArray * barText3 = [NSMutableArray array];
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i + 1990) stringValue]];
    }
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    
    double mult = range * 1000.f;
    
    for (int i = 0; i < count; i++)
    {
        double val = -(double) (arc4random_uniform(mult) + 3.0);
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
        
        val = (double) (arc4random_uniform(mult) + 3.0);
        [yVals2 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
        
        val = (double) (arc4random_uniform(mult) + 3.0);
        [yVals3 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    BOOL isNav = YES;
    for (BarChartDataEntry *valEntry in yVals1) {
        if (valEntry.value < 0) {
            isNav = NO;
        }
        [barText1 addObject:barTexts[0]];
    }
    for (BarChartDataEntry *valEntry in yVals2) {
        if (valEntry.value < 0) {
            isNav = NO;
        }
        [barText2 addObject:barTexts[1]];
    }
    for (BarChartDataEntry *valEntry in yVals3) {
        if (valEntry.value < 0) {
            isNav = NO;
        }
        [barText3 addObject:barTexts[2]];
    }
    [marker.barDescription addObject:barText1];
    [marker.barDescription addObject:barText2];
    [marker.barDescription addObject:barText3];
    _chartView.marker = marker;
    _chartView.leftAxis.startAtZeroEnabled = isNav;
    
    //多组 每一组一个属性设置
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals1 label:@"净收入"];
    [set1 setColor:kColorInBarViewWithIndex01];
//    set1.drawValuesEnabled = NO;
    set1.barSpace = 0.35;
    set1.highlightLineWidth = 1.0;
    set1.highlightLineDashLengths = @[@15.0f,@12.0f];
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithYVals:yVals2 label:@"收 入"];
    [set2 setColor:kColorInBarViewWithIndex02];
//    set2.drawValuesEnabled = NO;
    set2.barSpace = 0.35;
    set2.highlightLineWidth = 1.0;
    set2.highlightLineDashLengths = @[@15.0f,@12.0f];
    BarChartDataSet *set3 = [[BarChartDataSet alloc] initWithYVals:yVals3 label:@"支 出"];
    [set3 setColor:kColorInBarViewWithIndex03];
//    set3.drawValuesEnabled = NO;
    set3.barSpace = 0.35;
    set3.highlightLineWidth = 1.0;
    set3.highlightLineDashLengths = @[@15.0f,@12.0f];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    [dataSets addObject:set3];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    //一组多个时 设置
    data.groupSpace = 0.8;
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    data.highlightEnabled = YES;
    [data setValueTextColor:UIColor.blackColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _chartView.data = data;
    [_chartView animateWithYAxisDuration:3.0];
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
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlightArrow"])
    {/**<  完成  >**/
        _chartView.drawHighlightArrowEnabled = !_chartView.isDrawHighlightArrowEnabled;
        
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
    {/**<  完成  >**/
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {/**<  完成  >**/
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
    NSLog(@"---chartView：%@\n",chartView);//frame = (0 47; 375 437);
    NSLog(@"---entry:%@\n",entry);//ChartDataEntry, xIndex: 9, value 20.0
    NSLog(@"---dataSetIndex:%ld\n",dataSetIndex);//当一组中有多个柱子时，显示柱子在组中的下标
    NSLog(@"---highlight:%@\n",highlight);//Highlight, xIndex: 9, dataSetIndex: 0, stackIndex (only stacked barentry): -1
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
