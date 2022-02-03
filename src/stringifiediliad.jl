"""Builder exposing required components of an `IliadFacsimile` 
as structures with markdown string values optimized for performance.
"""
struct StringifiedIliadFacsimile <: IliadFacsimile
    iliaddse
    otherdse
    diplomaticiliad
    diplomaticother
    normalizediliad
    normalizedother
    codex
    scholiaindex
end

"""Find sequence of page identifiers for `iliad`.
$(SIGNATURES)
For a `StringifiedIliadFacsimile`, the result is a list of URNs
represented as string values.
"""
function surfaces(iliad::StringifiedIliadFacsimile)
    map(pg -> pg[1], iliad.codex)
end


"""Assemble a lego block of text structures for a single page.
$(SIGNATURES)
"""
function legoforsurface(iliad::StringifiedIliadFacsimile, pg::AbstractString) :: StringifiedIliadLego
    @info("Format data for $(pg)")
    idx = findfirst(tup -> tup[1] == pg, iliad.codex)
    prev = idx == 1 ? "" :  iliad.codex[idx - 1][6]
    nxt = idx == length(iliad.codex) ? "" : iliad.codex[idx + 1][6]
    prevnext = (prev, nxt)
    pginfo = filter(p -> startswith(p[1], pg),  iliad.codex)[1]
    pagelabel = pginfo[2]
    rv = pginfo[3]
    img = pginfo[4]
    fname = pginfo[6]
    
    iliaddses = filter(tup -> startswith(tup[3],pg), iliad.iliaddse)
    # Unify text ref, text content and image:
    iliaddiplpsg = Tuple{String, String, String}[]
    for (txturn,img) in map(tup -> (tup[1], tup[2]), iliaddses)
        psgpair = filter(pr -> startswith(txturn, pr[1]), iliad.diplomaticiliad)
        if isempty(psgpair)
            @debug("NO ILIAD TEXTS indexed for $(txturn)")
        else
            push!(iliaddiplpsg, (psgpair[1][1], psgpair[1][2], img))
        end
    end

    otherdses = filter(tup -> startswith(tup[3],pg), iliad.otherdse)
    otherdiplpsg = Tuple{String, String, String}[]
    for (txturn,img) in map(tup -> (tup[1], tup[2]), otherdses)
        psgpair = filter(pr -> startswith(txturn, pr[1]), iliad.diplomaticother)
        if isempty(psgpair)
            @debug("NO NON-ILIADIC TEXTS indexed $(txturn)")
        else
            push!(otherdiplpsg, (psgpair[1][1], psgpair[1][2], img))
        end
    end

    iliadtoscholia = Dict{String, Vector{String}}()
    for tripleset in iliaddses
        @debug("Looking for $(tripleset[1])")
        pairs = filter(pr -> pr[2] ==  tripleset[1], iliad.scholiaindex)
        if ! isempty(pairs)
            schollist = map(tup -> tup[1], pairs)
            iliadtoscholia[tripleset[1]] = schollist
        end
    end

    scholiatoiliad = Dict{String, Vector{String}}()
    for tripleset in otherdses
        @debug("Looking for $(tripleset[1])")
        pairs = filter(pr -> pr[1] ==  tripleset[1], iliad.scholiaindex)
        if ! isempty(pairs)
            iliadlist = map(tup -> tup[1], pairs)
            scholiatoiliad[tripleset[1]] = iliadlist
        end
    end

    StringifiedIliadLego(
        fname,
        pg,
        pagelabel, 
        img,
        rv, 
        iliaddiplpsg, 
        otherdiplpsg,
        iliadtoscholia,
        scholiatoiliad, 
        prevnext
        )
end


"""Construct a `StringifiedIliadFacsimile` from a `CitableIliadFacsimile`.
$(SIGNATURES)
In conversion to string values, text URNs are regularized by dropping
exemplar IDs from Iliad texts, and dropping version IDs from scholia.
The equivalent of a `urncontains` comparison can then be done with
the highly performant `startswith` function.

In addition, image references are replaced with markdown or HTML.     
"""
function stringify(iliad::CitableIliadFacsimile; outputformat = MARKDOWN, thumbheight=300, interleavedwidth=500)
    iliaddse = filter(trip -> urncontains(ILIAD_URN, trip.passage), iliad.dsec.data)
    otherdse = filter(trip -> ! urncontains(ILIAD_URN, trip.passage), iliad.dsec.data)

    imgembedder  =  outputformat == MARKDOWN ? linkedMarkdownImage : linkedHtmlImage

    iliaddsestrings = map(tripl -> (string(tripl.passage), imgembedder(ICT, tripl.image, IIIF, ht = interleavedwidth), string(tripl.surface)), iliaddse)
    otherdsestrings = map(tripl -> (string(dropversion(tripl.passage)), imgembedder(ICT, tripl.image, IIIF, ht = interleavedwidth), string(tripl.surface)), otherdse)

    dipliliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), diplomaticiliad(iliad).passages)
    normediliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), normalizediliad(iliad).passages)

    diplother = map(psg -> (string(dropversion(psg.urn)), psg.text), diplomaticother(iliad).passages)
    normedother = map(psg -> (string(dropversion(psg.urn)), psg.text), normalizedother(iliad).passages)

    pagedata = map(pg -> stringify(pg, height = thumbheight), iliad.codex)
    scholindex = map(pr -> (string(dropversion(pr[1])), string(pr[2])) , iliad.scholiaindex)

    StringifiedIliadFacsimile(
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
function stringify(pg::MSPage, outputformat =  MARKDOWN; height = 500)
    embeddedimg =  outputformat == MARKDOWN ?  linkedMarkdownImage(ICT, pg.image, IIIF, ht = height) : linkedHtmlImage(ICT, pg.image, IIIF, ht = height)
    (string(pg.urn), pg.label, pg.rv, embeddedimg, pg.sequence, fname(pg.urn))
end


