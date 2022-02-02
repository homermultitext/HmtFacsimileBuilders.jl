"""Generate file name from URN.
$(SIGNATURES)
"""
function fname(pg::Cite2Urn)
    siglum = parts(collectioncomponent(pg))[1]
    pieces = [siglum,
    objectcomponent(pg),
    "md"
    ]
    join(pieces, ".")
end


"""One-step utility function to build a `CitableIliad`
from a clone of the HMT archive in an adjacent directory,
and convert it to a `MarkdownIliad`.  Both the `CitableIliad`
and the `MarkdownIliad` are returned in a Tuple.
$(SIGNATURES)
"""
function adjacentmd()
    hmtcite = adjacent() |> hmtcitable
    (hmtcite, stringify(hmtcite))
end