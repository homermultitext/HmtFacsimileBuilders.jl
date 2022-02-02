"Abstract type for manuscript facsimiles."
abstract type MSFacsimile <: AbstractFacsimile end


"""Catch subtypes that fail to implement `rectoversos` function.
$(SIGNATURES)
All manuscript facsimiles can identify pages as recto or verso.
"""
function rectoversos(facs::T) where {T <: MSFacsimile}
    throw(DomainError(facs, "`rectoversos` not implemented for type $(T)"))
end

