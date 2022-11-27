# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 3 Zadanie 4


include("./functions.jl")
using .RootsFunctions


function main()
    # Funkcja f(x) = sin(x) - ((1/2) * x) ^ 2 i jej pochodna
    func::Function = x -> sin(x) - ((x / 2.0) ^ 2) 
    derivative::Function = x -> cos(x) - (x / 2.0) 

    # Dokładności obliczeń
    delta::Float64 = 0.5 * (10.0 ^ -5)
    epsilon::Float64 = 0.5 * (10.0 ^ -5)

    # Argumentamy funkcji
    abvalues::Tuple{Float64, Float64} = (1.5, 2.0)
    secantxvalues::Tuple{Float64, Float64} = (1.0, 2.0)
    newtonxvalue::Float64 = 1.5
    maxit::Int = 64

    # Struktura z rozwiązaniem
    result::RootFuncResult = RootFuncResult(0.0, 0.0, 0, 0)


    print("\n====================================================\n")

    result = mbisekcji(func,
                       abvalues[1], abvalues[2],
                       delta, epsilon)
    print("\n>>> Bisection method test results for $func:\n")
    println(" |--> r = $(result.root)")
    println(" |--> v = $(result.rootvalue)")
    println(" |--> it = $(result.iterations)")
    println(" |--> err = $(result.error)")
        
    print("\n----------------------------------------\n")

    result = mstycznych(func, derivative,
                        newtonxvalue,
                        delta, epsilon, 
                        maxit)
    print("\n>>> Newton's method test results for $func:\n")
    println(" |--> r = $(result.root)")
    println(" |--> v = $(result.rootvalue)")
    println(" |--> it = $(result.iterations)")
    println(" |--> err = $(result.error)")

    print("\n----------------------------------------\n")
    
    result = msiecznych(func, 
                        secantxvalues[1], secantxvalues[2],
                        delta, epsilon, 
                        maxit)
    print("\n>>> Secant method test results for $func:\n")
    println(" |--> r = $(result.root)")
    println(" |--> v = $(result.rootvalue)")
    println(" |--> it = $(result.iterations)")
    println(" |--> err = $(result.error)")

    print("\n====================================================\n")
end

main()