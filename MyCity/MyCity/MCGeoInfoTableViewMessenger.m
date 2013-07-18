//
//  MCGeoInfoTableViewMessenger.m
//  MyCity
//
//  Created by Cui Wei on 18/7/13.
//
//

#import "MCGeoInfoTableViewMessenger.h"

@implementation MCGeoInfoTableViewMessenger

static NSArray* data;


+(void)inputData:(NSMutableArray*)dataArray{
    
    data = nil;
    data = [NSArray arrayWithArray:dataArray];
    
}


+(NSArray*)outputData{
    
    return data;
    
}

@end
