//
//  ServiceLocationConvertor.h
//
//  Created by QFish on 7/3/14.
//  Copyright (c) 2014 geek-zoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLocation (convert)
- (CLLocation *)gcj02;
@end

@interface ServiceLocationConvertor : NSObject

+ (CLLocation *)gcj02FromWgs84:(CLLocation *)wgs84;

@end
