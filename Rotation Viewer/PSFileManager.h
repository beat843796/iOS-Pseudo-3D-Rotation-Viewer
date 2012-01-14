//
//  PSFileManager.h
//  PresentationSystem
//
//  Created by Clemens Hammerl on 16.10.10.
//  Copyright 2010 appingo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PSFileManager : NSFileManager {

}

-(NSString *)getDocumentsDirectoryPath;
-(NSString *)getCachesDirectoryPath;
-(NSString *)getContentDirectory;
-(NSString *)getCacheContentDirectory;
-(NSString *)getCustomPresentationDirectory;

-(void)clearContentsOfDirectory:(NSString *)dir;

@end
