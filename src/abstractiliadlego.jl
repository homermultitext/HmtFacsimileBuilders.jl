

abstract type IliadLego <: ManuscriptLego end

function iliadtexttuples(lego::T) where {T <: IliadLego}
end

function othertexttuples(lego::T) where {T <: IliadLego}
end

function iliadtoscholia(lego::T) where {T <: IliadLego}
end

function scholiatoiliad(lego::T) where {T <: IliadLego}
end


