@testset "Test for checks on all required functions" begin
    struct FakeFax <: IliadFacsimile end
    fakeFax = FakeFax()

    # Facsimile abstraction:
    @test_throws DomainError surfaces(fakeFax)
    @test_throws DomainError dserecords(fakeFax)
    # Manuscript abstraction:
    @test_throws DomainError rectoversos(fakeFax) 
    # Iliad abstraction:
    @test_throws DomainError diplomaticiliad(fakeFax) 
    @test_throws DomainError normalizediliad(fakeFax) 
    @test_throws DomainError diplomaticother(fakeFax) 
    @test_throws DomainError normalizedother(fakeFax) 
    @test_throws DomainError scholiaindex(fakeFax) 
end