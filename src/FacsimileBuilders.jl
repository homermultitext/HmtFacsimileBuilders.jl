module FacsimileBuilders
using Documenter, DocStringExtensions

using CitableObject

export AbstractFacsimile
export surfacesequence
export imageforsurface, texturnsforsurface
export diplomaticforsurface, normalizedforsurface


include("facsimile.jl")

end # module
