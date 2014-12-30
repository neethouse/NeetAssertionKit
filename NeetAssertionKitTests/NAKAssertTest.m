//
//  NAKAssertTest.m
//  NeetAssertionKit
//
//  Created by mtmta on 2013/12/10.
//  Copyright (c) 2013 covelline, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NAKAssertions.h"

#import "TestObjects.h"


@interface NAKAssertTest : XCTestCase

@end

@implementation NAKAssertTest

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


/**
 
 NAKAssertTrue
 
 true でない時エラー.
 
 リリースビルドではエラーは起きず, 条件式も実行されない.
 
 */
- (void)testAssertTrue {

#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // エラー起きない
    XCTAssertNoThrow((^{
        NAKAssertTrue(YES, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // エラー
    XCTAssertThrows((^{
        NAKAssertTrue(NO, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");

#else
    
    /******************** リリースビルド ********************/

    // エラー起きない
    XCTAssertNoThrow((^{
        NAKAssertTrue(YES, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // false でもエラー起きない
    XCTAssertNoThrow((^{
        NAKAssertTrue(NO, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    { // 条件式は実行されない
        BOOL no = NO;
        NAKAssertTrue((no = YES), @"");
        XCTAssertFalse(no, @"条件式は実行されない");
    }
    
#endif
}


/**
 
 NAKFail
 
 常にエラー.
 
 リリースビルドではエラーは起きない.
 
 */
- (void)testFail {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // 常にエラー
    XCTAssertThrows((^{
        NAKFail(@"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");
    
#else
    
    /******************** リリースビルド ********************/

    // エラー起きない
    XCTAssertNoThrow((^{
        NAKFail(@"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
#endif
}


/**
 
 NAKWrap
 
 関数内でアサーションマクロが使用できる.
 
 リリースビルドでは式がそのまま実行される.
 
 */
- (void)testWrap {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // 常にエラー
    XCTAssertThrows((^{
        testWrapFailFunc();
    }()), @"str:ほむほむ, i:501");
    
#else
    
    /******************** リリースビルド ********************/

    // エラー起きない
    XCTAssertNoThrow((^{
        testWrapFailFunc();
    }()), @"");
    
    
    { // リリースビルドでも実行される
        BOOL trueOrFalse = NO;
        
        NAKWrap((trueOrFalse = YES));
        
        XCTAssertTrue(trueOrFalse, @"リリースビルドでも式が実行される");
    }
    
#endif
}

static void testWrapFailFunc() {
    
    NAKWrap(NAKFail(@"str:%@, i:%d", @"ほむほむ", 501));
}


/**
 
 NAKAssertNotNil
 
 式が nil の時エラー.
 
 リリースビルドではエラーは起きず, 条件式も実行されない.
 
 */
- (void)testAssertNotNil {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // nil 以外だとエラー起きない
    XCTAssertNoThrow((^{
        id obj = @"homu";
        NAKAssertNotNil(obj, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    // nil だとエラー
    XCTAssertThrows((^{
        NAKAssertNotNil(nil, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");

#else
    
    /******************** リリースビルド ********************/

    // nil 以外だとエラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = @"homu";
        NAKAssertNotNil(obj, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    // nil でもエラー起きない
    XCTAssertNoThrow((^{
        NAKAssertNotNil(nil, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    { // 条件式は実行されない
        id obj = nil;
        NAKAssertNotNil((obj = @"homu"), @"");
        XCTAssertNil(obj, @"条件式は実行されない");
    }
    
#endif
}

/**

 NAKAssertNil

 */
- (void)testAssertNil {

#ifdef DEBUG

    /******************** デバッグビルド ********************/

    // nil だとエラー起きない
    XCTAssertNoThrow((^{

        NAKAssertNil(nil, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    // nil 以外だとエラー
    XCTAssertThrows((^{
        id obj = @"homu";
        NAKAssertNil(obj, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");
    
#else

    /******************** リリースビルド ********************/

    // nil だとエラー起きない
    XCTAssertNoThrow((^{

        NAKAssertNil(nil, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    // nil 以外でもエラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = @"homu";
        NAKAssertNil(obj, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    { // 条件式は実行されない
        id obj = nil;
        NAKAssertNil((obj = @"homu"), @"");
        XCTAssertNil(obj, @"条件式は実行されない");
    }
    
#endif
}


/**
 
 NAKAssertKindOfClass
 
 オブジェクトが指定したクラスやサブクラスのインスタンスでない時エラー.
 
 リリースビルドではエラーは起きず, 式も実行されない.
 
 */
- (void)testAssertKindOfClass {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id obj = [[NAKHomuHomu alloc] init];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // 指定したクラスのサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id obj = [[NAKMegaHomu alloc] init];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");

    // その他のクラスのインスタンス: エラー
    XCTAssertThrows((^{
        id obj = [NSString string];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");
    
#else
    
    /******************** リリースビルド ********************/
    
    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [[NAKHomuHomu alloc] init];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // 指定したクラスのサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [[NAKMegaHomu alloc] init];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // その他のクラスのインスタンスでもエラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [NSString string];
        NAKAssertKindOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    { // 式は実行されない
        id obj = nil;
        NAKAssertKindOfClass((obj = @"homu"), NSArray, @"str:%@, i:%d", @"ほむほむ", 501);
        XCTAssertNil(obj, @"式は実行されない");
    }
    
#endif
}



/**
 
 NAKAssertMemberOfClass
 
 オブジェクトが指定したクラスのインスタンスでない時エラー.
 サブクラスでもエラー.
 
 リリースビルドではエラーは起きず, 式も実行されない.
 
 */
- (void)testAssertMemberOfClass {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/

    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id obj = [[NAKHomuHomu alloc] init];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // 指定したクラスのサブクラスのインスタンス: エラー
    XCTAssertThrows((^{
        id obj = [[NAKMegaHomu alloc] init];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");
    
    // その他のクラスのインスタンス: エラー
    XCTAssertThrows((^{
        id obj = [NSString string];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"str:ほむほむ, i:501");
    
#else

    /******************** リリースビルド ********************/

    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [[NAKHomuHomu alloc] init];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // サブクラスのインスタンスでもエラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [[NAKMegaHomu alloc] init];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    // その他のクラスのインスタンスでもエラー起きない
    XCTAssertNoThrow((^{
        __unused id obj = [NSString string];
        NAKAssertMemberOfClass(obj, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    { // 式は実行されない
        id obj = nil;
        NAKAssertMemberOfClass((obj = @"homu"), NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
        XCTAssertNil(obj, @"式は実行されない");
    }
    
#endif
}


/**
 
 NAKAssertCast
 
 式の結果が指定したクラス (or サブクラス) のインスタンスでない時エラー.
 
 式の結果が nil の場合はエラーは起きない.
 エラーが起きない時は, 式の結果が返される.
 
 リリースビルドではエラーは発生せず, 式がそのまま実行される.
 
 */
- (void)testAssertCast {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/
    
    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id src = [[NAKHomuHomu alloc] init];
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // 指定したクラスのサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id src = [[NAKMegaHomu alloc] init];
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // nil: エラー起きない
    XCTAssertNoThrow((^{
        id src = nil;
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");

    // その他のクラスのインスタンス: エラー
    XCTAssertThrows((^{
        id src = @"homu";
        NAKAssertCast(src, NAKHomuHomu);
    }()), @"");
    
#else
    
    /******************** リリースビルド ********************/
    
    // 指定したクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id src = [[NAKHomuHomu alloc] init];
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // 指定したクラスのサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        id src = [[NAKMegaHomu alloc] init];
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // nil: エラー起きない
    XCTAssertNoThrow((^{
        id src = nil;
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // その他のクラスのインスタンスでもエラー起きない && 式がそのまま実行される
    XCTAssertNoThrow((^{
        id src = @"homu";
        NAKHomuHomu *homu = NAKAssertCast(src, NAKHomuHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
    // ダウンキャストでも警告が出ない
    // -Werror=incompatible-pointer-types フラグを指定してテスト
    XCTAssertNoThrow((^{
        NAKHomuHomu *src = [[NAKMegaHomu alloc] init];
        NAKMegaHomu *homu = NAKAssertCast(src, NAKMegaHomu);
        XCTAssertEqual(homu, src, @"");
    }()), @"");
    
#endif
}


/**
 
 NAKAssertArrayType
 
 配列中にサブクラスでないインスタンスがひとつでも含まれるとエラー.
 
 リリースビルドではエラーは起きず, 式も実行されない.
 
 */
- (void)testAssertArrayType {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/
    
    // すべて指定したクラスかサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        NSArray *objects = @[ [[NAKHomuHomu alloc] init],
                              [[NAKMegaHomu alloc] init],
                              [[NAKHomuHomu alloc] init],
                              ];
        
        NAKAssertArrayType(objects, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);

    }()), @"");
    
    // その他のクラスのインスタンスが含まれる: エラー
    XCTAssertThrows((^{
        NSArray *objects = @[ [[NAKHomuHomu alloc] init],
                              [[NAKMegaHomu alloc] init],
                              @"homu"
                              ];
        
        NAKAssertArrayType(objects, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
        
    }()), @"str:ほむほむ, i:501");

#else
    
    /******************** リリースビルド ********************/
    
    // すべて指定したクラスかサブクラスのインスタンス: エラー起きない
    XCTAssertNoThrow((^{
        __unused NSArray *objects = @[ [[NAKHomuHomu alloc] init],
                                       [[NAKMegaHomu alloc] init],
                                       [[NAKHomuHomu alloc] init],
                                       ];
        
        NAKAssertArrayType(objects, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
        
    }()), @"");
    
    // その他のクラスのインスタンスが含まれててもエラー起きない
    XCTAssertNoThrow((^{
        __unused NSArray *objects = @[ [[NAKHomuHomu alloc] init],
                                       [[NAKMegaHomu alloc] init],
                                       @"homu"
                                       ];
        
        NAKAssertArrayType(objects, NAKHomuHomu, @"str:%@, i:%d", @"ほむほむ", 501);
        
    }()), @"");
    
    { // 式は実行されない
        NSArray *objects = nil;
        
        NAKAssertArrayType((objects = @[ @"homu" ]), NAKHomuHomu, @"");

        XCTAssertNil(objects, @"式は実行されない");
    }
    
#endif
}


/**
 
 NAKAssertMainThread
 
 スレッドがメインスレッドでない時エラー.
 
 リリースビルドではエラーは起きない.
 
 */
- (void)testAssertMainThread {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/
    
    // メインスレッド: エラー起きない
    XCTAssertNoThrow((^{
        NAKAssertMainThread(@"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    {// その他のスレッド: エラー
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        // sync だとメインスレッドで実行されちゃうので async して待機
        dispatch_async(queue, ^{
            XCTAssertThrows((^{
                NAKAssertMainThread(@"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"str:ほむほむ, i:501");
        });
        
        dispatch_sync(queue, ^{}); // 待機
    }
    
#else
    
    /******************** リリースビルド ********************/
    
    // メインスレッド: エラー起きない
    XCTAssertNoThrow((^{
        NAKAssertMainThread(@"str:%@, i:%d", @"ほむほむ", 501);
    }()), @"");
    
    {// その他のスレッドでもエラー起きない
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(queue, ^{
            XCTAssertNoThrow((^{
                NAKAssertMainThread(@"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"");
        });
        
        dispatch_sync(queue, ^{}); // 待機
    }
    
    { // 式は実行されない
        NSArray *objects = nil;
        
        NAKAssertArrayType((objects = @[ @"homu" ]), NAKHomuHomu, @"");
        
        XCTAssertNil(objects, @"式は実行されない");
    }
    
#endif
}


/**
 
 NAKAssertDispatchQueue
 
 実行中のディスパッチキューが指定したキューでない時エラー.
 
 リリースビルドではエラーは起きない.
 
 */
- (void)testAssertDispatchQueue {
    
#ifdef DEBUG
    
    /******************** デバッグビルド ********************/
    
    {// 指定したキュー: エラー起きない
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        // sync だとメインスレッドで実行されちゃうので async して待機
        dispatch_async(queue, ^{
            XCTAssertNoThrow((^{
                NAKAssertDispatchQueue(queue, @"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"");
        });
        
        dispatch_sync(queue, ^{}); // 待機
    }

    {// その他のキュー
        dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
        
        dispatch_queue_t expectedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(queue, ^{
            XCTAssertThrows((^{
                NAKAssertDispatchQueue(expectedQueue, @"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"str:ほむほむ, i:501");
        });
        
        dispatch_sync(queue, ^{}); // 待機
        
        #if !OS_OBJECT_USE_OBJC
        dispatch_release(queue);
        #endif
    }
    
#else
    
    /******************** リリースビルド ********************/
    
    
    {// 指定したキュー: エラー起きない
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        // sync だとメインスレッドで実行されちゃうので async して待機
        dispatch_async(queue, ^{
            XCTAssertNoThrow((^{
                NAKAssertDispatchQueue(queue, @"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"");
        });
        
        dispatch_sync(queue, ^{}); // 待機
    }
    
    {// その他のキューでもエラー起きない
        dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
        
        __unused dispatch_queue_t expectedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        
        dispatch_async(queue, ^{
            XCTAssertNoThrow((^{
                NAKAssertDispatchQueue(expectedQueue, @"str:%@, i:%d", @"ほむほむ", 501);
            }()), @"");
        });
        
        dispatch_sync(queue, ^{}); // 待機
        
        #if !OS_OBJECT_USE_OBJC
        dispatch_release(queue);
        #endif
    }
    
    { // 式は実行されない
        
        dispatch_queue_t queue = NULL;
        
        NAKAssertDispatchQueue((queue = dispatch_get_main_queue()), @"str:%@, i:%d", @"ほむほむ", 501);

        XCTAssertNil(queue, @"式は実行されない");
    }
    
#endif
}

@end
