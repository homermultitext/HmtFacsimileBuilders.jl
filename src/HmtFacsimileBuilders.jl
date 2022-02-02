module HmtFacsimileBuilders
using Documenter, DocStringExtensions

using CitableBase, CiteEXchange
using CitableText, CitableCorpus
using CitableObject
using CitableImage
using CitablePhysicalText

using EditorsRepo, HmtArchive


## Hierarchy of abstract classes and their functions:
export AbstractFacsimile
export surfaces, dserecords

export MSFacsimile
export rectoversos

export IliadFacsimile
export diplomaticiliad, normalizediliad
export diplomaticother, normalizedother
export scholiaindex

# Concrete implementations:
export CitableIliad, hmtcitable
export MarkdownIliad, stringify

include("constants.jl")
include("facsimile.jl")
include("msfacsimile.jl")
include("iliad.jl")
include("citableiliad.jl")
include("stringifiediliad.jl")
include("utils.jl")

include("hmtarchive.jl")

#include("venetusa.jl")

end # module
