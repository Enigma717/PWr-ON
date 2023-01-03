# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 5


module blocksys


export MySpraseMatrix
export firstnzval_row, lastnzval_row,
       firstnzval_col, lastnzval_col,
       factorization_lu!, factorization_pivotlu!,
       solve_resultvector,
       solve_gauss!, solve_pivotgauss!,
       solve_lu!, solve_pivotlu!,
       solve_combinedlu!, solve_combinedpivotlu!



######################
# Struktura macierzy #
######################

#=
    Struktura z modelem macierzy rzadkiej z treści zadania.


    Z treści zadania rozmiar bloków musi być większy lub równy 2 oraz
    sam rozmiar głównej macierzy musi być podzielny przez niego.
    W wektorach rowslices i colslices przechowywane są przedziały, dla
    odpowiednio wierszy i kolumn głównej macierzy, w których zawarte są
    niezerowe wartości. Wtedy tworząc nową macierz, możemy łatwo w czasie O(1) 
    odczytywać indeksy, z których mamy przepisać do niej wartości z głównej macierzy. 
    W ten sposób efektywnie przechowujemy znaczące wartości z głównej macierzy,
    pozbywając się z niej niepotrzebnych macierzy zerowych. 


    Pola struktury:
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
    rowslices::Vector{UnitRange{Int}}
    colslices::Vector{UnitRange{Int}}
    matrixsize::Int
    blocksize::Int
    blockcount::Int

    
    function MySpraseMatrix(msize::Integer, bsize::Integer, values::Vector{Tuple{Int, Int, Float64}})
        matrix::Vector{Vector{Float64}} = Vector{Vector{Float64}}(undef, msize)
        rslices::Vector{UnitRange{Int}} = Vector{UnitRange{Int}}(undef, msize)
        cslices::Vector{UnitRange{Int}} = Vector{UnitRange{Int}}(undef, msize)
        bcount::Int = div(msize, bsize)
        row::Int = 0
        col::Int = 0
        val::Float64 = 0.0

        if (bsize < 2) || (msize % bsize != 0)
            println("Wrong matrix/blocks size!")

            return nothing
        end

        for i in 1:msize
            rslices[i] = firstnzval_row(bsize, i) : lastnzval_row(msize, bsize, i) 
            cslices[i] = firstnzval_col(bsize, i) : lastnzval_col(msize, bsize, i) 
            matrix[i] = zeros(length(rslices[i]))
        end
        
        for tuple in values
            row = tuple[1]
            col = tuple[2]
            val = tuple[3]

            matrix[row][(col - rslices[row].start) + 1] = val
        end

        new(matrix, rslices, cslices, msize, bsize, bcount)
    end
end



################################
# Indeksy niezerowych wartości #
################################

#= 
    Funkcja zwracająca indeks kolumny zawierającej 
    pierwszy niezerowy element w danym wierszu.
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
    ostatni niezerowy element w danym wierszu.
=#
function lastnzval_row(msize::Integer, bsize::Integer, rowindex::Integer)
    index::Int = min(msize, bsize + rowindex)

    return index
end


#= 
    Funkcja zwracająca indeks wiersza zawierającego
    pierwszy niezerowy element w danej kolumnie.
=#
function firstnzval_col(bsize::Integer, colindex::Integer)
    index::Int = max(1, colindex - bsize)

    return index
end


#= 
    Funkcja zwracająca indeks wiersza zawierającego 
    ostatni niezerowy element w danej kolumnie.
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



######################################
# Przeciążenie funkcji z modułu Base #
######################################

#=
    Przeciążenie odczytywania elementu na danym indeksie 
    we własnej macierzy rzadkiej.

    W przypadku próby wyszukania elementu spoza macierzy zwracamy
    wartość 0.0. Wynika to z racji, że w zaimplementowanej w strukturze 
    macierzy długości wierszy (wewnętrznych wektorów) mogą mocno się 
    miedzy sobą różnić. Wtedy przy obliczaniu układu równań nie musimy
    przy każdej iteracji sprawdzać, czy nie wypadliśmy poza macierz oraz
    nie musimy trzymać w naszej macierzy niepotrzebnych zer (których
    przyjęcie w obliczeniach nie zmienia nam wyniku).
=#
function Base.getindex(mat::MySpraseMatrix, rowindex::Integer, colindex::Integer)
    if colindex ∉ mat.rowslices[rowindex]
        return 0.0
    end

    value::Float64 = mat.mymatrix[rowindex][(colindex - mat.rowslices[rowindex].start) + 1]
    
    return value
end


#=
    Przeciążenie nadpisywania elementu na danym indeksie 
    we własnej macierzy rzadkiej.

    W przypadku próby nadpisania elementu na indeksie poza
    macierzą dopisujemy do danego wiersza wartość 0.0.
