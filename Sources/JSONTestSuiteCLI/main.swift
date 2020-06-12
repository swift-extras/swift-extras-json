import ArgumentParser
import NIO

struct JSONTestSuiteCLI: ParsableCommand {
  
  @Argument(help: "the json file to parse") var jsonFile: String
  
  func run() throws {
    // here lives the logic
    
    let bytes = try self.read(file: jsonFile)

    
  }
  
  func read(file: String) throws -> [UInt8] {
    
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    defer {
        try! group.syncShutdownGracefully()
    }
    let loop = group.next()
    let threadPool = NIOThreadPool(numberOfThreads: 1)
    threadPool.start()
    defer {
        try! threadPool.syncShutdownGracefully()
    }
    let fileIO = NonBlockingFileIO(threadPool: threadPool)
    
    let (handle, region) = try fileIO.openFile(path: file, eventLoop: loop).wait()
    let allocator = ByteBufferAllocator()
    var buffer = try fileIO.read(fileRegion: region, allocator: allocator, eventLoop: loop).wait()

    return buffer.readBytes(length: buffer.readableBytes)!
  }
  
}

JSONTestSuiteCLI.main()
