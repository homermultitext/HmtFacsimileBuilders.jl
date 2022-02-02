# Top of hierarchy of abstractions.
"Abstract type for facsimiles."
abstract type AbstractFacsimile end

"""Catch subtypes that fail to implement `surfaces` function.
$(SIGNATURES)
All facsimiles have a citable sequence of illustrated text-bearing surfaces.
"""
function surfaces(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`surfaces` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `dserecords` function.
$(SIGNATURES)
All facsimiles have DSE records linking texts, surfaces and images.
"""
function dserecords(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`dserecords` not implemented for type $(T)"))
end









