module HmtFacsimileBuilders
using Documenter, DocStringExtensions

using CitableBase, CiteEXchange
using CitableText, CitableCorpus
using CitableObject
using CitableImage
using CitablePhysicalText

using EditorsRepo, HmtArchive

export AbstractFacsimile
export surfacesequence
export imageforsurface, texturnsforsurface
export diplomaticforsurface, normalizedforsurface

export SimpleHmtFacsimile
export VenetusAFacsimile, vabuilder
export vapages, vapage

include("constants.jl")
include("facsimile.jl")
include("simplems.jl")
include("venetusa.jl")

end # module
