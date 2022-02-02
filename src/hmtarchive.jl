
"""Create a `CitableIliadFacsimile` builder from the HMT Archive.
$(SIGNATURES)
"""
function hmtcitable(hmt::Archive)
    @info("Assembling facsimile builder for citable content of HMT archive")
    @info("1/5. Loading diplomatic corpus")
    dip = diplomaticcorpus(hmt)
    @info("2/5. Loading normalized corpus")
    normed = normalizedcorpus(hmt)
    @info("3/5. Loading DSE data")
    triples = dse(hmt)
    @info("4/5. Loading codex data")
    codicesraw = hackcodices(hmt)
    mspages = filter(c -> !isnothing(c), codicesraw)
    vapages = filter( pg -> urncontains(Cite2Urn("urn:cite2:hmt:msA:"), pg.urn), mspages)
    @info("5/5. Indexing scholia to Iliad passages")
    rawindex = commentpairs(hmt)
    index = filter(pr -> ! isnothing(pr[2]), rawindex)
    
    CitableIliadFacsimile(triples, dip, normed, vapages, index)
end


### --------------- REPLACE THIS CHUNK ------------------------- ####
#
# Q&D temporary hacks until better solutoin in `HmtArchive` package:
function hackcodices(hmt::Archive)
    coddcex = HmtArchive.codexcex(hmt)
    codexpages = []
    for pg in data(coddcex, "citedata")
        push!(codexpages, hackcodex(pg))
    end
    codexpages
end
function hackcodex(ln::AbstractString)
    #=
#!citedata

-2|urn:cite2:hmt:msA.v1:insidefrontcover|verso|Venetus A (Marciana 454 = 822), \
inside front cover|urn:cite2:hmt:vaimg.2017a:VAMSInside_front_cover_versoN_0500
-1|urn:cite2:hmt:msA.v1:ir|recto|Venetus A (Marciana 454 = 822), folio i, recto\
|urn:cite2:hmt:vaimg.2017a:VAMSFolio_i_rectoN_0001
    =#
    @debug("Compare sequence|urn|rv|label|image with ", ln)
    cols = split(ln, "|")
    try 
        seq = parse(Int64, cols[1])
        u = Cite2Urn(cols[2])
        rv = cols[3]
        lbl = cols[4]
        img = Cite2Urn(cols[5])
        MSPage(u, lbl, rv, img, seq)
    catch
        @warn("Failed to parse $(ln)")
        nothing
    end
end
