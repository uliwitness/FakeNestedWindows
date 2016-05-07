//
//  AppDelegate.m
//  FakeNestedWindows
//
//  Created by Uli Kusterer on 07/05/16.
//  Copyright © 2016 Uli Kusterer. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *windowContainer;
@property (weak) IBOutlet SubWindow *subWindow;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.subWindow.movable = NO;
	self.subWindow.windowContainer = self.windowContainer;
	[self.window addChildWindow: self.subWindow ordered: NSWindowAbove];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end


@implementation SubWindow

-(void)sendEvent: (NSEvent *)theEvent
{
	if( theEvent.type == NSLeftMouseDown )
	{
		NSView	*	hitView = [self.contentView.superview hitTest: theEvent.locationInWindow];
		if( [hitView mouseDownCanMoveWindow] )
		{
			NSRect		wdBox = self.frame;
			NSPoint		oldPos = [NSEvent mouseLocation];
			while( true )
			{
				@autoreleasepool
				{
					NSEvent	*	currEvent = [self nextEventMatchingMask: NSLeftMouseUpMask | NSLeftMouseDraggedMask];
					if( currEvent.type == NSLeftMouseUp )
						break;
					NSPoint	newPos = [NSEvent mouseLocation];
					NSRect	newBox = [self constrainFrameRect: NSOffsetRect( wdBox, newPos.x -oldPos.x, newPos.y -oldPos.y ) toScreen: nil];
					[self setFrame: newBox display: YES];
				}
			}
		}
		else
			[super sendEvent: theEvent];
	}
	else
		[super sendEvent: theEvent];
}


-(NSRect)	constrainFrameRect: (NSRect)frameRect toScreen: (nullable NSScreen *)screen
{
	NSRect	parentBox = self.parentWindow.frame;
	parentBox = NSOffsetRect( [self.windowContainer convertRect: self.windowContainer.bounds toView: nil], parentBox.origin.x, parentBox.origin.y );
	
	if( NSMinX(parentBox) > NSMinX(frameRect) )
		frameRect.origin.x = parentBox.origin.x;
	if( NSMinY(parentBox) > NSMinY(frameRect) )
		frameRect.origin.y = parentBox.origin.y;

	if( NSMaxX(parentBox) < NSMaxX(frameRect) )
		frameRect.origin.x = NSMaxX(parentBox) -frameRect.size.width;
	if( NSMaxY(parentBox) < NSMaxY(frameRect) )
		frameRect.origin.y = NSMaxY(parentBox) -frameRect.size.height;
	
	return frameRect;
}

@end
