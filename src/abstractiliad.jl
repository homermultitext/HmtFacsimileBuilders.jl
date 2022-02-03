
"Abstract type for manuscript facsimiles."
abstract type IliadFacsimile <: MSFacsimile end


"""Catch subtypes that fail to implement `diplomaticiliad` function.
$(SIGNATURES)
"""
function diplomaticiliad(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`diplomaticiliad` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `diplomaticother` function.
$(SIGNATURES)
"""
function diplomaticother(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`diplomaticother` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `normalizediliad` function.
$(SIGNATURES)
"""
function normalizediliad(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`normalizediliad` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `normalizedother` function.
$(SIGNATURES)
"""
function normalizedother(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`normalizedother` not implemented for type $(T)"))
end

"""Catch subtypes that fail to implement `scholiatoiliad` function.
$(SIGNATURES)
"""
function scholiatoiliad(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`scholiatoiliad` not implemented for type $(T)"))
end


"""Catch subtypes that fail to implement `iliadtoscholia` function.
$(SIGNATURES)
"""
function iliadtoscholia(facs::T) where {T <: IliadFacsimile}
    throw(DomainError(facs, "`iliadtoscholia` not implemented for type $(T)"))
end