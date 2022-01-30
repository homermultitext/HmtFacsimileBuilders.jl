"Builder for creating simple manuscript facsimiles."
struct SimpleMSFacsimile <: AbstractFacsimile
    hmt::Archive
    codex::Cite2Urn
end

HMT_CODICES = Dict(
    "urn:cite2:hmt:msB.v1:" => "vbpages.cex",
    "urn:cite2:citebl:burney86pages.v1:" => "burney86pages.cex"
)


