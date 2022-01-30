
"Abstract type for facsimiles."
abstract type AbstractFacsimile end


"""Catch subtypes that fail to implement `surfaces` function.

"""
function surfaces(facs::T) where {T <: AbstractFacsimile}

end