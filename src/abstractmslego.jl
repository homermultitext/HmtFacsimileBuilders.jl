
abstract type ManuscriptLego <: Lego end

"""Catch subtypes that fail to implement `rectoverso` function.
$(SIGNATURES)
All manuscript legos can identify a page as recto or verso.
"""
function rectoverso(facs::T) where {T <: MSFacsimile}
    throw(DomainError(facs, "`rectoverso` not implemented for type $(T)"))
end