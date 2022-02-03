
"""Compose facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
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
        ilhdr,

        otherhdr,
        thumbnail(lego),
        nav
    ], "\n\n")
end








function mdnavblock(pr::Tuple{String, String})
    prev = pr[1]
    nxt = pr[2]
    lines = [
        "| previous | next |",
        "| --- | --- |",
        "| [$(prev)](./$(prev)/) | [$(nxt)](./$(nxt)/) |"
    ]
    join(lines, "\n")
end