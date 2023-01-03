# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5


include("./iointerface.jl")
include("./matrixgen.jl")
using Test
using LinearAlgebra
using .matrixgen 


# Ścieżka do folderu z danymi
const DATA_DIR = "./data"
const TESTSRESULT_DIR = "./testresults"

# Aliasy długich typów
const READ_MATRIX_TYPE = Tuple{Int, Int, Vector{Tuple{Int, Int, Float64}}}
const READ_VECTOR_TYPE = Tuple{Int, Vector{Float64}}


function tests()
    functions::Vector{Function} = [solve_gauss!, solve_pivotgauss!, 
                                   solve_combinedlu!, solve_combinedpivotlu!]
    sizes::Vector{Int} = [16, 10000, 50000, 100000, 300000, 500000]
    

    println("====================[ PRE-GENERATED MATRIX AND VECTOR ]====================")

    @testset "Pre-generated matrix A and vector b" begin
        for size in sizes
            matrixpath::String = "$DATA_DIR/n$(size)/A.txt" 
            vectorpath::String = "$DATA_DIR/n$(size)/b.txt"

            readmat::READ_MATRIX_TYPE = readmatrix(matrixpath)
            readvec::READ_VECTOR_TYPE = readvector(vectorpath)
            sparsematrix::MySpraseMatrix = MySpraseMatrix(readmat[1], readmat[2], readmat[3])

            println("\n\t   >> Matrix size (n): $(readmat[1])\t Block size (l): $(readmat[2]) <<")
            
            for func in functions
                xresultpath::String = "$TESTSRESULT_DIR/n$(size)/pregenerated/x_$(func).txt"

                println("--> Tested function: $func")

                @time xresult::Vector{Float64} = func(deepcopy(sparsematrix), deepcopy(readvec[2]))

                @test isapprox(xresult, ones(Float64, length(xresult)))
                @test isapprox(sparsematrix * xresult, readvec[2])
                println(" \\--> Tests passed")

                writexresult(xresultpath, xresult)
            end
        end
    end
    

    println("====================[ GENERATING MATRIX AND VECTOR ]====================")

    @testset "Generating matrix A and vector b" begin
        for size in sizes
            matrixpath::String = "$TESTSRESULT_DIR/n$(size)/generated/Agen.txt" 
            
            matrixgen.blockmat(size, 4, 10.0, matrixpath)
            
            readmat::READ_MATRIX_TYPE = readmatrix(matrixpath)
            sparsematrix::MySpraseMatrix = MySpraseMatrix(readmat[1], readmat[2], readmat[3])
            resultvec::Vector{Float64} = solve_resultvector(sparsematrix)
            onesvec::Vector{Float64} = ones(Float64, sparsematrix.matrixsize)

            println("\n\t   >> Matrix size (n): $(readmat[1])\t Block size (l): $(readmat[2]) <<")
            
            for func in functions
                xresultpath::String = "$TESTSRESULT_DIR/n$(size)/generated/x_werr_$(func).txt"

                println("--> Tested function: $func")

                @time xresult::Vector{Float64} = func(deepcopy(sparsematrix), deepcopy(resultvec))

                @test isapprox(xresult, onesvec)
                @test isapprox(sparsematrix * xresult, resultvec)
                println(" \\--> Tests passed")

                approxerr::Float64 =  norm(xresult - onesvec) / norm(onesvec)
                writexresult(xresultpath, xresult, approxerr)
            end

            rm(matrixpath)
        end
    end
end


tests()