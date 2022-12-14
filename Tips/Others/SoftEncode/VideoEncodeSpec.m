//
//  VideoEncodeSpec.m
//  Tips
//
//  Created by lss on 2022/11/4.
//

#import "VideoEncodeSpec.h"
//#import "MTVideoCapture.h"
//#import <libavformat/avformat.h>
//#import <libavcodec/codec.h>
//#import <libswresample/swresample.h>//SwrContext
//#import <libavutil/imgutils.h> // 视频编码
//#import <libavcodec/avcodec.h>
//#import <libavutil/opt.h>
//#import <libavutil/samplefmt.h>
//
//#import <VideoToolbox/VideoToolbox.h>
//#import <AVFoundation/AVFoundation.h>
//
//@interface VideoEncodeSpec ()
//
//@property (nonatomic, copy) NSString *filename;
//@property (nonatomic, assign) enum AVPixelFormat pixFmt;
//@property (nonatomic, assign) int width;
//@property (nonatomic, assign) int height;
//
//@end

@implementation VideoEncodeSpec
//
//// 检查像素格式
//static int checktPixFmt(const AVCodec *codec, enum AVPixelFormat pixFmt) {
//    const enum AVPixelFormat *p = codec->pix_fmts;
//    while (*p != AV_PIX_FMT_NONE) {
//        if (*p == pixFmt) return 1;
//        p++;
//    }
//    return 0;
//}
//
//- (void)h264Encode:(VideoEncodeSpec *)input output:(NSString*)output{
//    NSFileHandle *infile = [NSFileHandle fileHandleForReadingAtPath:input.filename];
//    [[NSFileManager defaultManager]createFileAtPath:output contents:nil attributes:nil];
//    NSFileHandle *outfile = [NSFileHandle fileHandleForWritingAtPath:output];
//    // 一帧图片的大小
//    int imageSize = av_image_get_buffer_size(input.pixFmt, input.width, input.height, 1);
//    int ret = 0;
//    // 编码器
//    AVCodec *codec = NULL;
//    // 编码上下文
//    AVCodecContext *ctx = NULL;
//    AVFrame *frame = NULL;
//    AVPacket *pkt = NULL;
//    NSData *inData = nil;
//    
//    
//    
//    //    uint8_t *buf = NULL;
//    // 获取编码器
//    codec = avcodec_find_encoder_by_name("libx264") ;
//    if (!codec) {
//        NSLog(@"codec not found");
//        return;
//    }
//    // 检查输入格式
//    if (!checktPixFmt(codec, input.pixFmt)) {
//        return;
//    }
//    // 创建编码器上下文
//    ctx = avcodec_alloc_context3(codec);
//    if (!ctx) {
//        NSLog(@"avcodec_alloc_context3 error");
//        return;
//    }
//    //设置YUV参数
//    ctx->width = input.width;
//    ctx->height = input.height;
//    ctx->pix_fmt = input.pixFmt;
//    // 设置帧率
//    ctx->time_base.num = 1;
//    ctx->time_base.den = 30;
//    // 打开编码器
//    ret = avcodec_open2(ctx, codec, NULL);
//    if (ret < 0) {
//        //            NSLog(@"%@");
//        goto end;
//    }
//    // 创建frame
//    frame = av_frame_alloc();
//    if (!frame) {
//        goto end;
//    }
//    
//    frame->width = ctx->width;
//    frame->height = ctx->height;
//    frame->format = ctx->pix_fmt;
//    frame->pts = 0;
//    
//    // 利用width，height ,format创建缓冲区, 相当于把每一帧内部布局设置好，然后直接填充数据
//    ret = av_image_alloc(frame->data, frame->linesize,
//                         input.width, input.height,
//                         AV_PIX_FMT_YUV420P, 1);
//    
//    if (ret < 0) {
//        //            ERROR_BUF(ret);
//        goto end;
//    }
//    NSLog(@"%s", frame->data[0]);
//    
//    if (ret < 0) {
//        //            ERROR_BUF(ret);
//        goto end;
//    }
//    // 创建AVPacket
//    pkt = av_packet_alloc();
//    if (!pkt) {
//        goto end;
//    }
//    // ffmpeg -i in.MP4 -s 512x512 -pixel_format yuv420p in.yuv
//    // 打开文件
//    inData = [infile readDataOfLength:imageSize];
//    while (inData.length > 0) {
//        // 进行编码
//        frame->data[0] = (uint8_t*)inData.bytes;
//        if ([self encode:ctx inputFrame:frame outputPkt:pkt file:outfile] < 0) {
//            goto end;
//        }
//        // 设置帧序号
//        frame->pts++;
//        inData = [infile readDataOfLength:imageSize];
//    }
//    
//    // 刷新缓冲区
//    [self encode:ctx inputFrame:NULL outputPkt:pkt file:outfile];
//end:
//    NSLog(@"----：%lld", frame->pts);
//    [infile closeFile];
//    [outfile closeFile];
//    if (frame) {
//        //        av_freep(&frame->data[0]);
//        av_frame_free(&frame);
//    }
//    av_packet_free(&pkt);
//    avcodec_free_context(&ctx);
//}
//- (int)encode:(AVCodecContext*)ctx inputFrame:(AVFrame*)frame outputPkt:(AVPacket*)pkt file:(NSFileHandle*)file {
//    // 发送数据到编码器
//    int ret = avcodec_send_frame(ctx, frame);
//    if (ret < 0) {
//        return ret;
//    }
//    // 不断从编码器中取出编码后的数据
//    static int total = 0;
//    while (true) {
//        ret = avcodec_receive_packet(ctx, pkt);
//        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
//            return 0;
//        } else if (ret < 0) {
//            return ret;
//        }
//        // 将编码后的数据写入文件
//        total += pkt->size;
//        NSLog(@"写入H264文件：%d - %llu - 总长度：%d", pkt->size, file.offsetInFile, total);
//        [file writeData:[NSData dataWithBytes:pkt->data length:pkt->size]];
//        [file seekToEndOfFile];
//        // 释放pkt内部的资源
//        av_packet_unref(pkt);
//    }
//}
//
//

@end
