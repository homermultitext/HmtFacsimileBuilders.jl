"Builder for creating simple manuscript facsimiles."
struct SimpleMSFacsimile <: AbstractFacsimile
    hmt::Archive
    codex::Cite2Urn
end