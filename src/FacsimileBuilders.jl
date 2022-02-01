module HmtFacsimileBuilders
using Documenter, DocStringExtensions

using CitableBase, CiteEXchange
using CitableText, CitableCorpus
using CitablePhysicalText
using CitableObject

using EditorsRepo, HmtArchive

export AbstractFacsimile
export surfacesequence
export imageforsurface, texturnsforsurface
export diplomaticforsurface, normalizedforsurface

export SimpleHmtFacsimile
export VenetusAFacsimile, vabuilder
export vapages, vapage

include("facsimile.jl")
include("simplems.jl")
include("venetusa.jl")

end # module
