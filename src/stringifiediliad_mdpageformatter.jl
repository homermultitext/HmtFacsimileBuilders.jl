
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
        
        txtdisplay = iliadpassage(tripl)
        xreff = haskey(lego.iliadtoscholia, tripl[1]) ?             scholialinks(lego.iliadtoscholia[tripl[1]]) : ""
        

        push!(iliadpassages, txtdisplay * "\n\n" * xreff * "\n\n---")

    end

    othertext = diplomaticother(lego)
    otherhdr = isempty(othertext) ? "" : "## Other texts\n\n($(length(othertext)) passages)"
    join([
        hdr, 
        nav,
        thumbnail(lego),
        ilhdr,
        join(iliadpassages, "\n\n"),
        otherhdr,
        
        nav
    ], "\n\n")
end


function scholialinks(scholia)
    
    "Commented on by " * join(scholia, " ")
end

function iliadpassage(tripl::Tuple{String, String, String})
    psg = tripl[1]
    txt = tripl[2]
    img = tripl[3]
    img * "\n\n" * iliadanchor(psg) * "\n*Iliad* **" * lastcomponent(psg) * "**: " * txt 
end




"""Extract last colon-delimited component from a string.;
$(SIGNATURES)
"""
function lastcomponent(s::AbstractString)
    replace(s, r"[^:]*:" => "")
end

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