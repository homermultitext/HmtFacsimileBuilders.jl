"""Generate file name from URN for a text-bearing surface.
$(SIGNATURES)
"""
function fname(surf::Cite2Urn)
    siglum = parts(collectioncomponent(surf))[1]
    pieces = [siglum,
    objectcomponent(surf),
    "md"
    ]
    join(pieces, ".")
end


"""One-step utility function to build a `CitableIliadFacsimile`
from a clone of the HMT archive in an adjacent directory,
and convert it to a `StringifiedIliadFacsimile`.  Both the `CitableIliadFacsimile`
and the `StringifiedIliadFacsimile` are returned in a Tuple.
$(SIGNATURES)
"""
function adjacentstringified()
    hmtcite = adjacent() |> hmtcitable
    (hmtcite, stringify(hmtcite))
end


# Text trimming.