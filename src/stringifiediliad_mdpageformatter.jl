
"""Compose facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function stringified_iliad_mdpage(lego::StringifiedIliadLego; navigation = true)
    @info("Formatting page for $(lego.pagelabel)")
    lego
end






