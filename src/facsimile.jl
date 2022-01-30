
"Abstract type for facsimiles."
abstract type AbstractFacsimile end

"""Catch subtypes that fail to implement `surfacesequence` function.
$(SIGNATURES)
"""
function surfacesequence(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`surfacesequence` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `diplomaticforsurface` function.
$(SIGNATURES)
"""
function diplomaticforsurface(facs::T, surface::Cite2Urn) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`diplomaticforsurface` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `normalizedforsurface` function.
$(SIGNATURES)
"""
function normalizedforsurface(facs::T, surface::Cite2Urn) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`normalizedforsurface` not implemented for type $(T)"))
end


"""Catch subtypes that fail to implement `imageforsurface` function.
$(SIGNATURES)
"""
function imageforsurface(facs::T, surface::Cite2Urn) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`imageforsurface` not implemented for type $(T)"))
end


