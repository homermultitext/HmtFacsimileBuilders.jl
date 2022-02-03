
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
    ilhdr = isempty(iltext) ? "" : "## *Iliad* text\n\n($(length(iltext)) lines)"

    othertext = diplomaticother(lego)
    otherhdr = isempty(othertext) ? "" : "## Other texts\n\n($(length(othertext)) passages)"
    join([
        hdr, 
        nav,
        thumbnail(lego),
        ilhdr,

        otherhdr,
        
        nav
    ], "\n\n")
end








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