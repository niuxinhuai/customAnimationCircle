//
//  ViewController.m
//  MapView
//
//  Created by wanglixing on 16/5/3.
//  Copyright © 2016年 zhiyou. All rights reserved.
//

#import "ViewController.h"

@import CoreLocation;
@import MapKit;

@interface ZYAnnotation : /**UIView*/ NSObject <MKAnnotation>

//看到属性，一定要想到 setter，getter 和 全局变量。

//大头针在地图上的位置。
@property (nonatomic) CLLocationCoordinate2D coordinate;

//标题。
@property (nonatomic, copy) NSString* title;

//子标题。
@property (nonatomic, copy) NSString* subtitle;

@end

@implementation ZYAnnotation


@end



@interface ViewController () <MKMapViewDelegate> {
    CLLocationManager* _locationManager;
    
    MKMapView* _mapView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestAlwaysAuthorization];
    

    //MapKit，iOS 中展示地图的框架。
    
    //MKMapView 继承 UIView，是 iOS 中的地图。
    //数据使用的是高德地图的数据。
    //MKMapView 只是地图，只能用来展示数据，不包含导航，搜索等功能。
    
    //使用 MapKit 还可以操纵系统的 Maps 软件，实现导航功能。
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    _mapView.delegate = self;
    
    //MKMapTypeStandard，标准，2D。默认的，最常用。
    //MKMapTypeSatellite，卫星图，3D。
    //MKMapTypeHybrid，混合类型，3D ＋ 街道名称。
    _mapView.mapType = MKMapTypeHybridFlyover;
    
    //展示用户的位置。
    _mapView.showsUserLocation = YES;
    
    //设置标题和副标题。
    _mapView.userLocation.title = @"我的位置";
    _mapView.userLocation.subtitle = @"河南商报";
    
    [self.view addSubview:_mapView];
    
    //Map
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(20, 20, 100, 44);
    
    button.backgroundColor = [UIColor cyanColor];
    
    [button setTitle:@"添加标注" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(200, 20, 100, 44);
    
    button.backgroundColor = [UIColor cyanColor];
    
    [button setTitle:@"系统地图导航" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

#pragma mark - MKMapViewDelegate

//定位用户位置成功后调用。
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //设置地图的中心点。
//    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    
    //设置地图的展示区域。
    
    
    //比例尺。
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    //centerCoordinate，中心点的经纬度。
    //span，比例尺。
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    
    [mapView setRegion:region animated:YES];
}

//自定义大头针标注。
- (MKAnnotationView* )mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //这个协议方法，系统也会调用。当展示自己位置的时候，系统也会调用这个方法配置自己位置的蓝色圆点的大头针。
    //一般来说我们只对我们自定义的标注进行处理。
    

    //isKindOfClass
    //isMemberOfClass
    if ([annotation isKindOfClass:[ZYAnnotation class]]) {
        //如果是自定义的标注，在进行自定义处理。
        
        //MKAnnotationView 和 UITableViewCell 一样，也是会重用的。
        
        //获得一个可重用的 cell。
        
        MKAnnotationView* cell = [mapView dequeueReusableAnnotationViewWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cell"];
            
            //设置自定义的图片。
            cell.image = [UIImage imageNamed:@"landmark.png"];
            
            //展示详细信息。
            cell.canShowCallout = YES;
            
            
            //添加一个左侧的自定义 view。
            //rightCalloutAccessoryView
            cell.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head.png"]];
            
            cell.leftCalloutAccessoryView.frame = CGRectMake(0, 0, 40, 40);
            
            
        }
        
        //设置展示的信息。
        cell.annotation = annotation;
        
        return cell;
    }else {
        //使用系统默认的效果。
        return nil;
    }
}

//点击某个大头针。
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"---------------");
}

#pragma mark - action

- (void)buttonClick:(id)sender {
    //添加标注。
    //id <MKAnnotation>，任意实现了 MKAnnotation 协议的对象。
    //系统类中没有实现 MKAnnotation 协议的。需要我们自定义个类实现。
    
//    ZYAnnotation* annotation = [[ZYAnnotation alloc] init];
//    
//    annotation.coordinate = CLLocationCoordinate2DMake(w);
//    
//    annotation.title = @"老南岗";
//    annotation.subtitle = @"吃饭";
//
//    [_mapView addAnnotation:annotation];
//    
//    
//    annotation = [[ZYAnnotation alloc] init];
//    
//    annotation.coordinate = CLLocationCoordinate2DMake(34.733041, 113.743276);
//    
//    annotation.title = @"远大理想城";
//    annotation.subtitle = @"休息";
//    
//    [_mapView addAnnotation:annotation];
    
    //
    NSString* json = @"[{\"latitude\" : 34.733041,\"longitude\" : 113.743276,\"title\" : \"远大理想城\",\"subtitle\":\"我们的宿舍\"}, {\"latitude\" : 34.732477,\"longitude\" : 113.760667,\"title\" : \"老南岗\",\"subtitle\":\"我们的食堂\"}]";
    
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //1 "1"
    for (NSDictionary* dic in array) {
        ZYAnnotation* annotation = [[ZYAnnotation alloc] init];
        
        annotation.coordinate = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
        
        annotation.title = dic[@"title"];
        annotation.subtitle = dic[@"subtitle"];
        
        [_mapView addAnnotation:annotation];
    }
}

- (void)buttonClick1:(id)sender {
    //操纵系统的 Maps 软件，需要使用 MKMapItem 类。

    //MKMapItem 地图上的一个点。
    
    //在系统的地图上添加一个标注。
//    - (BOOL)openInMapsWithLaunchOptions:(nullable NSDictionary<NSString *, id> *)launchOptions __TVOS_PROHIBITED;
    
    
    //在系统的地图上实现导航功能。
//    + (BOOL)openMapsWithItems:(NSArray<MKMapItem *> *)mapItems launchOptions:(nullable NSDictionary<NSString *, id> *)launchOptions __TVOS_PROHIBITED;
    
    
    //起点。
    MKMapItem* start = [MKMapItem mapItemForCurrentLocation];
    
    //终点。
    MKPlacemark* placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.733041, 113.743276) addressDictionary:nil];
    
    MKMapItem* end = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    NSArray* points = @[start, end];
    
    //导航，必须设置路线模式。
    [MKMapItem openMapsWithItems:points launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking}];
    
}

@end
