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
export CitableIliadFacsimile, hmtcitable
export StringifiedIliadFacsimile, stringify
export StringifiedIliadLego, stringified_iliad_page

export facsimile 

include("constants.jl")
include("outputtypes.jl")

include("abstractfacsimile.jl")
include("abstractlego.jl")
include("abstractms.jl")
include("abstractiliad.jl")

# Concrete implementations
# Partial:
include("citableiliad.jl")
# Complete:
include("stringifiediliadlego.jl")
include("stringifiediliad.jl")


include("utils.jl")
include("hmtarchive.jl")


end # module
