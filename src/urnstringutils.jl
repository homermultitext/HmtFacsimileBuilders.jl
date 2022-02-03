    
"""Collapse passage component of a string representing a
CTS URN by one level.
$(SIGNATURES)
"""
function collapsescholionref(ref::AbstractString)
    replace(ref, r"(.*)\.(.+)" => s"\1")
end


"""Drop last colon-delimited component from a URN string.
$(SIGNATURES)
"""
function droplastcomponent(s::AbstractString)
    replace(s, r"((.)*):.*" => s"\1")
end


"""Extract last colon-delimited component from a string.;
$(SIGNATURES)
"""
function lastcomponent(s::AbstractString)
    replace(s, r"[^:]*:" => "")
end


"""Extract last period-delimited part from a string.;
$(SIGNATURES)
"""
function lastpart(s::AbstractString)
    replace(s, r"[^\.]*\." => "")
end