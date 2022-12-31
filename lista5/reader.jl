# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5


include("./matrix.jl")
using .blocksys


DATA_PATH_A = "./data/n16/A.txt"
DATA_PATH_B = "./data/n16/b.txt"


function readmainmat(path::String)
    open(path, "r") do io
        n::Int = 0
        l::Int = 0
        row::Int = 0
        col::Int = 0
        val::Float64 = 0.0
        sizes::Vector{SubString{String}} = split(readline(io), " ")
        values::Vector{Tuple{Int, Int, Float64}} = []

        
        n = parse(Int, sizes[1])
        l = parse(Int, sizes[2])

        while !eof(io)
            line = split(readline(io), " ")
            row = parse(Int, line[1])
            col = parse(Int, line[2])
            val = parse(Float64, line[3])
            
            push!(values, (row, col, val))
        end
        
        
        matrixa::Matrix{Float64} = zeros(n, n)
        
        for tuple in values
            matrixa[tuple[1], tuple[2]] = tuple[3]
        end


        matfile::IO = open("./testmat.txt", "w")
        Base.print_matrix(matfile, matrixa)

        
        return (n, l, values)
    end
end


function readresultvec(path::String)
    open(path, "r") do io
        n::Int = 0
        val::Float64 = 0.0
        vecb::Vector{Float64} = []

        
        n = parse(Int, readline(io))

        while !eof(io)
            val = parse(Float64, readline(io))
            push!(vecb, val)
        end

        vecfile::IO = open("./testvec.txt", "w")
        Base.print_array(vecfile, vecb)
    end
end


# Tests
readmat = readmainmat(DATA_PATH_A)
test = MySpraseMatrix(readmat[1], readmat[2], readmat[3])
println(test.mymatrix)
println(test.mymatrix[4][1])
println(test.mymatrix[8][9])