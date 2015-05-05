#import "PAPieChartViewController.h"

@interface PAPieChartViewController () <ChartViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PieChartView *chartView;
@property (weak, nonatomic) IBOutlet ScatterChartView *scatteredChartView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@end

@implementation PAPieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getTargetsByUserName:[PAUserDefaults sharedInstance].getUsername];
    self.title = @"Pie Chart";
    
    //Pie Chart View
    [self initializePeiChartView];
    
    //Bar Chart View
    [self initializeBarChartView];
    
    //Scatterd Cahrt View
    [self initializeScatteredChartView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self getChartDataFromServer];
}

- (void)viewDidLayoutSubviews {
    self.mainScrollView.contentSize = CGSizeMake(320, 1200);
}

- (void)initializePeiChartView
{
    _chartView.delegate = self;
    _chartView.usePercentValuesEnabled = YES;
    _chartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _chartView.holeRadiusPercent = 0.58f;
    _chartView.transparentCircleRadiusPercent = 0.61f;
    _chartView.drawSliceTextEnabled = YES;
    _chartView.rotationAngle = 0.f;
    _chartView.rotationEnabled = YES;
    _chartView.descriptionText = @"";
    _chartView.legend.enabled = NO;
    [_chartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseInBounce];
    _chartView.defaultTouchEventsEnabled = YES;
    
}


- (void)initializeBarChartView
{
    _barChartView.delegate = self;
    _barChartView.descriptionText = @"";
    _barChartView.noDataTextDescription = @"You need to provide data for the chart.";
    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = YES;
    _barChartView.maxVisibleValueCount = 60;
    _barChartView.pinchZoomEnabled = NO;
    _barChartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 2.f;
    
    ChartYAxis *leftAxis = _barChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
    leftAxis.valueFormatter.negativeSuffix = @" $";
    leftAxis.valueFormatter.positiveSuffix = @" $";
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15f;
    
    ChartYAxis *rightAxis = _barChartView.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15f;
    
    _barChartView.legend.position = ChartLegendPositionBelowChartLeft;
    _barChartView.legend.form = ChartLegendFormSquare;
    _barChartView.legend.formSize = 9.f;
    _barChartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _barChartView.legend.xEntrySpace = 4.f;
    _barChartView.defaultTouchEventsEnabled = YES;
}

- (void)initializeScatteredChartView
{
    _scatteredChartView.delegate = self;
    
    _scatteredChartView.descriptionText = @"";
    _scatteredChartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _scatteredChartView.drawGridBackgroundEnabled = NO;
    _scatteredChartView.highlightEnabled = YES;
    _scatteredChartView.dragEnabled = YES;
    [_scatteredChartView setScaleEnabled:YES];
    _scatteredChartView.maxVisibleValueCount = 200;
    _scatteredChartView.pinchZoomEnabled = YES;
    
    ChartLegend *l = _scatteredChartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    
    ChartYAxis *yl = _scatteredChartView.leftAxis;
    yl.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    
    _scatteredChartView.rightAxis.enabled = NO;
    
    ChartXAxis *xl = _scatteredChartView.xAxis;
    xl.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    xl.drawGridLinesEnabled = NO;
    _scatteredChartView.defaultTouchEventsEnabled = YES;
    
}


- (void)getChartDataFromServer
{
	NSMutableDictionary *resultingDictionary = get data from server to populate chart;
 }
               completionBlock:^
     {
         if ([resultingDictionary[STATUS] isEqualToString:SUCCESS])
         {
             NSDictionary *dataDictionary = resultingDictionary[DATA];

             //Pei Chart
             [self setGlucoseChartData:dataDictionary];
             
             //Scattered Chart
             [self setDataForScatteredChart:5 range:100.f];
             
             //Bar Chart
             [self setDataForBarChart:3 range:45.f];
             
             NSLog(@"Chart Loaded...");
         }
         
     }];
}

//Pie Chart
- (void)setGlucoseChartData : (NSDictionary *)dataDictionary
{
    
    NSMutableArray *yAxisValuesForChart = [[NSMutableArray alloc] init];
    NSMutableArray *xAxisValuesForChart = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    
if ([dataDictionary[@"inTarget"] integerValue] != 0)
    {
        [yAxisValuesForChart addObject:[[BarChartDataEntry alloc] initWithValue:[dataDictionary[@"inTarget"] integerValue] xIndex:1]];
        [xAxisValuesForChart addObject:pieChartValues[0]];
        [colors addObject:[UIColor greenColor]];
    }
    
    if ([dataDictionary[@"under"] integerValue] != 0)
    {
        [yAxisValuesForChart addObject:[[BarChartDataEntry alloc] initWithValue:[dataDictionary[@"under"] integerValue] xIndex:0]];
        [xAxisValuesForChart addObject:pieChartValues[1]];
        [colors addObject:[UIColor yellowColor]];
    }
    
    if ([dataDictionary[@"over"] integerValue] != 0)
    {
        [yAxisValuesForChart addObject:[[BarChartDataEntry alloc] initWithValue:[dataDictionary[@"over"] integerValue] xIndex:2]];
        [xAxisValuesForChart addObject:pieChartValues[2]];
        [colors addObject:[UIColor redColor]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yAxisValuesForChart label:@"Weekly Summary"];
    dataSet.sliceSpace = 3.f;
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xAxisValuesForChart dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
    
}

//Scattered Chart
- (void)setDataForScatteredChart:(int)count range:(float)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
        float val = (float) (arc4random_uniform(range)) + 3;
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    ScatterChartDataSet *set1 = [[ScatterChartDataSet alloc] initWithYVals:yVals1 label:@""];
    set1.scatterShape = ScatterShapeSquare;
    [set1 setColor:ChartColorTemplates.colorful[0]];
    
    set1.scatterShapeSize = 8.f;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    ScatterChartData *data = [[ScatterChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    
    _scatteredChartView.data = data;
}

//Bar Chart
- (void)setDataForBarChart:(int)count range:(float)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:months[i % 12]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        float mult = (range + 1);
        float val = (float) (arc4random_uniform(mult));
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35f;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _barChartView.data = data;
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

