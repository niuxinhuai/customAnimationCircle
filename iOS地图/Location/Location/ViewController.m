//
//  ViewController.m
//  Location
//
//  Created by wanglixing on 16/5/3.
//  Copyright © 2016年 zhiyou. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager* _locationManager;
    
    CLGeocoder* _geocoder;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定位，获取用户的所在的经纬度信息。
    
    //CoreLocation，iOS 中负责获取位置信息的框架。
    //还提供了 地址信息和经纬度转换的功能。
    //CLGeocoder，地理编码和反编码。
    
    //从 iOS8 开始，要想获得用户的位置信息，需要先获得用户的授权。
    
    //1.要在 info.plist 中进行配置。
    //a.NSLocationAlwaysUsageDescription，允许程序始终收集你的位置信息。前台＋后台。
    //b.NSLocationWhenInUseUsageDescription，只有程序在前台的时候才能收集你的位置信息。前台。
    
    
    /**
    _locationManager = [[CLLocationManager alloc] init];
    
    //2.请求用户授权使用定位功能。
    
    //    [_locationManager requestWhenInUseAuthorization];
    
    //    [_locationManager requestAlwaysAuthorization];
    
    //使用 delegate 方法获取所有的数据。
    _locationManager.delegate = self;
    
    //设置定位条件。
    
    //用户移动多少米后才更新一次位置信息。
    //默认是 None，每隔一段时间就获取一次用户的位置信息。
    //    _locationManager.distanceFilter = 100;
    
    //定位的精度，误差范围。
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //更新用户的位置信息。
    [_locationManager startUpdatingLocation];
    
    
    //iOS 中的定位功能，只能使用系统的提供的服务。
    //系统定位分三种方式，GPS，WIFI，基站，具体使用哪一种是由系统根据当前的环境决定的，我们不能控制。
    
    //获取用户的朝向信息，面朝哪个方向。
    //也是通过协议方法获得具体的数值。
    //只能真机测试，模拟器测试不了。
    [_locationManager startUpdatingHeading];
    
    
    //获得地图上的经纬度。
    //http://api.map.baidu.com/lbsapi/getpoint/index.html
    
    
    _geocoder = [[CLGeocoder alloc] init];
    
    
    //地理编码，通过给定的地址信息获得对应的经纬度坐标。
    //    [_geocoder geocodeAddressString:@"河南商报" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    //        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            NSLog(@"%f+++%f", obj.location.coordinate.latitude, obj.location.coordinate.longitude);
    //        }];
    //    }];
    
    //地理反编码，通过给定的经纬度，获取对应的建筑物位置信息。
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:34.734879 longitude:113.758865];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"%@", obj.addressDictionary);
        }];
    }];
    
    
    //火星坐标系统，国家处于安全考虑，所有软件获得的经纬度信息都是加偏修改后的经纬度信息。
    //地图展示的时候，要对经纬度进行还原展示。
    
    
    //要想正确的展示位置信息，坐标系统一定要保持一致。
     */
    
    
    _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    //定位服务的授权状态。
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            //没有授权。
        {
            //授权。
            [_locationManager requestAlwaysAuthorization];
            
            //启动定位，授权还没有完成。
//            [_locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusRestricted:
            //定位服务不可用。
        {
            //一般是硬件问题导致的。
        }
            break;
        case kCLAuthorizationStatusDenied:
            //拒绝授权。无法再次申请授权，需要用户手动去设置中进行修改。
        {
            //提示用户自己修改。
        }
            break;
//        case kCLAuthorizationStatusAuthorizedAlways:
//            //已经授予一直使用的权限。
//        case kCLAuthorizationStatusAuthorizedWhenInUse:
//            //已经授予在程序使用的时候收集的权限。
//        {
//            [_locationManager startUpdatingLocation];
//        }
//            break;
            
        default:
        {
            //为了兼容 iOS7，不要 case 成功的状态，直接在 default 中排除错误状态，进行定位。
            
            //只要不是失败状态，都可以去定位。
            [_locationManager startUpdatingLocation];
        }
            break;
    }
}

#pragma mark - CLLocationManagerDelegate

//更新授权状态后调用。
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status > kCLAuthorizationStatusDenied) {
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

//定位成功后，调用这个方法，获取位置信息。
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //locations 存储了一组用户的位置信息。通常我们只取最后一个。
    
    //CLLocation 封装了用户的位置信息。
    
    CLLocation* location = [locations lastObject];
    
    //为 double 起个别名 CLLocationDistance。
    //typedef double CLLocationDistance;
    
    
    //用户的海拔高度。
    CLLocationDistance altitude = location.altitude;
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //维度。
    CLLocationDegrees latitude = coordinate.latitude;
    
    //经度。
    CLLocationDegrees longitude = coordinate.longitude;
    
    NSLog(@"%f--%f--%f", altitude, latitude, longitude);
    
    //通常，获取位置信息成功后，关闭定位。为用户节省电量。
    //关闭定位。
    [_locationManager stopUpdatingLocation];
    
    //下次需要定位的时候，再次调用 startUpdatingLocation 方法即可。
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //CLHeading 封装了用户的朝向信息。
    
    //0，北，90，东，180，南，270，西。
    
    //以地磁上的北极为 0。
    //    newHeading.magneticHeading;
    
    //以地理上的北极为 0。
    //    newHeading.trueHeading;
    
    //停止获取。
    [_locationManager stopUpdatingHeading];
}

@end
