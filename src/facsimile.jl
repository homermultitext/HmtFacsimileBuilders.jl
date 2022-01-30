
"Abstract type for facsimiles."
abstract type AbstractFacsimile end

"""Catch subtypes that fail to implement `surfacesequence` function.
$(SIGNATURES)
"""
function surfacesequence(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`surfacesequence` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `textsforsurface` function.
$(SIGNATURES)
"""
function textsforsurface(facs::T, surface::Cite2Urn) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`textsforsurface` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `imageforsurface` function.
$(SIGNATURES)
"""
function imageforsurface(facs::T, surface::Cite2Urn) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`imageforsurface` not implemented for type $(T)"))
end