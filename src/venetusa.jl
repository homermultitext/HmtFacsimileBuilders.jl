"Builder including unique features of the Venetus A manuscript."
struct VenetusAFacsimile <: AbstractFacsimile
    dsec::DSECollection
    corpus::CitableTextCorpus
    codex::Vector{MSPage}
    scholiaindex
end


function mdpageheader(va::VenetusAFacsimile, pg::Cite2Urn)
    matches = filter(p -> urnequals(pg, p.urn), va.codex)
    if length(matches) == 1
        "## $(matches[1] |> label)"
       
    elseif isempty(matches)
        "(Error:  no page data found for $(pg))"
    else
        "(Error:  $(length(matches)) pages found matching $(pg))"
    end
end

function mdpagethumb(va::VenetusAFacsimile, pg::Cite2Urn; thumbheight = 200)
    p = filter(p -> p.urn == pg, va.codex)[1]
    caption = "Overview image: " * p.label
    linkedMarkdownImage(ICT, p.image, IIIF; ht=thumbheight, caption=caption)
end


"""Compose Venetus A facsimile. By default, creates a facsimile 
of all pages. Optionally, a list of page URNs can be provided in  `selection`.
$(SIGNATURES)
"""
function vapages(vafacs::VenetusAFacsimile; selection = [], navigation = true)
    pagelist = isempty(selection) ? map(pg -> pg.urn, vafacs.codex) : selection
    mdpages = []
    for pg in pagelist
        push!(mdpages, vapage(vafacs, pg, navigation = navigation))
    end
    mdpages
end

function vapage(vafacs::VenetusAFacsimile, pg::Cite2Urn; navigation = true, thumbheight = 200)
    navlink = navigation ? navlinks(vafacs, pg) : ""

    pgtxt = []
    # pg header
    push!(pgtxt,  mdpageheader(vafacs, pg))
    push!(pgtxt,  navlink)
    # thumbnail image
    push!(pgtxt, mdpagethumb(vafacs, pg))
    
    pagedse = filter(trip -> trip.surface == pg, vafacs.dsec.data)
    # collect Iliad psgs
    iliadurn = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:")
    iliad = filter(trip -> urncontains(iliadurn, trip.passage),  pagedse)
    if ! isempty(iliad)
        psgcount = length(iliad)
        push!(pgtxt, "### *Iliad*\n\n($(psgcount) lines) <a name=\"iliad\"/>")
        psgs = []
        for tripl in iliad
            namelink = "il_" * passagecomponent(tripl.passage)
            push!(psgs, passagecomponent(tripl.passage) * " <a name =\"$(namelink)\"/>")
        end
        push!(pgtxt, join(psgs, "\n\n---\n\n"))
    end
    # collect non-Iliad psgs
    othertexts = filter(trip -> ! urncontains(iliadurn, trip.passage),  pagedse)
    if ! isempty(othertexts)
        othercount = length(othertexts)
        push!(pgtxt, "### Other texts\n\n($(othercount) passages)")
        push!(pgtxt, "See [Iliad lines](#iliad)")

        scholia = []
        for tripl in othertexts
            push!(scholia, tripl.passage)
            xreff  = filter(pr -> urncontains(tripl.passage, pr[1]), vafacs.scholiaindex)
            if isempty(xreff)
            else
                ilurn = xreff[1][2]
                ilipsg = passagecomponent(ilurn)
                linkname = "il_" * passagecomponent(ilurn)
                push!(scholia, "Comments on [$(ilipsg)](#$(linkname))")
            end

            #for xref in 
             #   push!(scholia, "Comments on Iliad " * xref[2])
            #end
        end
        push!(pgtxt, join(scholia, "\n\n----\n\n"))

    end
    #=
    psgmd = join(psgs, "\n\n---\n\n")
    @warn("Adding to pgtxt $(psgmd)")
    push!(pgtxt, psgmd)
    =#
    # Add footer
    push!(pgtxt, navlink)

    join(pgtxt, "\n\n")
end



function navlinks(va::VenetusAFacsimile, pg::Cite2Urn)
    @warn("Navigation links not yet implemented.")
    ""
end
