//
//  AppDelegate.h
//  FakeNestedWindows
//
//  Created by Uli Kusterer on 07/05/16.
//  Copyright © 2016 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


@end


@interface SubWindow : NSPanel

@property (weak) NSView*	windowContainer;

@end