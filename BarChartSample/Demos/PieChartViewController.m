//
//  PieChartViewController.m
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
/**
 导入Charts 框架步骤：1， 将Charts文件夹复制到新项目目录下，将Charts。xcodeproj脱到新项目中
 2， 将新项目中 BuildSettings 中把 defines module 设为 YES 把 product module 设置为项目工程的名字。
 3， 生成一个。swift文件 并确定桥接
 4， 在项目的 general -》Embedded binaries中添加Charts。frameWorks包
 5， 在需要用到的 。m文件中导入 imoprt“项目名-Swift。h”
 6,  imoprt“项目名-Swift。h” 点进去后再适当的位置添加 @import Charts
 */

#import "PieChartViewController.h"
#import "BarChartSample-Swift.h"

#define K_EPSINON        (1e-127)
#define IS_ZERO_FLOAT(X) (X < K_EPSINON && X > -K_EPSINON)
@interface PieChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

// 画中间圆以及中间描述
@property (nonatomic, strong) PieChartRenderer *renderer;
@property (nonatomic, assign) CGFloat mAbsoluteTheta;
@property (nonatomic, assign) CGFloat mRelativeTheta;
@property (nonatomic, assign) CGFloat angel;

@end

@implementation PieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Pie Bar Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Y-Values"},
                     @{@"key": @"toggleXValues", @"label": @"Toggle X-Values"},
                     @{@"key": @"togglePercent", @"label": @"Toggle Percent"},
                     @{@"key": @"toggleHole", @"label": @"Toggle Hole"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"spin", @"label": @"Spin"},
                     @{@"key": @"drawCenter", @"label": @"Draw CenterText"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
                     ];
    
    [self setupPieChartView:_chartView]; // 调用父类方法初始化_chartView
    
//    [_chartView.centerPieBtn addTarget:self action:@selector(centerPieBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _chartView.delegate = self;
    
    _sliderX.value = 3.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
    
    // 饼状图旋转动画
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerPieBtnDidClicked) name:@"centerBtnDidClicked" object:nil];
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

/**  
 *  点击中间按钮，重绘饼状图
 */
- (void)centerPieBtnDidClicked{
    
    // 重新传值
    // [self setDataCount:<#(int)#> range:<#(double)#>]
    
    // 重绘动画
    [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4];
    
}

/**
 *  根据传进来的值，确定饼状图的块数以及颜色
 */
- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) xIndex:i]]; // 每块所占百分比(随机)
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:parties[i % parties.count]]; // 每块下面描述（从parties数组中取描述元素）
    }
    
//    for (int i = 0; i < 4; i++)
//    {
//        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:1 xIndex:i]]; // 每块所占百分比(随机)
//    }
//    
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++)
//    {
//        [xVals addObject:parties[i % parties.count]]; // 每块下面描述（从parties数组中取描述元素）
//    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Election Results"];
    dataSet.sliceSpace = 2.0; // 饼状图中块与块之间的距离
    
    // add a lot of colors
    // 添加许多颜色，然后根据块数自动在数组中从头开始取出
    //TODO: 添加颜色
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter]; // 设置饼状图中值的状态
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

/**
 *  重写父类方法  点击option后点击弹出的tableViewCell
 */
- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleXValues"])
    {
        _chartView.drawSliceTextEnabled = !_chartView.isDrawSliceTextEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"togglePercent"])
    {
        _chartView.usePercentValuesEnabled = !_chartView.isUsePercentValuesEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleHole"])
    {
        _chartView.drawHoleEnabled = !_chartView.isDrawHoleEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"drawCenter"])
    {
        _chartView.drawCenterTextEnabled = !_chartView.isDrawCenterTextEnabled;
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4];
        return;
    }
    
    if ([key isEqualToString:@"spin"])
    {
        //旋转
        [_chartView spinWithDuration:2.0 fromAngle:_chartView.rotationAngle toAngle:_chartView.rotationAngle + 90.f];
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
    double angles = ([_chartView.absoluteAngles[entry.xIndex] longLongValue])/2;
    
    if(entry.xIndex > 0)
    {
        angles = angles-([_chartView.absoluteAngles[entry.xIndex-1] longLongValue])/2;
        angles = angles + [_chartView.absoluteAngles[entry.xIndex-1] longLongValue];
    }
//    angles += _chartView.rotationAngle;
//    angles = (int)angles % 360;
    NSLog(@"-----%lf",angles);
    
    if(270.0 <= angles && angles <= 360.0){
        
        angles = 90 + 360 - angles;
    }else{
        
        angles = 90 - angles;
    }
//    angles = 90 - angles;
    [_chartView spinWithDuration:1.0 fromAngle:_chartView.rotationAngle toAngle:angles];
    NSLog(@"=======%lf =======%lf",angles,_chartView.rotationAngle);
    
//    NSLog(@"********chartView=%@***********,********entry=%@***********,********dataSetIndex=%zd********,**********highlight=%@************",chartView,entry,dataSetIndex,highlight);
    
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
