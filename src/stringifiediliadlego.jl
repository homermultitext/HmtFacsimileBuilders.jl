
"""Prepackaged components for building a markdown
facsimile for a single page.  The components' contents are fully
accessible using functions included in this package without referring
to the internal structure of the `StringifiedIliadLego`, but
its ihnternal structure is comprised of the following members:

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
    pageid::AbstractString
    pagelabel::AbstractString
    thumbnail::AbstractString
    rv::AbstractString
    iliadtexttuples::Vector{Tuple{String, String, String}}
    othertexttuples::Vector{Tuple{String, String, String}}
    iliadtoscholia::Dict{String, Vector{String}}
    scholiatoiliad::Dict{String, Vector{String}}
    prevnext::Tuple{String, String}
end

"""Filename for the Lego of this page.
$(SIGNATURES)
"""
function filename(lego::StringifiedIliadLego)
    lego.filename
end

"""Thumbnail image with overview of page.
$(SIGNATURES)
The image is represented by HTML or Markdown, 
depending on how the `StringifiedIliadLego` was assembled,
and is linked to an image citation tool.
"""
function thumbnail(lego::StringifiedIliadLego)
    lego.thumbnail
end

"""Label for the page.
$(SIGNATURES)
"""
function pagelabel(lego::StringifiedIliadLego)
    lego.pagelabel
end

"""Identifier for the page.
$(SIGNATURES)
The identifier is a string value for a `Cite2Urn`.
"""
function pageid(lego::StringifiedIliadLego)
    lego.pageid
end

"""Is the page a recto or verso?
$(SIGNATURES)
One of two allowed literal strings: `recto` or `verso`.
"""
function rectoverso(lego::StringifiedIliadLego)
    lego.rv
end

"""Diplomatic edition of the *Iliad* text (if any) on this page.
$(SIGNATURES)
Each citable passage is represent by a `Tuple{String, String, String}`
containing:

1. the string value of the `CtsUrn` for the passage
2. a diplomatic rendering of the text content of the passage
3. markdown or HTML linking to the indexed image documenting this passage
"""
function diplomaticiliad(lego::StringifiedIliadLego)
    lego.iliadtexttuples
end


"""Diplomatic edition of non-Iliadic texts (if any) on this page.
$(SIGNATURES)
Each citable passage is represent by a `Tuple{String, String, String}`
containing:

1. the string value of the `CtsUrn` for the passage
2. a diplomatic rendering of the text content of the passage
3. markdown or HTML linking to the indexed image documenting this passage
"""
function diplomaticother(lego::StringifiedIliadLego)
    lego.othertexttuples
end


function scholiatoiliad(lego::StringifiedIliadLego)
    lego.scholiatoiliad
end


function iliadtoscholia(lego::StringifiedIliadLego)
    lego.iliadtoscholia
end



function prevnext(lego::StringifiedIliadLego)
    lego.prevnext
end


