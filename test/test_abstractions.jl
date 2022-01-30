@testset "Test for checks on all required functions" begin
    struct FakeFax <: AbstractFacsimile end
    fakeFax = FakeFax()
    @test_throws DomainError surfacesequence(fakeFax)

    pg = Cite2Urn("urn:cite2:hmt:msApages.v1:12r")
    @test_throws DomainError textsforsurface(fakeFax,pg)
    @test_throws DomainError imageforsurface(fakeFax,pg)

end