   
"""Strip of subreferences and range refernces from a passage compnoent of a URN.
$(SIGNATURES)  
"""
function psgbegin(psg::AbstractString)
    dropsubs = replace(psg, r"@.+" => "")
    replace(dropsubs, r"-.*" => "" )
end


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

"""Extract siglum for scholion from a full passage URN.
$(SIGNATURES)
"""
function siglum(s::AbstractString)
    s |> droplastcomponent |> lastpart
end