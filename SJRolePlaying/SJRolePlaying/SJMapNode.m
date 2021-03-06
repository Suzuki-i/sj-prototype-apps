//
//  SJMapNode.m
//  SJRolePlaying
//
//  Created by Tatsuya Tobioka on 2013/10/20.
//  Copyright (c) 2013年 tnantoka. All rights reserved.
//

#import "SJMapNode.h"

#import "SJComponents.h"

#ifdef DEBUG
#import "YMCPhysicsDebugger.h"
#import "YMCSKNode+PhysicsDebug.h"
#endif

static const CGFloat TILE_COLS = 20.0f;

static NSString * const FILE_TYPE = @"csv";

static NSString * const TILESHEET_NAME = @"tilesheet";

NSString * const kMapName = @"map";
NSString * const kPlayerName = @"c0";

const uint32_t playerCategory = 0x1 << 0;
const uint32_t characterCategory = 0x1 << 1;

@implementation SJMapNode {
    NSString *_name;
}

- (id)initWithMapNamed:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        
        self.name = kMapName;
        [self createNodeContents];
    }
    return self;
}

- (void)createNodeContents {
    
#ifdef DEBUG
    [YMCPhysicsDebugger init];
#endif
    
    SKTexture *tilesheetTexture = [SKTexture textureWithImageNamed:TILESHEET_NAME];
    NSString *mapData = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_name ofType:FILE_TYPE]  encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *layers = [mapData componentsSeparatedByString:@"\n\n"];
    
    for (NSString *layer in layers) {
        
        NSString *trimmedLayer = [layer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *rows = [[[trimmedLayer componentsSeparatedByString:@"\n"] reverseObjectEnumerator] allObjects];
        for (int i = 0; i < rows.count; i++) {
            NSString *row = rows[i];
            row = [row stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *cols = [row componentsSeparatedByString:@","];
            for (int j = 0; j < cols.count; j++) {
                
                NSString *col = cols[j];
                
                if ([col isEqualToString:@"-1"]) continue;
                if ([col isEqualToString:@"o"]) continue;
                if ([col isEqualToString:@"-"]) continue;

                SKNode *tileSprite;
                
                if ([col isEqualToString:@"x"]) {
                    tileSprite = SKNode.new;
                    
                    tileSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
                    tileSprite.physicsBody.dynamic = NO;
                    
                } else if ([col hasPrefix:@"c"]) {
                    tileSprite = [self newCharacterNode:col];
                } else {
                    NSInteger index = [col integerValue];
                    
                    CGFloat x = index % (NSInteger)TILE_COLS * TILE_SIZE / tilesheetTexture.size.width;
                    CGFloat y = index / (NSInteger)TILE_COLS * TILE_SIZE / tilesheetTexture.size.height;
                    CGFloat w = TILE_SIZE / tilesheetTexture.size.width;
                    CGFloat h = TILE_SIZE / tilesheetTexture.size.height;
                    
                    CGRect rect = CGRectMake(x, y, w, h);
                    SKTexture *tileTexture = [SKTexture textureWithRect:rect inTexture:tilesheetTexture];
                    
                    tileSprite = [SKSpriteNode spriteNodeWithTexture:tileTexture];
                }
                
                CGPoint position = CGPointMake(j * TILE_SIZE + TILE_SIZE / 2.0f, i * TILE_SIZE + TILE_SIZE / 2.0f);
                //tileSprite.anchorPoint = CGPointMake(0, 0);
                tileSprite.position = position;
                
                [self addChild:tileSprite];
            }
        }
        
    }
    
#ifdef DEBUG
    //[self drawPhysicsBodies];
#endif
    
}

- (void)replaceCharacterNodeFrom:(NSString *)fromName to:(NSString *)toName {
    
    SKNode *fromNode = [self childNodeWithName:fromName];
    SKNode *toNode = [self newCharacterNode:toName];
    
    toNode.position = fromNode.position;
    
    [fromNode removeFromParent];
    [self addChild:toNode];
}

- (SKNode *)newCharacterNode:(NSString *)name {
    SKNode *tileSprite = [[SJCharacterNode alloc] initWithCharacterNamed:name];
    
    tileSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(TILE_SIZE, TILE_SIZE)];
    tileSprite.physicsBody.affectedByGravity = NO;
    tileSprite.physicsBody.allowsRotation = NO;
    
    if ([name isEqualToString:kPlayerName]) {
        tileSprite.physicsBody.categoryBitMask = playerCategory;
        tileSprite.physicsBody.contactTestBitMask = characterCategory;
    } else {
        tileSprite.physicsBody.categoryBitMask = characterCategory;
        tileSprite.physicsBody.contactTestBitMask = playerCategory;
        tileSprite.physicsBody.dynamic = NO;
    }
    
    tileSprite.name = name;
    return tileSprite;
}


@end
