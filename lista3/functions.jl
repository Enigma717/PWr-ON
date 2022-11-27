# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 3 Zadanie 1, 2, 3


module RootsFunctions

export RootFuncResult
export RESULT_ERROR_ONE, RESULT_ERROR_TWO
export mbisekcji, mstycznych, msiecznych



#####################
# Struktura + błędy #
#####################

#= 
Struktura z rozwiązaniem funkcji

    root = przybliżenie znalezionego miejsca zerowego
    rootvalue = wartość funkcji w znalezionym miejscu zerowym
    itreations = liczba przebytych iteracji
    error = kod błędu

=#
struct RootFuncResult
    root::Float64
    rootvalue::Float64
    iterations::Int
    error::Int
end


#= 
Stałe kodów błędów

    RESULT_ERROR_ONE = funkcja nie zmienia znaku w przedziale (mbisekcji) / 
                       nie osiągnięto wymaganej dokładności w maxit iteracji      
    RESULT_ERROR_TWO = pochodna bliska zeru

=#
const RESULT_ERROR_ONE = RootFuncResult(0.0, 0.0, 0, 1)
const RESULT_ERROR_TWO = RootFuncResult(0.0, 0.0, 0, 2)



#########################
# Implementacje funkcji #
#########################

#=
Obliczanie miejsca zerowego funkcji f za pomocą metody bisekcji

    f = funkcja, której rozwiązania szukamy
    a = lewy koniec przedziału początkowego
    b = prawy koniec przedziału początkowego
    delta = dokładność obliczeń
    epsilon = dokładność obliczeń
    
=#
function mbisekcji(f::Function, a::Float64, b::Float64,
                   delta::Float64, epsilon::Float64)::RootFuncResult
    avalue::Float64 = f(a)
    bvalue::Float64 = f(b)
    r::Float64 = 0.0
    v::Float64 = 0.0
    it::Int = 0

    
    if avalue * bvalue > 0
        return RESULT_ERROR_ONE
    end

    while b - a > epsilon
        it += 1
        r = (a + b) / 2.0
        v = f(r)
        
        if abs(b - a) < delta || abs(v) < epsilon
            return RootFuncResult(r, v, it, 0)
        end

        if avalue * v > 0
            a = r
        else
            b = r
        end
    end
end


#=
Obliczanie miejsca zerowego funkcji f za pomocą metody stycznych Newtona

    f = funkcja, której rozwiązania szukamy
    pf = pochodna funkcji f
    x0 = przybliżenie początkowe
    delta = dokładność obliczeń
    epsilon = dokładność obliczeń
    maxit = maksymalna dopuszczalna liczba iteracji

=#
function mstycznych(f::Function, pf::Function, x0::Float64,
                    delta::Float64, epsilon::Float64, maxit::Int)::RootFuncResult
    r::Float64 = 0.0
    v::Float64 = f(x0) 
    dvalue::Float64 = 0.0

    if abs(v) < epsilon
        return RootFuncResult(x0, v, 0, 0)
    end

    for it::Int in 1:1:maxit
        dvalue = pf(x0)

        if abs(dvalue) < epsilon
            return RESULT_ERROR_TWO
        end

        r = x0 - (v / dvalue)
        v = f(r)

        if abs(r - x0) < delta || abs(v) < epsilon
            return RootFuncResult(r, v, it, 0)
        end

        x0 = r
    end

    return RESULT_ERROR_ONE
end


#=
Obliczanie miejsca zerowego funkcji f za pomocą metody siecznych

    f = funkcja, której rozwiązania szukamy
    x0 = przybliżenie początkowe
    x1 = przybliżenie początkowe
    delta = dokładność obliczeń
    epsilon = dokładność obliczeń
    maxit = maksymalna dopuszczalna liczba iteracji

=#
function msiecznych(f::Function, x0::Float64, x1::Float64,
                    delta::Float64, epsilon::Float64, maxit::Int)::RootFuncResult
    x0value::Float64 = f(x0)
    x1value::Float64 = f(x1) 
    secant::Float64 = 0.0

    for it::Int in 1:maxit
        if abs(x0value) > abs(x1value)
            x0, x1 = x1, x0
            x0value, x1value = x1value, x0value
        end
        
        secant = (x1 - x0) / (x1value - x0value)
        x1 = x0
        x1value = x0value
        x0 -= x0value * secant
        x0value = f(x0)

        if abs(x1 - x0) < delta || abs(x0value) < epsilon
            return RootFuncResult(x0, x0value, it, 0)
        end
    end

    return RESULT_ERROR_ONE
end


end
