//
//  YMLocationTool.m
//  WSYMPay
//
//  Created by W-Duxin on 16/10/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMLocationTool.h"
#import <CoreLocation/CoreLocation.h>
static id _instance = nil;

@interface YMLocationTool ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, copy)   LocationBlcok  locationBlock;

@property (nonatomic, copy)   ErrorBlock  error;

@property (nonatomic, assign) BOOL fineLocation;
@end

@implementation YMLocationTool

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

-(CLLocation *)currentLocation
{
    if (!_currentLocation) {
        
        _currentLocation = [[CLLocation alloc]init];
    }
    
    return _currentLocation;
}

+(instancetype)sharedInstance
{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });

    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
#pragma mark - 开始定位
- (void)findCurrentLocation {
    
    if (! [CLLocationManager locationServicesEnabled]) {
        
    }
    
    // 2
    else if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    // 3
    else {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLlocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    
    // 5
    CLLocation *newLocation = [locations lastObject];
    
    self.currentLocation = newLocation;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                
                // 获取城市
                NSString *city = placemark.locality;
                if (!city) {
                    // 6
                    city = placemark.administrativeArea;
                }

                if (self.fineLocation) {
                    
                    NSString *findLocation = [NSString stringWithFormat:@"%@-%@",placemark.country,placemark.administrativeArea];
                    
                    if (!findLocation.length) {
                        
                        if (self.error) {
                            
                            self.error(@"网络错误");
                            return;
                        }
                    }
                    
                    if (![placemark.administrativeArea isEqualToString:placemark.locality]) {
                        
                        if (placemark.locality.length) {
                            
                            findLocation = [NSString stringWithFormat:@"%@-%@",findLocation,placemark.locality];
                        }
                    }
                    
                    if (placemark.subLocality.length) {
                        
                        findLocation = [NSString stringWithFormat:@"%@-%@",findLocation,placemark.subLocality];
                    }
                    
                    if (placemark.thoroughfare.length) {
                        
                        findLocation = [NSString stringWithFormat:@"%@-%@",findLocation,placemark.thoroughfare];
                    }
                    
                    if (placemark.subThoroughfare.length) {
                        
                         findLocation = [NSString stringWithFormat:@"%@-%@",findLocation,placemark.subThoroughfare];
                    }
                    
                    NSString *latitudeStr  = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
                    
                    NSString *longitudeStr = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
                    
                    if (self.locationBlock) {
                        
                        self.locationBlock(findLocation,latitudeStr,longitudeStr);
                    }
                
                } else {
                
                    if (self.locationBlock) {
                        
                        if ([city isEqualToString:placemark.administrativeArea]) {
                            
                            self.locationBlock(city,nil,nil);
                            
                        } else {
                        
                            city = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,city];
                        
                            self.locationBlock(city,nil,nil);
                        }
                    }
                }
 
            } else if ([placemarks count] == 0) {
                
                if (self.error) {
                    
                    self.error(@"定位失败");
                }
            }
        } else {
            if (self.error) {
                
                self.error(@"网络故障");
            }
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

-(void)startLocationWithFineLocation:(LocationBlcok)location locationError:(ErrorBlock)error
{
    self.fineLocation   = YES;
    self.locationBlock  = location;
    self.error          = error;
    [self findCurrentLocation];
}

-(void)startLocationWithCurrentLocation:(LocationBlcok)location locationError:(ErrorBlock)error
{
    self.locationBlock = location;
    self.fineLocation  = NO;
    self.error         = error;
    [self findCurrentLocation];

}

@end
