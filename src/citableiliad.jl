"Builder including unique features of the Venetus A manuscript."
struct CitableIliad <: IliadFacsimile
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
function surfaces(iliad::CitableIliad)
    iliad.codex
end

"""Collection of DSE records.
$(SIGNATURES)
Required by `AbstractFacsimile`.
"""
function dserecords(iliad::CitableIliad)
    iliad.dsec
end

"""Identification of pages as recto or verso.
$(SIGNATURES)
Required by `MSFacsimile`.
"""
function rectoversos(iliad::CitableIliad)
    map(pg -> (pg.urn, pg.rv), iliad.codex)
end

"""Diplomatic edition of Iliad.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function diplomaticiliad(iliad::CitableIliad)
    filter(psg -> urncontains(ILIAD_URN, psg.urn), iliad.diplomatic.passages) |> CitableTextCorpus
end

"""Normalized edition of Iliad.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function normalizediliad(iliad::CitableIliad)
    filter(psg -> urncontains(ILIAD_URN, psg.urn), iliad.normalized.passages) |> CitableTextCorpus
end




"""Diplomatic edition of non-Iliadic texts.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function diplomaticother(iliad::CitableIliad)
    filter(psg -> ! urncontains(ILIAD_URN, psg.urn), iliad.diplomatic.passages) |> CitableTextCorpus
end

"""Normalized edition of non-Iliadic texts.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function normalizedother(iliad::CitableIliad)
    filter(psg -> ! urncontains(ILIAD_URN, psg.urn), iliad.normalized.passages) |> CitableTextCorpus
end

"""Index of scholia to Iliad passages.
$(SIGNATURES)
Required by `IliadFacsimile`.
"""
function scholiaindex(iliad::CitableIliad)
    iliad.scholiaindex
end
