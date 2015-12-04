//
//  MapViewController.h
//  iossbm
//
//  Created by lrw on 15/11/9.
//  Copyright (c) 2015年 liwenrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"

@protocol MapViewControllerDidSelectDelegate;
@interface MapViewController : UIViewController{
    MKMapView *_mapView;
    id<MapViewControllerDidSelectDelegate> delegate;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager* lm;
@property(nonatomic,assign)id<MapViewControllerDidSelectDelegate> delegate;

- (void)resetAnnitations:(NSArray *)data;

@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;

@end