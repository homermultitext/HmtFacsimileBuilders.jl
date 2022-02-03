
"""Compose markdown facsimile for a single page of an *Iliad* manuscript.
$(SIGNATURES)
The display includes texts, if any, with two-way links between *Iliad* lines
and *scholia* commenting on them.
"""
function stringified_iliad_mdpage(lego::StringifiedIliadLego; navigation = true)
    @info("Formatting page for $(lego.pagelabel)")
    hdr = "# " * pagelabel(lego)
    nav = navigation ? mdnavblock(prevnext(lego)) : ""

    iltext = diplomaticiliad(lego)
    ilhdr = isempty(iltext) ? "" : "## *Iliad* text ($(length(iltext)) lines)\n\n---"
    iliadpassages = []
    for tripl in iltext
        #@debug("TRIPLE FOR ILIAD", tripl[1])
        txtdisplay = iliadpassage(tripl)
        xreff = haskey(lego.iliadtoscholia, tripl[1]) ?             scholialinks(lego.iliadtoscholia[tripl[1]]) : ""
        push!(iliadpassages, txtdisplay * "\n\n" * xreff * "\n\n---")

    end

    othertext = diplomaticother(lego)
    otherhdr = isempty(othertext) ? "" : "## Other texts\n\n($(length(othertext)) passages)"
    otherpassages = []
    for tripl in othertext
        scholref = collapsescholionref(tripl[1])
        @debug("look for ", scholref)
        xreff = haskey(lego.scholiatoiliad, scholref) ?  iliadlinks(lego.scholiatoiliad[scholref]) : ""
        
        txtdisplay = scholiapassage(tripl)
        push!(otherpassages, txtdisplay * "\n\n" * xreff * "\n\n---")
        
    end


    join([
        hdr, 
        nav,
        thumbnail(lego),
        ilhdr,
        join(iliadpassages, "\n\n"),
        otherhdr,
        join(otherpassages, "\n\n"),
        nav
    ], "\n\n")
end



"""Format links to *Iliad* lines that a scholion comments on.
$(SIGNATURES)
"""
function iliadlinks(iliadlines)
    lnks = []
    for ref in iliadlines
        psg = lastcomponent(ref)
        push!(lnks, "[$(psg)](#il_$(psg))")
    end
    "Comments on " * join(lnks, ", ")
end

function scholiapassage(tripl::Tuple{String, String, String})
    psg = tripl[1]
    txt = tripl[2]
    img = tripl[3]
   

    img * "\n\n" * scholionanchor(psg) * "\n\n**" * lastcomponent(psg) * "**: " * txt
end




"""Compose HTML anchor for a scholion
$(SIGNATURES)
"""
function scholionanchor(psg::AbstractString)
    ref = lastcomponent(psg) |> collapsescholionref
    siglum = psg |> droplastcomponent |> lastpart
    idstr = siglum * "." * ref


    "<a name=\"" * idstr * "\"/>"
end


"""Format links to scholia commenting on an *Iliad* passage.
$(SIGNATURES)
"""
function scholialinks(scholia)

    lnks = []
    for s in scholia
        ref = lastcomponent(s)
        siglum = s |> droplastcomponent |> lastpart
        idstr = "#" * siglum * "." * ref
        lnk = "[$siglum $ref]($idstr)"
        push!(lnks, lnk)
        #push!(lnks, s)

    end

    "Commented on by " * join(lnks, " ")
end


"""Format markdown display of an *Iliad* passage.
$(SIGNATURES)
"""
function iliadpassage(tripl::Tuple{String, String, String})
    psg = tripl[1]
    txt = tripl[2]
    img = tripl[3]
    @debug("Format iliad passage", psg)
    img * "\n\n" * iliadanchor(psg) * "\n\n*Iliad* **" * lastcomponent(psg) * "**: " * txt
end


"""Compose HTML anchor for an *Iliad* passage
$(SIGNATURES)
"""
function iliadanchor(psg::AbstractString)
    "<a name=\"il_" * lastcomponent(psg) * "\"/>"
end


"""Format navigation links in a markdown table.
$(SIGNATURES)
"""
function mdnavblock(pr::Tuple{String, String})
    prev = pr[1]
    prevlabel = replace(replace(prev, ".md" => ""), "." => " ")
    nxt = pr[2]
    nextlabel = replace(replace(nxt, ".md" => ""), "." => " ")
    lines = [
        "| previous | next |",
        "| --- | --- |",
        "| [$(prevlabel)](./$(prev)/) | [$(nextlabel)](./$(nxt)/) |"
    ]
    join(lines, "\n")
end