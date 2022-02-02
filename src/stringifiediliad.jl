"""Builder exposing required components of an `IliadFacsimile` 
as structures with markdown string values optimized for performance.
"""
struct MarkdownIliad <: IliadFacsimile
    dsec#::DSECollection
    diplomaticiliad#::CitableTextCorpus
    diplomaticother#::CitableTextCorpus
    normalizediliad#::CitableTextCorpus
    normalizedother#::CitableTextCorpus
    codex#::Vector{MSPage}
    scholiaindex
end


"""Construct a `StringifiedIliad` from a `CitableIliad`.
$(SIGNATURES)
In conversion to string values, text URNs are regularized by dropping
exemplar IDs from Iliad texts, and dropping version IDs from scholia.
The equivalent of a `urncontains` comparison can then be done with
the highly performant `startswith` function.

In addition, image references are replaced     
"""
function stringify(iliad::CitableIliad)
    dsestrings = map(tripl -> (string(tripl.passage), linkedMarkdownImage(ICT, tripl.image, IIIF), string(tripl.surface)), iliad.dsec.data)

    dipliliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), diplomaticiliad(iliad).passages)
    normediliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), normalizediliad(iliad).passages)

    diplother = map(psg -> (string(dropversion(psg.urn)), psg.text), diplomaticother(iliad).passages)
    normedother = map(psg -> (string(dropversion(psg.urn)), psg.text), normalizedother(iliad).passages)

    pagedata = map(pg -> stringify(pg), iliad.codex)
    scholindex = map(pr -> (string(dropversion(pr[1])), string(pr[2])) , iliad.scholiaindex)

    MarkdownIliad(
        dsestrings,
        dipliliad, normediliad,
        diplother, normedother,
        pagedata,
        scholindex
    )
end

function stringify(pg::MSPage)
    mdimg = linkedMarkdownImage(ICT, pg.image, IIIF)
    (string(pg.urn), pg.label, pg.rv, mdimg, pg.sequence)
end
