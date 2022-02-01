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
            push!(psgs, "\n\n---\n\n<a name =\"$(namelink)\"/>")
            push!(psgs, "*Iliad* $(passagecomponent(tripl.passage))")

            xreff  = filter(pr -> urncontains(tripl.passage, pr[2]), vafacs.scholiaindex)
            @warn("On $(namelink) found $(length(xreff)) scholia")
            if isempty(xreff)
            else
                
               scholreff = map(pr -> pr[1], xreff)

               schollnkids = map(u -> workparts(u)[2] * "_" * passagecomponent(u), scholreff)
               scholdiplayids = map(u -> workparts(u)[2] * " " * passagecomponent(u), scholreff)
               paired = zip(schollnkids, scholdiplayids)
               namelinklist = map(pr -> "[$(pr[2])](#$(pr[1]))", paired)
               @warn("So have namelinks for $(length(namelinklist))")
            
            push!(psgs, "Commented on by " * join(namelinklist, ", "))

            end
           
        end
        push!(pgtxt, join(psgs, "\n\n"))
    end


    # collect non-Iliad psgs
    othertexts = filter(trip -> ! urncontains(iliadurn, trip.passage),  pagedse)
    if ! isempty(othertexts)
        othercount = length(othertexts)
        push!(pgtxt, "### Other texts\n\n($(othercount) passages)")
        

        scholia = []
        for tripl in othertexts
            anchorname = workparts(tripl.passage)[2] * "_" * passagecomponent(tripl.passage)
            display = workparts(tripl.passage)[2] * " " * passagecomponent(tripl.passage)
            push!(scholia, display)
            anchorlink = "<a name=\"$(anchorname)\"/>"
            push!(scholia, anchorlink)
            xreff  = filter(pr -> urncontains(tripl.passage, pr[1]), vafacs.scholiaindex)
            if isempty(xreff)
            else
                ilurn = xreff[1][2]
                ilipsg = passagecomponent(ilurn)
                linkname = "il_" * passagecomponent(ilurn)
                push!(scholia, "On *Iliad* [$(ilipsg)](#$(linkname))")
                push!(scholia, "\n\n---\n\n")
            end

                end
        push!(pgtxt, join(scholia, "\n\n"))

    end

    # Add footer
    push!(pgtxt, navlink)

    join(pgtxt, "\n\n")
end



function navlinks(va::VenetusAFacsimile, pg::Cite2Urn)
    @warn("Navigation links not yet implemented.")
    ""
end
