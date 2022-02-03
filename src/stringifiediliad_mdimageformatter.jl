
"""Compose facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function stringified_iliad_mdimage_browser(lego::StringifiedIliadLego; navigation = true)
    
    hdr = "# " * lego.pagelabel
    nav = navigation ? mdnavblock(lego.prevnext) : ""

    join([
        hdr, 
        lego.thumbnail,
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