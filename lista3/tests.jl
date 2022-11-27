# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 3 Zadanie 1, 2, 3


include("./functions.jl")
using .RootsFunctions


function main()
    # Wektory z funkcjami i ich pochodne
    functions::Vector{Function} = [x -> sin(x) - ((x / 2) ^ 2)] 
    derivatives::Vector{Function} = [x -> cos(x) - (x / 2)] 

    # Dokładności obliczeń
    delta::Float64 = 0.5 * (10.0 ^ -5.0)
    epsilon::Float64 = 0.5 * (10.0 ^ -5.0)

    # Wektory z argumentami funkcji
    abvalues::Vector{Tuple} = [(1.5, 2.0)]
    newtonxvalues::Vector{Float64} = [1.5]
    secantxvalues::Vector{Tuple} = [(1.0, 2.0)]
    maxitvalues::Vector{Int} = [20]

    # Struktura z rozwiązaniem
    result::RootFuncResult = RootFuncResult(0.0, 0.0, 0, 0)


    for (index, func) in enumerate(functions)
        print("\n====================================================\n")

        result = mbisekcji(func,
                           abvalues[index][1], abvalues[index][2],
                           delta, epsilon)
        print("\n>>> Bisection method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
        
        print("\n----------------------------------------\n")

        result = mstycznych(func, derivatives[index],
                            newtonxvalues[index],
                            delta, epsilon, 
                            maxitvalues[index])
        print("\n>>> Newton's method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")

        print("\n----------------------------------------\n")

        result = msiecznych(func, 
                            secantxvalues[index][1], secantxvalues[index][2],
                            delta, epsilon, 
                            maxitvalues[index])
        print("\n>>> Newton's method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
    end
    
    print("\n====================================================\n")
end

main()