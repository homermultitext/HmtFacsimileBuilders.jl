"""Abstract type for component sets ("Lego blocks")
for a single text-bearing surface.
"""
abstract type Lego end


"""Catch failures to implement required `filename` function.
$(SIGNATURES)
"""
function filename(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`filename` not implemented for type $(T)"))
end


"""Catch failures to implement required `thumbnail` function.
$(SIGNATURES)
"""
function thumbnail(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`thumbnail` not implemented for type $(T)"))
end

function pagelabel(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`pagelabel` not implemented for type $(T)"))
end

function pageid(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`pageid` not implemented for type $(T)"))
end

function prevnext(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`prevnext` not implemented for type $(T)"))
end