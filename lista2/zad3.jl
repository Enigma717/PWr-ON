# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 2 Zadanie 3


using LinearAlgebra: cond, norm, rank

include("auxiliary/matcond.jl")
include("auxiliary/hilb.jl")


#Obliczanie wyniku za pomocą metody eliminacji Gaussa
function gaussmethod(matrix::Matrix{<:AbstractFloat},
               vector::Vector{<:AbstractFloat})::Vector{Float64}
    return matrix \ vector
end

#Obliczanie wyniku za pomocą odwrotności macierzy
function invmethod(matrix::Matrix{<:AbstractFloat}, 
                   vector::Vector{<:AbstractFloat})::Vector{Float64}
    return inv(matrix) * vector
end

#Obliczanie błędu względnego wyniku
function approxerror(approx::Vector{<:AbstractFloat},
                     real::Vector{<:AbstractFloat})::Float64
    return norm(approx - real) / norm(real)
end


function main()
    nvalues::Vector{Int} = [5, 10, 20]
    cvalues::Vector{Float64} = [1.0, 10.0, 10.0 ^ 3.0, 10.0 ^ 7.0, 10.0 ^ 12.0, 10.0 ^ 16.0]

    
    print("\n====================================================\n\n")
    
    println(">>> Hilbert matrix test (rank(a), cond(a), error for gauss, error for inv): ") 
    println("|") 

    for n in 1:20
        a::Matrix{Float64} = hilb(n)
        x::Vector{Float64} = ones(Float64, n)
        b::Vector{Float64} = a * x

        arank::Int = rank(a)
        acond::Float64 = cond(a)

        gaussres::Vector{Float64} = gaussmethod(a, b)
        gausserr::Float64 = approxerror(gaussres, b) 
        invres::Vector{Float64} = invmethod(a, b)
        inverr::Float64 = approxerror(invres, b)

        print("|--> Result for size = $n:\t$arank,\t$acond,\t$gausserr,\t$inverr\n") 
    end
    

    print("\n====================================================\n\n")


    println(">>> Random matrix test (rank(a), cond(a), error for gauss, error for inv): ") 
    println("|") 

    for n in nvalues
        println("|--> Results for size = $n:") 

        for c in cvalues
            a::Matrix{Float64} = matcond(n, c)
            x::Vector{Float64} = ones(Float64, n)
            b::Vector{Float64} = a * x
    
            arank::Int = rank(a)
            acond::Float64 = cond(a)
    
            gaussres::Vector{Float64} = gaussmethod(a, b)
            gausserr::Float64 = approxerror(gaussres, b) 
            invres::Vector{Float64} = invmethod(a, b)
            inverr::Float64 = approxerror(invres, b)
    
            print(" |--> cond = $c:\t$arank,\t$acond,\t$gausserr,\t$inverr\n") 
        end
    end

    print("\n====================================================\n\n")
end


main()