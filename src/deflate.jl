function deflate(data::Vector{UInt8})
    dst = Vector{UInt8}(max(div(sizeof(data) * 12, 10), 16))
    code, sz = _deflate!(dst, data)
    while code == Z_BUF_ERROR
        resize!(dst, sizeof(dst) * 2)
        code, sz = _deflate!(dst, data)
    end
    if code != Z_OK
        zerror(code)
    end
    return dst[1:sz]
end

#=
function deflate!(dst::Vector{UInt8}, src::Vector{UInt8})
    code, sz = _deflate!(dst, src)
    if code != Z_OK
        zerror(code)
    end
    return sz
end
=#

function _deflate!(dst, src)
    sz = Ref(Culong(sizeof(dst)))
    code = ccall((:compress, zlib), Cint, (Ptr{UInt8}, Ref{Culong}, Ptr{UInt8}, Culong), dst, sz, src, sizeof(src))
    return code, UInt(sz[])
end

function inflate(data::Vector{UInt8})
    dst = Vector{UInt8}(sizeof(data) * 3)
    code, sz = _inflate!(dst, data)
    while code == Z_BUF_ERROR
        resize!(dst, sizeof(dst) * 2)
        code, sz = _inflate!(dst, data)
    end
    if code != Z_OK
        zerror(code)
    end
    return dst[1:sz]
end

#=
function inflate!(dst::Vector{UInt8}, src::Vector{UInt8})
    code, sz = _inflate!(dst, src)
    if code != Z_OK
        zerror(code)
    end
    return sz
end
=#

function _inflate!(dst, src)
    sz = Ref(Culong(sizeof(dst)))
    code = ccall((:uncompress, zlib), Cint, (Ptr{UInt8}, Ref{Culong}, Ptr{UInt8}, Culong), dst, sz, src, sizeof(src))
    return code, UInt(sz[])
end
