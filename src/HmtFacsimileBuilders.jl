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
export surfaces, legoforsurface
export facsimile 

export Lego
export filename, pageid, pagelabel, thumbnail

export MSFacsimile
export rectoversos

export ManuscriptLego
export rectoverso


export IliadFacsimile
export diplomaticiliad, normalizediliad
export diplomaticother, normalizedother
export scholiatoiliad, iliadtoscholia

export IliadLego

# Concrete implementations:
export CitableIliadFacsimile, hmtcitable
export StringifiedIliadFacsimile, stringify
export StringifiedIliadLego
export stringified_iliad_mdpage, stringified_iliad_mdimage_browser



include("constants.jl")
include("outputtypes.jl")
include("urnstringutils.jl")

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
include("stringifiediliad_mdpageformatter.jl")
include("stringifiediliad_mdimageformatter.jl")


include("utils.jl")
include("hmtarchive.jl")


end # module
