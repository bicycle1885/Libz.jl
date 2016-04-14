

module Libz

using BufferedStreams

export ZlibInflateInputStream, ZlibDeflateInputStream,
       ZlibInflateOutputStream, ZlibDeflateOutputStream,
       adler32, crc32


include("zlib_h.jl")
include("source.jl")
include("sink.jl")
include("checksums.jl")


function deflate(data::Vector{UInt8})
    return readbytes(ZlibDeflateInputStream(data))
end

const compress = deflate


function inflate(data::Vector{UInt8})
    return readbytes(ZlibInflateInputStream(data))
end

const decompress = inflate

end # module Libz


