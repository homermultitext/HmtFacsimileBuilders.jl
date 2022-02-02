"""Abstract type for component sets ("Lego blocks")
for a single text-bearing surface.
"""
abstract type Lego end


"""Catch failures to implement required function.
$(SIGNATURES)
"""
function filename(lego::T) where {T <: Lego}
    throw(DomainError(lego, "`filename` not implemented for type $(T)"))
end