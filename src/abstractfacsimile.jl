# Top of hierarchy of abstractions.
"Abstract type for facsimiles."
abstract type AbstractFacsimile end

"""Catch subtypes that fail to implement `surfaces` function.
$(SIGNATURES)
All facsimiles have a citable sequence of illustrated text-bearing surfaces.
"""
function surfaces(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`surfaces` not implemented for type $(T)"))
end


#=
"""Catch subtypes that fail to implement `dserecords` function.
$(SIGNATURES)
All facsimiles have DSE records linking texts, surfaces and images.
"""
function dserecords(facs::T) where {T <: AbstractFacsimile}
    throw(DomainError(facs, "`dserecords` not implemented for type $(T)"))
end
=#


"""Catch subtypes that fail to implement `legoforsurface`.
$(SIGNATURES)
"""
function legoforsurface(facs::T, surf) where {T <: AbstractFacsimile} 
    throw(DomainError(facs, "`legoforsurface` not implemented for type $(T)"))
end


"""Write a static-page facsimile for a sequence of text-bearing surfaces.
$(SIGNATURES)
It cycles through the surfaces in `facsbuilder` and uses the `legoforsurface` function to create a group of `Lego` blocks for the page, then applies `pageformatter` to the Lego blocks to create a formatted page.


## Parameters

- `pageformatter`: is a function that takes as a single argument the `Lego` blocks for a surface and generates a formatted page.
- `facsbuilder`: is a Facsimile builder (a subtype of `AbstractFacsimile`).
"""
function facsimile(
    pageformatter::Function, 
    facsbuilder::T
    ; 
    targetdir = nothing,
    selection = [], navigation = true) where {T <: AbstractFacsimile}

    basedir = isnothing(targetdir) ? pwd() : targetdir
    surfacelist = isempty(selection) ? surfaces(facsbuilder) : selection
    for surf in surfacelist
        lego = legoforsurface(facsbuilder, surf)
        fname = joinpath(basedir, filename(lego))
        formatted = pageformatter(lego, navigation = navigation)
        open(fname, "w") do io
            write(io, formatted)
        end
    end
end










