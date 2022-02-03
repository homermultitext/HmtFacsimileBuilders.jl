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

"""Comparison of two URN strings returning true if passage
component of `s1` contains passage component of `s2`.
$(SIGNATURES)
"""
function scholionmatch(s1::AbstractString, s2::AbstractString)
    @debug("Compare s1/s2", s1, s2)
    nonterminal = s2 * "."
    conclusion = s1 == s2 || startswith(s1, nonterminal) 
    @debug(conclusion)
    conclusion
end

"""Format multiple-part scholion entries into a single markdown scholion.
$(SIGNATURES)
"""
function scholiontext(prs::Vector{Tuple{String, String}})
    substrs = []
    for pr in prs
        if endswith(pr[1], "lemma")
            if ! isempty(pr[2])
                push!(substrs, "**" * pr[2] * "**")
            end
        else
            push!(substrs, " " * pr[2])
        end
    end
    join(substrs)
end

"""Assemble a lego block of text structures for a single page.
$(SIGNATURES)
"""
function legoforsurface(facs::StringifiedIliadFacsimile, pg::AbstractString) :: StringifiedIliadLego
    @debug("Organize lego for $(pg)")
    idx = findfirst(tup -> tup[1] == pg, facs.codex)
    @debug("Index $(idx)")
    prev = idx == 1 ? "" :  facs.codex[idx - 1][6]
    nxt = idx == length(facs.codex) ? "" : facs.codex[idx + 1][6]
    prevnext = (prev, nxt)
    
    pginfo = filter(p -> p[1] == pg,  facs.codex)[1]
    pagelabel = pginfo[2]
    rv = pginfo[3]
    img = pginfo[4]
    fname = pginfo[6]
    
    iliaddses = filter(tup -> tup[3] == pg, facs.iliaddse)
    # Unify text ref, text content and image:
    iliaddiplpsg = Tuple{String, String, String}[]
    for (txturn,img) in map(tup -> (tup[1], tup[2]), iliaddses)
        @debug("Mapping $(txturn) to tuple for stringified iliad")

        psgpair = filter(pr -> txturn == pr[1], facs.diplomaticiliad)
        if isempty(psgpair)
            @debug("NO ILIAD TEXTS indexed for $(txturn)")
        else
            push!(iliaddiplpsg, (psgpair[1][1], psgpair[1][2], img))
        end
    end

    otherdses = filter(tup -> startswith(tup[3],pg), facs.otherdse)
    otherdiplpsg = Tuple{String, String, String}[]
    for (txturn, img) in map(tup -> (tup[1], tup[2]), otherdses)
        

        ## THIS IS THE PROBLEM:
        #psgpair = filter(pr -> startswith(pr[1], txturn), facs.diplomaticother)
        psgpair = filter(pr -> scholionmatch(pr[1], txturn), facs.diplomaticother)
        @debug("For $(txturn), got $(psgpair)")
        if isempty(psgpair)
            @debug("NO NON-ILIADIC TEXTS indexed $(txturn)")
        else
            psgref = psgpair[1][1] |> collapsescholionref
            psgtext = scholiontext(psgpair)
            #push!(otherdiplpsg, (psgpair[1][1], psgpair[1][2], img))
            push!(otherdiplpsg, (psgref, psgtext, img))
            
        end
    end

    iliadtoscholia = Dict{String, Vector{String}}()
    for tripleset in iliaddses
        @debug("Looking for $(tripleset[1])")
        pairs = filter(pr -> pr[2] ==  tripleset[1], facs.scholiaindex)
        if ! isempty(pairs)
            schollist = map(tup -> tup[1], pairs)
            iliadtoscholia[tripleset[1]] = schollist
        end
    end

    scholiatoiliad = Dict{String, Vector{String}}()
    for tripleset in otherdses
        @debug("Looking for $(tripleset[1])")
        pairs = filter(pr -> pr[1] ==  tripleset[1], facs.scholiaindex)
        if ! isempty(pairs)
            iliadlist = map(tup -> tup[2], pairs)

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
function stringify(facs::CitableIliadFacsimile; outputformat = MARKDOWN, thumbheight=300, interleavedwidth=500)
    iliaddse = filter(trip -> urncontains(ILIAD_URN, trip.passage), facs.dsec.data)
    otherdse = filter(trip -> ! urncontains(ILIAD_URN, trip.passage), facs.dsec.data)

    imgembedder  =  outputformat == MARKDOWN ? linkedMarkdownImage : linkedHtmlImage

    iliaddsestrings = map(tripl -> (string(tripl.passage), imgembedder(ICT, tripl.image, IIIF, ht = interleavedwidth), string(tripl.surface)), iliaddse)
    otherdsestrings = map(tripl -> (string(dropversion(tripl.passage)), imgembedder(ICT, tripl.image, IIIF, ht = interleavedwidth), string(tripl.surface)), otherdse)

    dipliliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), diplomaticiliad(facs).passages)
    normediliad = map(psg -> (string(dropexemplar(psg.urn)), psg.text), normalizediliad(facs).passages)

    diplother = map(psg -> (string(dropversion(psg.urn)), psg.text), diplomaticother(facs).passages)


    normedother = map(psg -> (string(dropversion(psg.urn)), psg.text), normalizedother(facs).passages)

    pagedata = map(pg -> stringify(pg, height = thumbheight), facs.codex)
    scholindex = map(pr -> (string(dropversion(pr[1])), string(pr[2])) , facs.scholiaindex)

    StringifiedIliadFacsimile(
        iliaddsestrings, 
        otherdsestrings,
        dipliliad, diplother,
        normediliad, normedother,
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


