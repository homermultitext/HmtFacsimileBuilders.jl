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