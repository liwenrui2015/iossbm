//
//  MapViewController.m
//  iossbm
//
//  Created by lrw on 15/11/9.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//


#import "MapViewController.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#define span1 40000
#define SPANLA 0.01
#define SPANLO 0.009
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

{
    NSMutableArray *_annotationList;
    
    CalloutMapAnnotation *_calloutAnnotation;
    CalloutMapAnnotation *_previousdAnnotation;
    
}
-(void)setAnnotionsWithList:(NSArray *)list;

@end
@implementation MapViewController
@synthesize mapView=_mapView;
@synthesize delegate;

- (void)dealloc
{
    [_mapView release];
    [_annotationList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if([CLLocationManager locationServicesEnabled])
    {
        self.lm=[[CLLocationManager alloc]init];
        self.lm.delegate=self;
        self.lm.distanceFilter=kCLDistanceFilterNone;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
        {
            //设置定位权限 仅ios8有意义
            [self.lm requestWhenInUseAuthorization];// 前台定位
            
            //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
        }
        
    }else
    {
        NSLog(@"定位不可用");
    }
    _mapView.delegate=self;
    _annotationList = [NSMutableArray array];
    [_annotationList retain];
    
    [super viewDidLoad];
}


- (IBAction)selfPosation:(id)sender
{
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"23.281843",@"latitude",@"113.102193",@"longitude",@"李文瑞1",@"name",nil];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"23.290144",@"latitude",@"113.146696‎",@"longitude",@"李文瑞2",@"name",nil];
    
    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"23.248076",@"latitude",@"113.164162‎",@"longitude",@"李文瑞3",@"name",nil];
    
    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:@"23.425622",@"latitude",@"113.299605",@"longitude",@"李文瑞4",@"name",nil];
    NSArray *array = [NSArray arrayWithObjects:dic1,dic2,dic3,dic4, nil];
    [self resetAnnitations:array];

    NSLog(@"我的位置是：%f,%f",self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude);
    if (self.mapView.userTrackingMode == MKUserTrackingModeFollow) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    }else {
        MKCoordinateSpan span =  MKCoordinateSpanMake(SPANLA, SPANLO);
        MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span);
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        });
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}
-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list)
    {
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span1 ,span1 );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        annotation.title=[dic objectForKey:@"name"];
        [_mapView  addAnnotation:annotation];
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]])//点击的是自定义的点处理事件
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;//点在相同的点上不做处理
        }
        if (_calloutAnnotation)//先移除上一个便签
        {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        //添加回来
        _calloutAnnotation = [[[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude] autorelease];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
    }
    else{
        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        }
    }
    NSLog(@"======点击");
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        NSLog(@"%f",((CalloutMapAnnotation*)annotation).latitude);
        
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            [annotationView.contentView addSubview:cell];
//            cell.title.text=((CalloutMapAnnotation*)annotation).title;
            cell.title.text=@"sdfa";
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
        
        
        return annotationView;
    }
    return nil;
}
- (void)resetAnnitations:(NSArray *)data
{
    
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}
@end
