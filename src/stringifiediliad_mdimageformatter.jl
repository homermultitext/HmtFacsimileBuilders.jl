
"""Compose markdown facsimile for a single page of a manuscript  with overview image and optional navigation links.
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
