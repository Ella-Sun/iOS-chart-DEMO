//
//  DemoBaseViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 13/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "DemoBaseViewController.h"

@interface DemoBaseViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *optionsTableView;

@end

@implementation DemoBaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    months = @[
        @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep",
        @"Oct", @"Nov", @"Dec"
        ];
    
    parties = @[
        @"Party A", @"Party B", @"Party C", @"Party D", @"Party E", @"Party F",
        @"Party G", @"Party H", @"Party I", @"Party J", @"Party K", @"Party L",
        @"Party M", @"Party N", @"Party O", @"Party P", @"Party Q", @"Party R",
        @"Party S", @"Party T", @"Party U", @"Party V", @"Party W", @"Party X",
        @"Party Y", @"Party Z"
    ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  子类复写该方法（当optional内的单元行被点击时，触发）
 *
 *  @param key 代表点击行的关键词
 */
- (void)optionTapped:(NSString *)key
{
    
}

#pragma mark - Actions
//增加动画类型以及界面显示的属性布尔值
- (IBAction)optionsButtonTapped:(id)sender
{
    if (_optionsTableView)
    {
        [_optionsTableView removeFromSuperview];
        self.optionsTableView = nil;
        return;
    }
    
    self.optionsTableView = [[UITableView alloc] init];
    _optionsTableView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.9f];
    _optionsTableView.delegate = self;
    _optionsTableView.dataSource = self;
    
    /**
     *  如果是从代码层面开始使用Autolayout,需要对使用的View的translatesAutoresizingMaskIntoConstraints的属性设置为NO.
     即可开始通过代码添加Constraint,否则View还是会按照以往的autoresizingMask进行计算.
     而在Interface Builder中勾选了Ues Autolayout,IB生成的控件的translatesAutoresizingMaskIntoConstraints属性都会被默认设置NO.
     */
    _optionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    //添加约束
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_optionsTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:40.f]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_optionsTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_optionsTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeBottom multiplier:1.f constant:5.f]];
    
    [self.view addSubview:_optionsTableView];
    
    [self.view addConstraints:constraints];
    
    [_optionsTableView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:_optionsTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.f constant:220.f]
                                        ]];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _optionsTableView)
    {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _optionsTableView)
    {
        return self.options.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _optionsTableView)
    {
        return 40.0;
    }
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _optionsTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.backgroundView = nil;
            cell.backgroundColor = UIColor.clearColor;
            cell.textLabel.textColor = UIColor.whiteColor;
        }
        
        cell.textLabel.text = self.options[indexPath.row][@"label"];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _optionsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (_optionsTableView)
        {   //tableView消失
            [_optionsTableView removeFromSuperview];
            self.optionsTableView = nil;
        }
        
        [self optionTapped:self.options[indexPath.row][@"key"]];
    }
}

#pragma mark - Stubs for chart view

- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = YES;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.descriptionText = @"";
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"iOS Charts\nby Daniel Cohen Gindi"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 19, 19)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

- (void)setupRadarChartView:(RadarChartView *)chartView
{
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"You need to provide data for the chart.";
}

/**
 *  创建折线图/柱状图
 *
 *  @param chartView 需要操作（赋予属性值）的折线图
 */
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;//可以拖拽
    [chartView setScaleEnabled:YES];//可以伸缩（放大、缩小）
    chartView.pinchZoomEnabled = NO;
    
    ChartYAxis *leftAxis = chartView.leftAxis;
    leftAxis.startAtZeroEnabled = NO;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;//x轴坐标相对位置
    
    chartView.rightAxis.enabled = NO;//右侧是否显示坐标
}

@end
