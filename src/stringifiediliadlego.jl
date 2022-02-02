
"""Prepackaged components for building a markdown
facsimile for a single page.  The components are:

- `filename`: automatically generated file name
- `pagelabel`: human-readable title for the page
- `thumbnail`: thumbnail image of the page formatted in either Markdown or HTML with link to ICT
- `rv`: `recto` or `verso`.  Useful in designing 2-page layouts
- `iliadtexttuples`: a Vector of triples.  Each triple contains:
    1. the URN of the text passage
    2. the text of the passage
    3. markdown or html to display the image indexed for the text, linked to ICT
- `othertexttuples`: a Vector of triples with the same structure as `iliadtexttuples`  
- `iliadtoscholia`: a `Dict` keyed by *Iliad* URN strings, pointing to a Vector of scholia URN strings
- `scholiatoiliad`: a `Dict` keyed by scholia URN strings, pointing to a Vector of *Iliad* URN strings
- `prevnext`: a `Tuple` with file names for preceding and following page.
"""
struct StringifiedIliadLego <: Lego
    filename::AbstractString
    pagelabel::AbstractString
    thumbnail::AbstractString
    rv::AbstractString
    iliadtexttuples::Vector{Tuple{String, String, String}}
    othertexttuples::Vector{Tuple{String, String, String}}
    iliadtoscholia::Dict{String, Vector{String}}
    scholiatoiliad::Dict{String, Vector{String}}
    prevnext::Tuple{String, String}
end

"""Compose facsimile for a single page of the Venetus A manuscript.
$(SIGNATURES)
"""
function stringified_iliad_mdpage(lego::StringifiedIliadLego; navigation = true)
    @info("Formatting page for $(lego.pagelabel)")
    lego
end
