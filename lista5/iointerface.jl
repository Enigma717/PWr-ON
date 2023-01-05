# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5
#
# Funkcje obsługi plików


include("./mymatrix.jl")
using .blocksys


###########################
# Funkcje odczytu z pliku #
###########################

#=
    Odczytywanie głównej macierzy A z pliku w podanej ścieżce.
    Zwracanymi wartościami są rozmiar macierzy (n), rozmiar bloku (l)
    oraz wektor z wartościami na danych indeksach.
=#
function readmatrix(path::String)
    open(path, "r") do io
        n::Int = 0
        l::Int = 0
        row::Int = 0
        col::Int = 0
        val::Float64 = 0.0
        sizes::Vector{SubString{String}} = split(readline(io))
        values::Vector{Tuple{Int, Int, Float64}} = []
        
        n = parse(Int, sizes[1])
        l = parse(Int, sizes[2])

        while !eof(io)
            line = split(readline(io))
            row = parse(Int, line[1])
            col = parse(Int, line[2])
            val = parse(Float64, line[3])
            
            push!(values, (row, col, val))
        end
        
        return (n, l, values)
    end
end


#=
    Odczytywanie wektora prawych stron b z pliku w podanej ścieżce.
    Zwracanymi wartościami są rozmiar wektora (n) oraz sam wektor.
=#
function readvector(path::String)
    open(path, "r") do io
        n::Int = 0
        val::Float64 = 0.0
        resultvec::Vector{Float64} = []
        
        n = parse(Int, readline(io))

        while !eof(io)
            val = parse(Float64, readline(io))
            push!(resultvec, val)
        end

        return (n, resultvec)
    end
end



###########################
# Funkcje zapisu do pliku #
###########################

#=
    Zapisywanie do pliku wektora z wyliczonymi wartościami x.
=#
function writexresult(path::String, xvec::Vector{Float64})
    open(path, "w") do io
        for x in xvec
            write(io, "$x\n")
        end
    end
end


#=
    Zapisywanie do pliku wektora z wyliczonymi wartościami x
    oraz średnim błędem (w przypadku, gdy wektor prawych stron b
    był generowany funkcją solve_resultvector).
=#
function writexresult(path::String, xvec::Vector{Float64}, approxerror::Float64)
    open(path, "w") do io
        write(io, "$approxerror\n")

        for x in xvec
            write(io, "$x\n")
        end
    end
end