=#
function Base.setindex!(mat::MySpraseMatrix, value::Float64, rowindex::Integer, colindex::Integer)
    if colindex ∉ mat.rowslices[rowindex]
        push!(mat.mymatrix[rowindex], 0.0)

        mat.rowslices[rowindex] = mat.rowslices[rowindex].start : (mat.rowslices[rowindex].stop + 1)
    end
    
    mat.mymatrix[rowindex][(colindex - mat.rowslices[rowindex].start) + 1] = value
end


#=
=#
function Base.:*(mat::MySpraseMatrix, vec::Vector{Float64})
    if mat.matrixsize != length(vec)
        println("Incorrect matrix and vector size!")
        return nothing
    end

    result::Vector{Float64} = zeros(Float64, mat.matrixsize)

    for row in 1:mat.matrixsize
        for col in mat.rowslices[row]
            result[row] += mat[row, col] * vec[col]
        end
    end

    return result
end



#######################################
# Obliczanie układów równań liniowych #
#######################################

# Obliczanie wektora prawych stron b dla x ∈ [1, 1, 1, ..., 1].
function solve_resultvector(mat::MySpraseMatrix)
    resultvec::Vector{Float64} = zeros(Float64, mat.matrixsize)

    for row in 1:mat.matrixsize
        for col in mat.rowslices[row]
            resultvec[row] += mat[row, col]
        end
    end

    return resultvec
end


########## GAUSS ##########

#=
    Rozwiązywanie układu równań liniowych Ax = b za pomocą 
    metody Gaussa bez wyboru elementu głównego.
=#
function solve_gauss!(mat::MySpraseMatrix, resultvec::Vector{Float64})
    xvec::Vector{Float64} = Vector{Float64}(undef, mat.matrixsize)
    factor::Float64 = 0.0

    for col in 1:(mat.matrixsize - 1)
        for row in (col + 1):mat.colslices[col].stop
            factor = mat[row, col] / mat[col, col]
            mat[row, col] = 0.0

            for currcol in (col + 1):mat.rowslices[col].stop
                mat[row, currcol] -= mat[col, currcol] * factor
            end

            resultvec[row] -= resultvec[col] * factor
        end
    end


    for row in mat.matrixsize:-1:1
        xvec[row] = resultvec[row]

        for col in (row + 1):mat.rowslices[row].stop
            xvec[row] -= xvec[col] * mat[row, col]
        end

        xvec[row] /= mat[row, row]
    end

    return xvec
end


#=
    Rozwiązywanie układu równań liniowych Ax = b za pomocą 
    metody Gaussa z częściowym wyborem elementu głównego.

    W macierzy roworder zapisujemy kolejność rzędów macierzy, które
    domyślnie będą w postaci roworder ∈ [1, 2, 3, ..., mat.matrixsize].
    W wyniku obliczania częściowego elementu głównego wykonujemy operację
    elementarną w postaci zamienienia ze sobą dwóch wierszy (tego, w którym
    aktualnie jesteśmy, z tym, w którym znaleźliśmy większą wartość). 
    W takiej sytuacji zamieniamy odpowiednie wartości w naszym wektorze, przez co 
    nie modyfikujemy naszej głównej macierzy, a jedynie odwołujemy się do 
    odpowiednich wierszy z wektora roworder, zamiast bezpośrednio do badanego indeksu.
=#
function solve_pivotgauss!(mat::MySpraseMatrix, resultvec::Vector{Float64})
    xvec::Vector{Float64} = Vector{Float64}(undef, mat.matrixsize)
    roworder::Vector{Int} = collect(1:mat.matrixsize)
    factor::Float64 = 0.0
    maxincol_index::Int = 0
    newbound::Int = 0

    for col in 1:(mat.matrixsize - 1)
        maxincol_index = col
        
        for row in (col + 1):mat.colslices[col].stop
            if abs(mat[row, col]) > abs(mat[maxincol_index, col])
                maxincol_index = row
            end
        end

        if maxincol_index != col
            roworder[maxincol_index], roworder[col] = roworder[col], roworder[maxincol_index]
        end


        for row in (col + 1):mat.colslices[col].stop
            factor = mat[roworder[row], col] / mat[roworder[col], col]
            mat[roworder[row], col] = 0.0

            newbound = lastnzval_row(mat.matrixsize, mat.blocksize, col + mat.blocksize)
            for currcol in (col + 1):newbound
                mat[roworder[row], currcol] -= mat[roworder[col], currcol] * factor
            end

            resultvec[roworder[row]] -= resultvec[roworder[col]] * factor
        end
    end


    for row in mat.matrixsize:-1:1
        xvec[row] = resultvec[roworder[row]]

        newbound = lastnzval_row(mat.matrixsize, mat.blocksize, row + mat.blocksize)
        for col in (row + 1):newbound
            xvec[row] -= xvec[col] * mat[roworder[row], col] 
        end

        xvec[row] /= mat[roworder[row], row]
    end

    return xvec
