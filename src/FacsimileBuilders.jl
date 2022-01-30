module FacsimileBuilders
using Documenter, DocStringExtensions

using CitableObject

export AbstractFacsimile
export surfacesequence
export imageforsurface, texturnsforsurface
export diplomaticforsurface, normalizedforsurface


include("facsimile.jl")
include("simplems.jl")
include("venetusa.jl")

end # module
