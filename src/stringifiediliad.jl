"""Builder exposing required components of an `IliadFacsimile` 
as structures with markdown string values optimized for performance.
"""
struct MarkdownIliad <: IliadFacsimile
    iliaddse
    otherdse
    diplomaticiliad
    diplomaticother
    normalizediliad
    normalizedother
    codex
    scholiaindex
end

struct MarkdownPageLego
    # previd
    # nextid
    # filename
    # page label
    # rv
    iliadtexttuples
    othertexttuples
    # links: iliad to scholia
    # backlinks: scholia to iliad
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
    iliaddse = filter(trip -> urncontains(ILIAD_URN, trip.passage), iliad.dsec.data)
    otherdse = filter(trip -> ! urncontains(ILIAD_URN, trip.passage), iliad.dsec.data)

    iliaddsestrings = map(tripl -> (string(tripl.passage), linkedMarkdownImage(ICT, tripl.image, IIIF), string(tripl.surface)), iliaddse)
    otherdsestrings = map(tripl -> (string(dropversion(tripl.passage)), linkedMarkdownImage(ICT, tripl.image, IIIF), string(tripl.surface)), otherdse)

    dipliliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), diplomaticiliad(iliad).passages)
    normediliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), normalizediliad(iliad).passages)

    diplother = map(psg -> (string(dropversion(psg.urn)), psg.text), diplomaticother(iliad).passages)
    normedother = map(psg -> (string(dropversion(psg.urn)), psg.text), normalizedother(iliad).passages)

    pagedata = map(pg -> stringify(pg), iliad.codex)
    scholindex = map(pr -> (string(dropversion(pr[1])), string(pr[2])) , iliad.scholiaindex)

    MarkdownIliad(
        iliaddsestrings, 
        otherdsestrings,
        dipliliad, normediliad,
        diplother, normedother,
        pagedata,
        scholindex
    )
end

"""Convert `MSPage` object to tuple of markdown.
$(SIGNATURES)
"""
function stringify(pg::MSPage)
    mdimg = linkedMarkdownImage(ICT, pg.image, IIIF)
    (string(pg.urn), pg.label, pg.rv, mdimg, pg.sequence, fname(pg.urn))
end



"""Compose markdown facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function mspage(iliad::MarkdownIliad, pg::AbstractString; navigation = true)
    @info("Formatting markdown page for $(pg)")
    pgdata = dataforpage(iliad, pg)

end



"""
"""
function dataforpage(iliad::MarkdownIliad, pg::AbstractString)
    @info("Format data for $(pg)")
    pginfo = filter(pg -> startswith(pg[1], pg12r),  mdiliad.codex)[1]
    pagelabel = pginfo[2]
    rv = pginfo[3]

    iliaddses = filter(tup -> startswith(tup[3],pg), iliad.iliaddse)
    # Unify text ref, text content and image:
    iliaddiplpsg = Tuple{String, String, String}[]
    for (txturn,img) in map(tup -> (tup[1], tup[2]), iliaddses)
        psgpair = filter(pr -> startswith(txturn, pr[1]), iliad.diplomaticiliad)
        if isempty(psgpair)
            @warn("FAILED ON $(txturn)")
        else
            push!(iliaddiplpsg, (psgpair[1][1], psgpair[1][2], img))
        end
    end

    otherdses = filter(tup -> startswith(tup[3],pg), iliad.otherdse)
    otherdiplpsg = Tuple{String, String, String}[]
    for (txturn,img) in map(tup -> (tup[1], tup[2]), otherdses)
        psgpair = filter(pr -> startswith(txturn, pr[1]), iliad.diplomaticother)
        if isempty(psgpair)
            @warn("FAILED ON $(txturn)")
        else
            push!(otherdiplpsg, (psgpair[1][1], psgpair[1][2], img))
        end
    end


    # scholia -> iliad index
    # iliad -> scholia index

    MarkdownPageLego(iliaddiplpsg, otherdiplpsg)
end