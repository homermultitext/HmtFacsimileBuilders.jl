
function iliadheader(ref::CtsUrn)
        namelink = "il_" *  passagecomponent(ref)
        join([
            "\n\n---\n\n<a name =\"$(namelink)\"/>",
             "*Iliad* $(passagecomponent(ref))"
        ])
end


function markdownpassage(tripl::DSETriple, c::CitableTextCorpus; thumbheight = 500)
    texts = filter(psg -> urncontains(tripl.passage, psg.urn), c.passages)
    caption = "Image: " * string(tripl.passage)
    imgmd = linkedMarkdownImage(ICT, tripl.image, IIIF; ht=thumbheight, caption=caption)

    txtdisplay = []
    for psg in texts
        push!(txtdisplay, psg.text)
    end
    join(
        [
        imgmd,
        join(txtdisplay, " ") 
        ],
        "\n\n"
    )
    

end

"""Compose markdown facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function vapage(vafacs::VenetusAFacsimile, pg::Cite2Urn; navigation = true, thumbheight = 200)
    @info("Formatting markdown page for $(pg)")
    navlink = navigation ? navlinks(vafacs, pg) : ""
    pgtxt = []
    # pg header
    push!(pgtxt,  stringified_iliad_mdpageheader(vafacs, pg))
    push!(pgtxt,  navlink)
    # thumbnail image
    push!(pgtxt, stringified_iliad_mdpagethumb(vafacs, pg))
    
    pagedse = filter(trip -> trip.surface == pg, vafacs.dsec.data)
    # collect Iliad psgs
    iliadurn = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:")
    iliad = filter(trip -> urncontains(iliadurn, trip.passage),  pagedse)
    if ! isempty(iliad)
        psgcount = length(iliad)
        push!(pgtxt, "### *Iliad*\n\n($(psgcount) lines) <a name=\"iliad\"/>")
        psgs = []
        for tripl in iliad
            push!(psgs, iliadheader(tripl.passage))
            push!(psgs, markdownpassage(tripl, vafacs.corpus))
            xreff  = filter(pr -> urncontains(tripl.passage, pr[2]), vafacs.scholiaindex)
            #@debug("On $(namelink) found $(length(xreff)) scholia")
            if isempty(xreff)
            else
                
               scholreff = map(pr -> pr[1], xreff)

               schollnkids = map(u -> workparts(u)[2] * "_" * passagecomponent(u), scholreff)
               scholdiplayids = map(u -> workparts(u)[2] * " " * passagecomponent(u), scholreff)
               paired = zip(schollnkids, scholdiplayids)
               namelinklist = map(pr -> "[$(pr[2])](#$(pr[1]))", paired)
               @debug("So have namelinks for $(length(namelinklist))")
            
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
            push!(scholia, markdownpassage(tripl, vafacs.corpus))
            anchorlink = "<a name=\"$(anchorname)\"/>"
            push!(scholia, anchorlink)
            xreff  = filter(pr -> urncontains(tripl.passage, pr[1]), vafacs.scholiaindex)
            if isempty(xreff)
            else
                ilurn = xreff[1][2]
                ilipsg = passagecomponent(ilurn)
                linkname = if CitableText.isrange(ilurn)
                    "il_" * range_begin(ilurn)
                else
                    "il_" * passagecomponent(ilurn)
                end
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