end


########## LU ##########

#=
    Wyznaczanie rozkładu LU bez wyboru elementu głównego.
=#
function factorization_lu!(mat::MySpraseMatrix)
    factor::Float64 = 0.0

    for col in 1:(mat.matrixsize - 1)
        for row in (col + 1):mat.colslices[col].stop
            factor = mat[row, col] / mat[col, col]
            mat[row, col] = factor

            for currcol in (col + 1):mat.rowslices[col].stop
                mat[row, currcol] -= mat[col, currcol] * factor
            end
        end
    end
end


#=
    Wyznaczanie rozkładu LU z częściowym wyborem elementu głównego
=#
function factorization_pivotlu!(mat::MySpraseMatrix)
    roworder::Vector{Int} = collect(1:mat.matrixsize)
    factor::Float64 = 0.0
    maxincol_index::Int = 0
    newrowbound::Int = 0

    for col in 1:(mat.matrixsize - 1)
        maxincol_index = col
        
        for row in (col + 1):mat.colslices[col].stop
            if abs(mat[row, col]) > abs(mat[maxincol_index, col])
                maxincol_index = row
            end
        end

        if maxincol_index != col
            roworder[maxincol_index], roworder[col] = roworder[col], roworder[maxincol_index]
        end


        for row in (col + 1):mat.colslices[col].stop
            factor = mat[roworder[row], col] / mat[roworder[col], col]
            mat[roworder[row], col] = factor

            newrowbound = lastnzval_row(mat.matrixsize, mat.blocksize, col + mat.blocksize)
            for currcol in (col + 1):newrowbound
                mat[roworder[row], currcol] -= mat[roworder[col], currcol] * factor
            end
        end
    end

    return roworder
end


#=
    Rozwiązywanie układu równań liniowych Ax = b z wyznaczonym 
    rozkładem LU (LUx = b) bez wyboru elementu głównego.
=#
function solve_lu!(mat::MySpraseMatrix, resultvec::Vector{Float64})
    xvec::Vector{Float64} = Vector{Float64}(undef, mat.matrixsize)

    for col in 1:(mat.matrixsize - 1)
        for row in (col + 1):mat.colslices[col].stop
            resultvec[row] -= resultvec[col] * mat[row, col]
        end
    end

    for row in mat.matrixsize:-1:1
        xvec[row] = resultvec[row]

        for col in (row + 1):mat.rowslices[row].stop
            xvec[row] -= xvec[col] * mat[row, col]
        end

        xvec[row] /= mat[row, row]
    end

    return xvec
end


#=
    Rozwiązywanie układu równań liniowych Ax = b z wyznaczonym 
    rozkładem LU (LUx = b) z częściowym wyborem elementu głównego.
=#
function solve_pivotlu!(mat::MySpraseMatrix, resultvec::Vector{Float64}, roworder::Vector{<:Integer})
    xvec::Vector{Float64} = Vector{Float64}(undef, mat.matrixsize)

    for row in 2:mat.matrixsize
        for col in mat.rowslices[roworder[row]].start:(row - 1)
            resultvec[roworder[row]] -= resultvec[roworder[col]] * mat[roworder[row], col]
        end
    end

    for row in mat.matrixsize:-1:1
        xvec[row] = resultvec[roworder[row]]

        newbound = lastnzval_row(mat.matrixsize, mat.blocksize, row + mat.blocksize)
        for col in (row + 1):newbound
            xvec[row] -= xvec[col] * mat[roworder[row], col]
        end

        xvec[row] /= mat[roworder[row], row]
    end

    return xvec
end


#=
    Połączone w jednej funkcji wyznaczanie rozkładu LU bez wyboru elementu głównego 
    oraz rozwiązywanie dla niego układu równań liniowych. 
=#
function solve_combinedlu!(mat::MySpraseMatrix, resultvec::Vector{Float64})
    factorization_lu!(mat)
    solution::Vector{Float64} = solve_lu!(mat, resultvec)

    return solution
end


#=
    Połączone w jednej funkcji wyznaczanie rozkładu LU z częściowym wyborem elementu 
    głównego oraz rozwiązywanie dla niego układu równań liniowych. 
=#
function solve_combinedpivotlu!(mat::MySpraseMatrix, resultvec::Vector{Float64})
    order::Vector{Int} = factorization_pivotlu!(mat)
    solution::Vector{Float64} = solve_pivotlu!(mat, resultvec, order)

    return solution
end


# koniec modułu blocksys
end