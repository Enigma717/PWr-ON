# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5
# 
# Test poprawności implementacji


include("./iointerface.jl")
include("./matrixgen.jl")
using Test
using LinearAlgebra
using .matrixgen 


# Aliasy długich typów
const READ_MATRIX_TYPE = Tuple{Int, Int, Vector{Tuple{Int, Int, Float64}}}
const READ_VECTOR_TYPE = Tuple{Int, Vector{Float64}}

# Ścieżki do folderu z wejściem/wyjściem
const DATA_DIR::String = "./data"
const TESTSRESULT_DIR::String = "./testresults"

# Parametry generowanej macierzy
const BLOCK_SIZE::Int = 4
const COND_NUMBER::Float64 = 10.0


function tests()
    functions::Vector{Function} = [solve_gauss!, solve_pivotgauss!, 
                                   solve_combinedlu!, solve_combinedpivotlu!]
    sizes::Vector{Int} = [16, 10000, 50000, 100000, 300000, 500000]
    

    # Pierwszy test wykonywany jest na macierzach i wektorach zamieszczonych na stronie kursu przez Profesora.
    println("\n====================[ PRE-GENERATED MATRIX AND VECTOR ]====================")

    @testset "Pre-generated matrix A and vector b" begin
        for size in sizes
            matrixpath::String = "$DATA_DIR/n$(size)/A.txt" 
            vectorpath::String = "$DATA_DIR/n$(size)/b.txt"

            readmat::READ_MATRIX_TYPE = readmatrix(matrixpath)
            readvec::READ_VECTOR_TYPE = readvector(vectorpath)
            sparsematrix::MySpraseMatrix = MySpraseMatrix(readmat[1], readmat[2], readmat[3])

            println("\n\t   >> Matrix size (n): $(readmat[1])\t Block size (l): $(readmat[2]) <<")
            
            for func in functions
                funcname::String = chop("$func", tail = 1)
                xresultpath::String = "$TESTSRESULT_DIR/n$(size)/pregenerated/x_$(funcname).txt"

                println("--> Tested function: $func")

                xresult::Vector{Float64} = func(deepcopy(sparsematrix), deepcopy(readvec[2]))
                time = @elapsed func(deepcopy(sparsematrix), deepcopy(readvec[2]))

                @test isapprox(xresult, ones(Float64, length(xresult)))
                @test isapprox(sparsematrix * xresult, readvec[2])
                println(" \\--> Tests passed in $time seconds")

                writexresult(xresultpath, xresult)
            end
        end
    end
    

    # Drugi test wykonywany jest na macierzach wygenerowanych w czasie testu.
    #
    # Rozmiary danych są takie same jak w poprzednim teście, a wektor prawych stron b
    # jest obliczany na podstawie przemnożenia wygenerowanej macierzy przez x ∈ [1, 1, 1, ..., 1] 
    println("\n====================[ GENERATING MATRIX AND VECTOR ]====================")

    @testset "Generating matrix A and vector b" begin
        for size in sizes
            matrixpath::String = "$TESTSRESULT_DIR/n$(size)/generated/Agen.txt" 
            
            matrixgen.blockmat(size, BLOCK_SIZE, COND_NUMBER, matrixpath)
            
            readmat::READ_MATRIX_TYPE = readmatrix(matrixpath)
            sparsematrix::MySpraseMatrix = MySpraseMatrix(readmat[1], readmat[2], readmat[3])
            resultvec::Vector{Float64} = solve_resultvector(sparsematrix)
            onesvec::Vector{Float64} = ones(Float64, sparsematrix.matrixsize)

            println("\n\t   >> Matrix size (n): $(readmat[1])\t Block size (l): $(readmat[2]) <<")
            
            for func in functions
                funcname::String = chop("$func", tail = 1)
                xresultpath::String = "$TESTSRESULT_DIR/n$(size)/generated/x_werr_$(funcname).txt"

                println("--> Tested function: $func")

                xresult::Vector{Float64} = func(deepcopy(sparsematrix), deepcopy(resultvec))
                time = @elapsed func(deepcopy(sparsematrix), deepcopy(resultvec))

                @test isapprox(xresult, onesvec)
                @test isapprox(sparsematrix * xresult, resultvec)
                println(" \\--> Tests passed in $time seconds")

                approxerr::Float64 =  norm(xresult - onesvec) / norm(onesvec)
                writexresult(xresultpath, xresult, approxerr)
            end

            rm(matrixpath)
        end
    end

    println("\n\t      >> Test results saved in ./testresults <<") 
end


tests()