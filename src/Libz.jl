__precompile__()

module Libz

export ZlibInflateInputStream, ZlibDeflateInputStream,
       ZlibInflateOutputStream, ZlibDeflateOutputStream,
       adler32, crc32

using BufferedStreams, Compat

include("lowlevel.jl")
include("state.jl")
include("source.jl")
include("sink.jl")
include("deflate.jl")
include("checksums.jl")

const compress = deflate
const decompress = inflate

end # module Libz
