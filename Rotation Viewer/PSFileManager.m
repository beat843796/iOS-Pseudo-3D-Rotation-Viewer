//
//  PSFileManager.m
//  PresentationSystem
//
//  Created by Clemens Hammerl on 16.10.10.
//  Copyright 2010 appingo. All rights reserved.
//

#import "PSFileManager.h"


@implementation PSFileManager

-(NSString *)getDocumentsDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

-(NSString *)getCachesDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cachesDirectory = [paths objectAtIndex:0];
	
	return cachesDirectory;
}

-(NSString *)getContentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *contentDirectory = [documentsDirectory stringByAppendingPathComponent:@"content"];
	
	if (![self fileExistsAtPath:contentDirectory isDirectory:NULL]) {
		[self createDirectoryAtPath:contentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	}	
	
	return contentDirectory;

}

-(NSString *)getCacheContentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *cacheContentDirectory = [cacheDirectory stringByAppendingPathComponent:@"content"];
	
	if (![self fileExistsAtPath:cacheContentDirectory isDirectory:NULL]) {
		[self createDirectoryAtPath:cacheContentDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	}	
	
	return cacheContentDirectory;
}

-(NSString *)getCustomPresentationDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *customPresentationDirectory = [documentsDirectory stringByAppendingPathComponent:@"customPresentations"];
	
	if (![self fileExistsAtPath:customPresentationDirectory isDirectory:NULL]) {
		[self createDirectoryAtPath:customPresentationDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	}	
	
	return customPresentationDirectory;
}

-(void)clearContentsOfDirectory:(NSString *)dir
{
	NSArray *filesToRemove = [self contentsOfDirectoryAtPath:dir error:NULL];
	
	if (filesToRemove != nil) {
		for (int i = 0; i < [filesToRemove count]; i++) {
			
			NSString *pathOfFileToDelete = [dir stringByAppendingPathComponent:[filesToRemove objectAtIndex:i]];
			
			[self removeItemAtPath:pathOfFileToDelete error:NULL];
			
		}
	}
	
	
}

@end
