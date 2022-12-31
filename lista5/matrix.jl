# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5


module blocksys

export MySpraseMatrix
export firstnzval_row, lastnzval_row,
       firstnzval_col, lastnzval_col



######################
# Struktura macierzy #
######################

#=
Struktura z modelem macierzy rzadkiej z treści zadania

    mymatrix   - Wektor wektorów zawierający wiersze z niezerowymi 
                 wartościami z głównej macierzy
    rowslices  - Wektor zawierający przedziały, w których znajdują się 
                 niezerowe wartości każdego wierszu głównej macierzy
    colslices  - Wektor zawierający przedziały, w których znajdują się 
                 niezerowe wartości każdej kolumny głównej macierzy
    matrixsize - Rozmiar głównej macierzy
    blocksize  - Rozmiar pojedynczego bloku w macierzy
    blockcount - Liczba bloków w głównej macierzy
=#
mutable struct MySpraseMatrix
    mymatrix::Vector{Vector{Float64}}
    rowslices::Vector{UnitRange}
    colslices::Vector{UnitRange}
    matrixsize::Int
    blocksize::Int
    blockcount::Int

    
    function MySpraseMatrix(msize::Int, 
                            bsize::Int, 
                            values::Vector{Tuple{Int, Int, Float64}})

        matrix::Vector{Vector{Float64}} = Vector{Vector{Float64}}(undef, msize)
        rslices::Vector{UnitRange} = Vector{UnitRange}(undef, msize)
        cslices::Vector{UnitRange} = Vector{UnitRange}(undef, msize)
        bcount::Int = div(msize, bsize)

        for i in 1:msize
            rslices[i] = firstnzval_row(bsize, i) : lastnzval_row(msize, bsize, i) 
            cslices[i] = firstnzval_col(bsize, i) : lastnzval_col(msize, bsize, i) 
            matrix[i] = zeros(length(rslices[i]))
        end
        println("=====================")
        println(rslices)
        println("=====================")
        println(cslices)
        println("=====================")
        display(matrix)
        println("=====================")
        
        for tuple in values
            row::Int = tuple[1]
            col::Int = tuple[2]
            val::Float64 = tuple[3]

            matrix[row][(col - rslices[row].start) + 1] = val
        end

        display(matrix)
        println("=====================")


        new(matrix,
            rslices,
            cslices,
            msize,
            bsize,
            bcount)
    end
end



################################
# Indeksy niezerowych wartości #
################################

#= 
    Funkcja zwracająca indeks kolumny zawierającej 
    pierwszy niezerowy element w danym wierszu
=#
function firstnzval_row(bsize::Integer, rowindex::Integer)
    temp::Int = 0
    if (rowindex - 1) % bsize == 0
        temp = rowindex - bsize
    else
        temp = bsize * div(rowindex - 1, bsize)
    end

    index::Int = max(1, temp)

    return index
end


#= 
    Funkcja zwracająca indeks kolumny zawierającej 
    ostatni niezerowy element w danym wierszu
=#
function lastnzval_row(msize::Integer, bsize::Integer, rowindex::Integer)
    index::Int = min(msize, bsize + rowindex)

    return index
end


#= 
    Funkcja zwracająca indeks wiersza zawierającego
    pierwszy niezerowy element w danej kolumnie
=#
function firstnzval_col(bsize::Integer, colindex::Integer)
    index::Int = max(1, colindex - bsize)

    return index
end


#= 
    Funkcja zwracająca indeks wiersza zawierającego 
    ostatni niezerowy element w danej kolumnie
=#
function lastnzval_col(msize::Integer, bsize::Integer, colindex::Integer)
    temp::Int = 0
    if colindex % bsize == 0
        temp = colindex + bsize
    else
        temp = (bsize * div(colindex, bsize, RoundUp)) + 1
    end

    index::Int = min(msize, temp)

    return index
end



#########################
# Indeksowanie macierzy #
#########################

function Base.getindex(mat::MySpraseMatrix, rowindex::Integer, colindex::Integer)
    value::Float64 = mat.values[rowindex][(colindex - mat.rowslices[rowindex].start) + 1]
    
    return value
end


function Base.setindex!(mat::MySpraseMatrix, value::Float64, rowindex::Integer, colindex::Integer)
    mat.values[rowindex][(colindex - mat.rowslices[rowindex].start) + 1] = value
end


end
