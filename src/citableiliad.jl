"""Builder exposing required components of an `IliadFacsimile` 
as collections of citable content"""
struct CitableIliadFacsimile <: IliadFacsimile
    dsec::DSECollection
    diplomatic::CitableTextCorpus
    normalized::CitableTextCorpus
    codex::Vector{MSPage}
    scholiaindex
end


"""Ordered sequence of manuscript pages.
$(SIGNATURES)
Required by `AbstractFacsimile`.
"""
function surfaces(iliad::CitableIliadFacsimile)
    iliad.codex
end

"""Collection of DSE records.
$(SIGNATURES)
Required by `AbstractFacsimile`.
"""
function dserecords(iliad::CitableIliadFacsimile)
    iliad.dsec
end

"""Identification of pages as recto or verso.
$(SIGNATURES)
Required by `MSFacsimile` abstraction.
"""
function rectoversos(iliad::CitableIliadFacsimile)
    map(pg -> (pg.urn, pg.rv), iliad.codex)
end

"""Diplomatic edition of Iliad.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function diplomaticiliad(iliad::CitableIliadFacsimile)
    filter(psg -> urncontains(ILIAD_URN, psg.urn), iliad.diplomatic.passages) |> CitableTextCorpus
end

"""Normalized edition of Iliad.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function normalizediliad(iliad::CitableIliadFacsimile)
    filter(psg -> urncontains(ILIAD_URN, psg.urn), iliad.normalized.passages) |> CitableTextCorpus
end


"""Diplomatic edition of non-Iliadic texts.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function diplomaticother(fax::CitableIliadFacsimile)
    filter(psg -> ! urncontains(ILIAD_URN, psg.urn), fax.diplomatic.passages) |> CitableTextCorpus
end

"""Normalized edition of non-Iliadic texts.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function normalizedother(iliad::CitableIliadFacsimile)
    filter(psg -> ! urncontains(ILIAD_URN, psg.urn), iliad.normalized.passages) |> CitableTextCorpus
end

"""Index of scholia to Iliad passages.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function scholiaindex(iliad::CitableIliadFacsimile)
    iliad.scholiaindex
end
