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

function surfaces(iliad::MarkdownIliad)
    map(pg -> pg[1], iliad.codex)
end


"""Prepackaged components for building a markdown
facsimile for a single page.  The components are:

- `filename`: automatically generated file name
- `pagelabel`: human-readable title for the page
- `thumbnail`: markdown to display thumbnail image of the page linked to ICT
- `rv`: `recto` or `verso`.  Useful in designing 2-page layouts
- `iliadtexttuples`: a Vector of triples.  Each triple contains:
    1. the URN of the text passage
    2. the text of the passage
    3. markdown to display the image indexed for the text, linked to ICT
- `othertexttuples`: a Vector of triples with the same structure as `iliadtexttuples`  
- `iliadtoscholia`: TBA
- `scholiatoiliad`: TBA
- `prevnext`: a `Tuple` with file names for preceding and following page.
"""
struct MarkdownPageLego
    filename::AbstractString
    pagelabel::AbstractString
    thumbnail::AbstractString
    rv::AbstractString
    iliadtexttuples::Vector{Tuple{String, String, String}}
    othertexttuples::Vector{Tuple{String, String, String}}
    iliadtoscholia # TBA
    scholiatoiliad # TBA
    prevnext::Tuple{String, String}
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


function facsimile(iliad::MarkdownIliad; 
    selection = [], navigation = true)
    pagelist = isempty(selection) ? surfaces(iliad) : selection
    for pg in pagelist
        pglego = dataforpage(iliad, pg)
        mdpage(pglego, navigation = navigation)
        # Write to file
    end
end

"""Compose markdown facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function mdpage(lego::MarkdownPageLego; 
    navigation = true)
    @info("Formatting markdown page for $(lego.pagelabel)")
end



"""Assemble a lego block of text structures for a single page.
$(SIGNATURES)
"""
function dataforpage(iliad::MarkdownIliad, pg::AbstractString)
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


    # scholia -> iliad index
    # iliad -> scholia index

    MarkdownPageLego(
        fname,
        pagelabel, 
        img,
        rv, 
        iliaddiplpsg, 
        otherdiplpsg,
        [], [],
        prevnext
        )
end